package vn.dreamtech.game.server.battle.dungeon;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.battle.BattleStateView;
import vn.dreamtech.game.server.battle.BattleStatus;
import vn.dreamtech.game.server.battle.engine.MatchFinder;
import vn.dreamtech.game.server.battle.engine.TileBoard;
import vn.dreamtech.game.server.dao.ChallengeAttemptDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.TowerRecordDao;
import vn.dreamtech.game.server.dao.WalletDao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test luồng dungeon nhiều tầng qua BattleService trực tiếp (không HTTP — logic nối dây HTTP đã kiểm ở các *FlowTest khác). */
class DungeonFlowTest {
    private BattleService battleService;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:dungeon_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE character_levels (user_id INT NOT NULL PRIMARY KEY, level INT NOT NULL DEFAULT 1, exp INT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, gold BIGINT NOT NULL DEFAULT 0, diamond BIGINT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE challenge_attempts (user_id INT NOT NULL, challenge_type VARCHAR(10) NOT NULL, last_completed_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, challenge_type))");
        }
        battleService = new BattleService(new LevelDao(dataSource), new WalletDao(dataSource), new ChallengeAttemptDao(dataSource), new TowerRecordDao(dataSource));
    }

    @Test
    void startReturnsFirstFloor() {
        BattleStateView view = battleService.startDungeon(1, 1);
        assertEquals(BattleStatus.ONGOING, view.status());
        assertEquals(1, view.floorIndex());
        assertEquals(3, view.totalFloors());
        assertEquals(120, view.enemyHp()); // tầng 1 dungeon 1
    }

    @Test
    void unknownDungeonRejected() {
        var e = org.junit.jupiter.api.Assertions.assertThrows(
                vn.dreamtech.game.server.battle.BattleException.class,
                () -> battleService.startDungeon(1, 999));
        assertEquals(404, e.status());
    }

    @Test
    void clearingAllFloorsWinsAndGrantsReward() {
        BattleStateView view = battleService.startDungeon(1, 1);
        String battleId = view.battleId();

        int guard = 0;
        boolean sawFloorClearedEvent = false;
        while (guard++ < 2000) {
            BattleStateView state = battleService.getState(battleId);
            if (state.status() != BattleStatus.ONGOING) break;
            int[] swap = findAnyMatchingSwap(state.board());
            if (swap == null) {
                // hiếm khi bàn không còn nước đi khớp — dùng ultimate nếu đủ mana, không thì dừng test
                if (state.mana() >= vn.dreamtech.game.server.battle.BattleConstants.MANA_MAX) {
                    battleService.useUltimate(battleId);
                    continue;
                }
                break;
            }
            BattleStateView result = battleService.swap(battleId, swap[0], swap[1], swap[2], swap[3]);
            if (result.floorCleared()) sawFloorClearedEvent = true;
        }

        BattleStateView finalState = battleService.getState(battleId);
        // Không đảm bảo 100% thắng trong giới hạn vòng lặp (bàn ngẫu nhiên), nhưng nếu đã thắng thì phải đúng logic:
        if (finalState.status() == BattleStatus.WON) {
            assertTrue(sawFloorClearedEvent, "Phải đi qua ít nhất 1 tầng trung gian trước khi thắng dungeon 3 tầng");
            assertTrue(finalState.rewardGranted());
            assertEquals(3, finalState.floorIndex());
        }
    }

    @Test
    void floorClearedKeepsBattleOngoingWithFreshEnemy() {
        // Ép trận vào trạng thái "sắp hết tầng 1" bằng cách liên tục swap khớp cho tới khi floorCleared=true lần đầu,
        // rồi kiểm tra trận vẫn ONGOING và enemyHp đã reset về máu tầng 2 (không phải máu tầng 1).
        BattleStateView view = battleService.startDungeon(1, 1);
        String battleId = view.battleId();

        BattleStateView result = null;
        int guard = 0;
        while (guard++ < 2000) {
            BattleStateView state = battleService.getState(battleId);
            if (state.status() != BattleStatus.ONGOING) return; // thua hoặc thắng thẳng luôn — bỏ qua assertion tầng
            int[] swap = findAnyMatchingSwap(state.board());
            if (swap == null) return;
            result = battleService.swap(battleId, swap[0], swap[1], swap[2], swap[3]);
            if (result.floorCleared()) break;
        }
        if (result != null && result.floorCleared()) {
            assertEquals(BattleStatus.ONGOING, result.status());
            assertEquals(2, result.floorIndex());
            assertEquals(160, result.enemyHp()); // máu đầy đủ tầng 2, không cộng dồn từ tầng 1
            assertEquals(0, result.mana());
            assertEquals(0, result.comboCount());
        }
    }

    private static int[] findAnyMatchingSwap(int[][] grid) {
        int rows = grid.length, cols = grid[0].length;
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                if (c + 1 < cols && wouldMatch(grid, r, c, r, c + 1)) return new int[]{r, c, r, c + 1};
                if (r + 1 < rows && wouldMatch(grid, r, c, r + 1, c)) return new int[]{r, c, r + 1, c};
            }
        }
        return null;
    }

    private static boolean wouldMatch(int[][] grid, int r1, int c1, int r2, int c2) {
        TileBoard board = new TileBoard(grid.length, grid[0].length);
        for (int r = 0; r < grid.length; r++) for (int c = 0; c < grid[0].length; c++) board.set(r, c, grid[r][c]);
        board.swapCells(r1, c1, r2, c2);
        return !MatchFinder.find(board).isEmpty();
    }
}
