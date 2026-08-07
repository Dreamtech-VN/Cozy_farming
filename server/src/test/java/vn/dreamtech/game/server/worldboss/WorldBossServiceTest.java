package vn.dreamtech.game.server.worldboss;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.battle.BattleMode;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.battle.BattleStateView;
import vn.dreamtech.game.server.battle.BattleStatus;
import vn.dreamtech.game.server.battle.engine.MatchFinder;
import vn.dreamtech.game.server.battle.engine.TileBoard;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.ChallengeAttemptDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.TowerRecordDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.dao.WorldBossAttemptDao;
import vn.dreamtech.game.server.dao.WorldBossContributionDao;
import vn.dreamtech.game.server.dao.WorldBossCycleDao;
import vn.dreamtech.game.server.model.Character;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;

/** Test WorldBossService trực tiếp (không HTTP — nối dây HTTP đã kiểm ở các *FlowTest khác trong dự án). */
class WorldBossServiceTest {
    private WorldBossService worldBossService;
    private BattleService battleService;
    private UserDao userDao;
    private CharacterDao characterDao;
    private WalletDao walletDao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:world_boss_service_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE users (
                  id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(50) UNIQUE, password_hash VARCHAR(255),
                  guest_token VARCHAR(64) UNIQUE, google_id VARCHAR(128) UNIQUE, apple_id VARCHAR(128) UNIQUE,
                  display_name VARCHAR(50), created_at TIMESTAMP NOT NULL
                )
                """);
            st.execute("""
                CREATE TABLE characters (
                  user_id INT NOT NULL PRIMARY KEY, name VARCHAR(20) NOT NULL UNIQUE, gender TINYINT NOT NULL,
                  hair_id INT NOT NULL, top_id INT NOT NULL, bottom_id INT NOT NULL, created_at TIMESTAMP NOT NULL
                )
                """);
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, gold BIGINT NOT NULL DEFAULT 0, diamond BIGINT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE character_levels (user_id INT NOT NULL PRIMARY KEY, level INT NOT NULL DEFAULT 1, exp INT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE world_boss_cycle (id INT NOT NULL PRIMARY KEY, remaining_hp INT NOT NULL, cycle_started_at TIMESTAMP NOT NULL, cycle_ends_at TIMESTAMP NOT NULL)");
            st.execute("CREATE TABLE world_boss_attempts (user_id INT NOT NULL PRIMARY KEY, cycle_started_at TIMESTAMP NOT NULL)");
            st.execute("CREATE TABLE world_boss_contributions (user_id INT NOT NULL, cycle_started_at TIMESTAMP NOT NULL, total_damage INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, cycle_started_at))");
            st.execute("CREATE TABLE challenge_attempts (user_id INT NOT NULL, challenge_type VARCHAR(10) NOT NULL, last_completed_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, challenge_type))");
        }
        userDao = new UserDao(dataSource);
        characterDao = new CharacterDao(dataSource);
        walletDao = new WalletDao(dataSource);
        LevelDao levelDao = new LevelDao(dataSource);
        WorldBossCycleDao cycleDao = new WorldBossCycleDao(dataSource);
        WorldBossAttemptDao attemptDao = new WorldBossAttemptDao(dataSource);
        WorldBossContributionDao contributionDao = new WorldBossContributionDao(dataSource);
        battleService = new BattleService(levelDao, walletDao, new ChallengeAttemptDao(dataSource), new TowerRecordDao(dataSource));
        worldBossService = new WorldBossService(characterDao, cycleDao, attemptDao, contributionDao, battleService, levelDao, walletDao);
    }

    private int newPlayer(String name) throws SQLException {
        int userId = userDao.createGuest("tok-" + name + "-" + System.nanoTime()).id();
        characterDao.create(new Character(userId, name, 0, 1, 1, 1));
        return userId;
    }

    @Test
    void attackWithoutCharacterRejected() throws SQLException {
        int userId = userDao.createGuest("tok-nochar").id();
        var e = assertThrows(WorldBossException.class, () -> worldBossService.attack(userId));
        assertEquals(404, e.status());
    }

    @Test
    void attackStatusWithoutCharacterFalse() throws SQLException {
        int userId = userDao.createGuest("tok-nochar2").id();
        var status = worldBossService.attackStatus(userId);
        assertFalse(status.canAttack());
    }

    @Test
    void attackDoesNotRequireGuild() throws SQLException {
        int userId = newPlayer("Solo");
        BattleStateView view = worldBossService.attack(userId);
        assertEquals(BattleStatus.ONGOING, view.status());
        assertEquals(BattleMode.WORLD_BOSS, view.mode());
        assertEquals(WorldBossConstants.PERSONAL_ENGAGE_HP, view.enemyHp());
    }

    @Test
    void secondAttackSameCycleRejected() throws SQLException {
        int userId = newPlayer("Solo");
        worldBossService.attack(userId);
        var e = assertThrows(WorldBossException.class, () -> worldBossService.attack(userId));
        assertEquals(409, e.status());
    }

    @Test
    void statusReturnsFullPoolInitially() {
        var status = worldBossService.status();
        assertEquals(WorldBossConstants.POOL_HP, status.remainingHp());
        assertEquals(WorldBossConstants.POOL_HP, status.poolMaxHp());
    }

    @Test
    void statusSharedAcrossPlayers() throws SQLException {
        int p1 = newPlayer("P1");
        int p2 = newPlayer("P2");
        worldBossService.attack(p1);
        // p2 chưa đánh, nhưng vẫn thấy chung 1 HP pool với p1 (không theo guild)
        var status1 = worldBossService.status();
        worldBossService.attack(p2);
        var status2 = worldBossService.status();
        assertEquals(status1.cycleStartedAt(), status2.cycleStartedAt());
    }

    @Test
    void reportBeforeBattleEndsRejected() throws SQLException {
        int userId = newPlayer("Solo");
        BattleStateView view = worldBossService.attack(userId);
        var e = assertThrows(WorldBossException.class, () -> worldBossService.report(userId, view.battleId()));
        assertEquals(409, e.status());
    }

    @Test
    void reportByWrongUserRejected() throws SQLException {
        int userId = newPlayer("Solo");
        BattleStateView view = worldBossService.attack(userId);
        int other = newPlayer("Other");
        var e = assertThrows(WorldBossException.class, () -> worldBossService.report(other, view.battleId()));
        assertEquals(403, e.status());
    }

    @Test
    void fullCycle_fightToEndThenReportAppliesDamageAndReward() throws SQLException {
        int userId = newPlayer("Solo");
        BattleStateView view = worldBossService.attack(userId);
        String battleId = view.battleId();
        long goldBeforeReport = walletDao.find(userId).gold();

        int guard = 0;
        while (guard++ < 2000) {
            BattleStateView state = battleService.getState(battleId);
            if (state.status() != BattleStatus.ONGOING) break;
            int[] swap = findAnyMatchingSwap(state.board());
            if (swap == null) break;
            battleService.swap(battleId, swap[0], swap[1], swap[2], swap[3]);
        }

        BattleStateView finalState = battleService.getState(battleId);
        var report = worldBossService.report(userId, battleId);
        assertEquals(finalState.totalDamageDealt(), report.damageApplied());
        assertEquals(WorldBossConstants.POOL_HP - report.damageApplied(), report.remainingHp());

        var status = worldBossService.status();
        assertEquals(report.remainingHp(), status.remainingHp());

        if (report.damageApplied() > 0) {
            assertEquals(goldBeforeReport + WorldBossConstants.REWARD_GOLD, walletDao.find(userId).gold());
            var leaderboard = worldBossService.leaderboard();
            assertEquals(1, leaderboard.size());
            assertEquals(userId, leaderboard.get(0).userId());
        }

        var e = assertThrows(WorldBossException.class, () -> worldBossService.report(userId, battleId));
        assertEquals(409, e.status());
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
