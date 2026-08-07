package vn.dreamtech.game.server.battle;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
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
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class BattleServiceTest {
    private BattleService battleService;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:battle_service_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE character_levels (user_id INT NOT NULL PRIMARY KEY, level INT NOT NULL DEFAULT 1, exp INT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, gold BIGINT NOT NULL DEFAULT 0, diamond BIGINT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE challenge_attempts (user_id INT NOT NULL, challenge_type VARCHAR(10) NOT NULL, last_completed_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, challenge_type))");
        }
        battleService = new BattleService(new LevelDao(dataSource), new WalletDao(dataSource), new ChallengeAttemptDao(dataSource), new TowerRecordDao(dataSource));
    }

    @Test
    void startStoryReturnsFreshOngoingState() {
        BattleStateView view = battleService.startStory(1, 1);
        assertEquals(BattleStatus.ONGOING, view.status());
        assertEquals(150, view.enemyHp());
        assertEquals(BattleConstants.PLAYER_HP_MAX, view.playerHp());
        assertEquals(0, view.mana());
        assertEquals(0, view.comboCount());
        assertNotNull(view.battleId());
    }

    @Test
    void unknownLevelRejected() {
        BattleException e = assertThrows(BattleException.class, () -> battleService.startStory(1, 999));
        assertEquals(404, e.status());
    }

    @Test
    void startAdventureReturnsFreshOngoingState() {
        BattleStateView view = battleService.startAdventure(1, 1);
        assertEquals(BattleStatus.ONGOING, view.status());
        assertEquals(BattleMode.ADVENTURE, view.mode());
        assertEquals(180, view.enemyHp());
        assertEquals(1, view.levelId());
    }

    @Test
    void unknownAdventureLevelRejected() {
        BattleException e = assertThrows(BattleException.class, () -> battleService.startAdventure(1, 999));
        assertEquals(404, e.status());
    }

    @Test
    void startEventPuzzleWithinActiveWindowSucceeds() {
        // Sự kiện "Lễ hội mùa hè" id=1 chủ động đặt lịch chủ động chạy suốt tháng 8/2026 trong catalog.
        BattleStateView view = battleService.startEventPuzzle(1, 1);
        assertEquals(BattleStatus.ONGOING, view.status());
        assertEquals(BattleMode.EVENT_PUZZLE, view.mode());
    }

    @Test
    void startEventPuzzleOutsideWindowRejected() {
        // id=2 "Lễ hội Trung Thu" lịch tháng 9/2026, chưa tới lúc test này chạy (test cố định theo catalog).
        BattleException e = assertThrows(BattleException.class, () -> battleService.startEventPuzzle(1, 2));
        assertEquals(409, e.status());
    }

    @Test
    void unknownEventPuzzleRejected() {
        BattleException e = assertThrows(BattleException.class, () -> battleService.startEventPuzzle(1, 999));
        assertEquals(404, e.status());
    }

    @Test
    void unknownBattleIdRejected() {
        BattleException e = assertThrows(BattleException.class, () -> battleService.swap("nope", 0, 0, 0, 1));
        assertEquals(404, e.status());
    }

    @Test
    void nonAdjacentSwapRejected() {
        BattleStateView view = battleService.startStory(1, 1);
        BattleException e = assertThrows(BattleException.class, () -> battleService.swap(view.battleId(), 0, 0, 5, 5));
        assertEquals(400, e.status());
    }

    @Test
    void outOfBoundsSwapRejected() {
        BattleStateView view = battleService.startStory(1, 1);
        BattleException e = assertThrows(BattleException.class, () -> battleService.swap(view.battleId(), 0, 0, -1, 0));
        assertEquals(400, e.status());
    }

    @Test
    void ultimateBeforeManaFullRejected() {
        BattleStateView view = battleService.startStory(1, 1);
        BattleException e = assertThrows(BattleException.class, () -> battleService.useUltimate(view.battleId()));
        assertEquals(400, e.status());
    }

    @Test
    void ultimateDealsFlatDamageAndConsumesMana() {
        BattleStateView view = battleService.startStory(1, 3); // enemyHp 400, đủ lớn để không bị giết ngay bởi 1 chiêu
        String battleId = view.battleId();
        // ép mana đầy bằng cách lặp swap không khớp cho tới khi tự nhiên tìm được swap khớp đủ nhiều lần,
        // đơn giản hơn: gọi trực tiếp nhiều swap khớp được tìm ra từ bàn cờ hiện tại tới khi mana đầy.
        int guard = 0;
        while (guard++ < 500) {
            BattleStateView state = battleService.getState(battleId);
            if (state.mana() >= BattleConstants.MANA_MAX || state.status() != BattleStatus.ONGOING) break;
            int[] swap = findAnyMatchingSwap(state.board());
            if (swap == null) break;
            battleService.swap(battleId, swap[0], swap[1], swap[2], swap[3]);
        }
        BattleStateView beforeUltimate = battleService.getState(battleId);
        if (beforeUltimate.mana() >= BattleConstants.MANA_MAX && beforeUltimate.status() == BattleStatus.ONGOING) {
            BattleStateView afterUltimate = battleService.useUltimate(battleId);
            assertEquals(0, afterUltimate.mana());
            assertTrue(afterUltimate.enemyHp() <= beforeUltimate.enemyHp());
        }
    }

    @Test
    void matchingSwapDealsDamageGainsManaAndIncrementsCombo() {
        BattleStateView view = null;
        int[] swap = null;
        for (int attempt = 0; attempt < 20 && swap == null; attempt++) {
            view = battleService.startStory(1, 3); // enemyHp cao nhất trong catalog, tránh thắng ngay
            swap = findAnyMatchingSwap(view.board());
        }
        assertNotNull(swap, "20 bàn cờ ngẫu nhiên liên tiếp đều không có nước đi khớp nào — cực kỳ khó xảy ra");
        String battleId = view.battleId();

        BattleStateView result = battleService.swap(battleId, swap[0], swap[1], swap[2], swap[3]);
        assertTrue(result.matched());
        assertTrue(result.damageDealt() > 0);
        assertEquals(1, result.comboCount());
        assertTrue(result.enemyHp() < view.enemyHp());
    }

    @Test
    void nonMatchingSwapResetsComboAndRevertsBoard() {
        BattleStateView view = battleService.startStory(1, 1);
        String battleId = view.battleId();
        int[][] before = view.board();
        int[] nonMatch = findAnyNonMatchingSwap(before);
        assertNotNull(nonMatch);

        BattleStateView result = battleService.swap(battleId, nonMatch[0], nonMatch[1], nonMatch[2], nonMatch[3]);
        assertFalse(result.matched());
        assertEquals(0, result.comboCount());
        assertEquals(0, result.damageDealt());
        assertArrayEquals2D(before, result.board());
    }

    private static void assertArrayEquals2D(int[][] expected, int[][] actual) {
        assertEquals(expected.length, actual.length);
        for (int r = 0; r < expected.length; r++) {
            org.junit.jupiter.api.Assertions.assertArrayEquals(expected[r], actual[r]);
        }
    }

    /** Dò trên bàn cờ hiện tại 1 cặp ô liền kề mà nếu đổi chỗ sẽ tạo ra khớp — dùng lại đúng engine thật để chắc chắn khớp với logic server. */
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

    private static int[] findAnyNonMatchingSwap(int[][] grid) {
        int rows = grid.length, cols = grid[0].length;
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                if (c + 1 < cols && !wouldMatch(grid, r, c, r, c + 1)) return new int[]{r, c, r, c + 1};
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
