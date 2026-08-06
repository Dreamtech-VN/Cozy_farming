package vn.dreamtech.game.server.social.marriage;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.battle.BattleStateView;
import vn.dreamtech.game.server.battle.BattleStatus;
import vn.dreamtech.game.server.battle.engine.MatchFinder;
import vn.dreamtech.game.server.battle.engine.TileBoard;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.ChallengeAttemptDao;
import vn.dreamtech.game.server.dao.FriendshipDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.MarriageActivityDao;
import vn.dreamtech.game.server.dao.MarriageDao;
import vn.dreamtech.game.server.dao.PresenceDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.guild.GuildException;
import vn.dreamtech.game.server.model.Character;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test MarriageActivityService trực tiếp (không HTTP). */
class MarriageActivityServiceTest {
    private MarriageActivityService activityService;
    private BattleService battleService;
    private UserDao userDao;
    private CharacterDao characterDao;
    private MarriageDao marriageDao;
    private PresenceDao presenceDao;
    private FriendshipDao friendshipDao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:marriage_activity_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
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
            st.execute("CREATE TABLE challenge_attempts (user_id INT NOT NULL, challenge_type VARCHAR(10) NOT NULL, last_completed_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, challenge_type))");
            st.execute("CREATE TABLE marriages (user_id_a INT NOT NULL, user_id_b INT NOT NULL, married_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id_a, user_id_b))");
            st.execute("CREATE TABLE friendships (user_id_a INT NOT NULL, user_id_b INT NOT NULL, intimacy_points INT NOT NULL DEFAULT 0, last_gift_at TIMESTAMP, created_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id_a, user_id_b))");
            st.execute("CREATE TABLE lobby_presence (user_id INT NOT NULL PRIMARY KEY, x INT NOT NULL, y INT NOT NULL, last_seen TIMESTAMP NOT NULL)");
            st.execute("""
                CREATE TABLE marriage_activity (
                  user_id_a INT NOT NULL, user_id_b INT NOT NULL,
                  last_online_tick_at TIMESTAMP, last_duo_quest_at TIMESTAMP,
                  coop_a_completed_at TIMESTAMP, coop_b_completed_at TIMESTAMP, coop_last_awarded_at TIMESTAMP,
                  PRIMARY KEY (user_id_a, user_id_b)
                )
                """);
        }
        userDao = new UserDao(dataSource);
        characterDao = new CharacterDao(dataSource);
        WalletDao walletDao = new WalletDao(dataSource);
        LevelDao levelDao = new LevelDao(dataSource);
        marriageDao = new MarriageDao(dataSource);
        friendshipDao = new FriendshipDao(dataSource);
        presenceDao = new PresenceDao(dataSource);
        MarriageActivityDao activityDao = new MarriageActivityDao(dataSource);
        battleService = new BattleService(levelDao, walletDao, new ChallengeAttemptDao(dataSource));
        activityService = new MarriageActivityService(marriageDao, activityDao, friendshipDao, presenceDao, battleService);
    }

    private int newPlayer(String name) throws SQLException {
        int userId = userDao.createGuest("tok-" + name + "-" + System.nanoTime()).id();
        characterDao.create(new Character(userId, name, 0, 1, 1, 1));
        return userId;
    }

    private void marry(int a, int b) throws SQLException {
        friendshipDao.create(a, b, System.currentTimeMillis());
        marriageDao.create(a, b, System.currentTimeMillis());
    }

    @Test
    void onlineTickWithoutMarriageRejected() throws SQLException {
        int solo = newPlayer("Solo");
        var e = assertThrows(GuildException.class, () -> activityService.onlineTick(solo));
        assertEquals(404, e.status());
    }

    @Test
    void onlineTickWithoutSpouseOnlineNotAwarded() throws SQLException {
        int a = newPlayer("A");
        int b = newPlayer("B");
        marry(a, b);
        presenceDao.heartbeat(a, 0, 0, System.currentTimeMillis());

        var result = activityService.onlineTick(a);
        assertFalse(result.awarded());
        assertEquals(0, result.intimacyPoints());
    }

    @Test
    void onlineTickWithBothOnlineAwarded() throws SQLException {
        int a = newPlayer("A");
        int b = newPlayer("B");
        marry(a, b);
        long now = System.currentTimeMillis();
        presenceDao.heartbeat(a, 0, 0, now);
        presenceDao.heartbeat(b, 0, 0, now);

        var result = activityService.onlineTick(a);
        assertTrue(result.awarded());
        assertEquals(MarriageActivityConstants.ONLINE_TICK_INTIMACY, result.intimacyPoints());
    }

    @Test
    void onlineTickCooldownBlocksImmediateRetick() throws SQLException {
        int a = newPlayer("A");
        int b = newPlayer("B");
        marry(a, b);
        long now = System.currentTimeMillis();
        presenceDao.heartbeat(a, 0, 0, now);
        presenceDao.heartbeat(b, 0, 0, now);
        activityService.onlineTick(a);

        var second = activityService.onlineTick(a);
        assertFalse(second.awarded());
        assertEquals(MarriageActivityConstants.ONLINE_TICK_INTIMACY, second.intimacyPoints());
    }

    @Test
    void duoQuestRequiresBothOnline() throws SQLException {
        int a = newPlayer("A");
        int b = newPlayer("B");
        marry(a, b);
        presenceDao.heartbeat(a, 0, 0, System.currentTimeMillis());

        var e = assertThrows(GuildException.class, () -> activityService.claimDuoQuest(a));
        assertEquals(409, e.status());
    }

    @Test
    void duoQuestClaimedOnceThenCooldown() throws SQLException {
        int a = newPlayer("A");
        int b = newPlayer("B");
        marry(a, b);
        long now = System.currentTimeMillis();
        presenceDao.heartbeat(a, 0, 0, now);
        presenceDao.heartbeat(b, 0, 0, now);

        var first = activityService.claimDuoQuest(a);
        assertTrue(first.awarded());
        assertEquals(MarriageActivityConstants.DUO_QUEST_INTIMACY, first.intimacyPoints());

        var e = assertThrows(GuildException.class, () -> activityService.claimDuoQuest(a));
        assertEquals(409, e.status());
    }

    @Test
    void coopBattleStartWithoutMarriageRejected() throws SQLException {
        int solo = newPlayer("Solo");
        var e = assertThrows(GuildException.class, () -> activityService.startCoopBattle(solo));
        assertEquals(404, e.status());
    }

    @Test
    void coopBattleStartsPersonalInstance() throws SQLException {
        int a = newPlayer("A");
        int b = newPlayer("B");
        marry(a, b);

        BattleStateView view = activityService.startCoopBattle(a);
        assertEquals(BattleStatus.ONGOING, view.status());
        assertEquals(vn.dreamtech.game.server.battle.BattleMode.MARRIAGE_COOP, view.mode());
        assertEquals(MarriageActivityConstants.COOP_BATTLE_HP, view.enemyHp());
    }

    @Test
    void reportBeforeBattleEndsRejected() throws SQLException {
        int a = newPlayer("A");
        int b = newPlayer("B");
        marry(a, b);
        BattleStateView view = activityService.startCoopBattle(a);

        var e = assertThrows(GuildException.class, () -> activityService.reportCoopBattle(a, view.battleId()));
        assertEquals(409, e.status());
    }

    @Test
    void onlySpouseCompletedNoBonusYet() throws SQLException {
        int a = newPlayer("A");
        int b = newPlayer("B");
        marry(a, b);
        BattleStateView view = activityService.startCoopBattle(a);
        finishBattle(view.battleId());

        var report = activityService.reportCoopBattle(a, view.battleId());
        assertFalse(report.bonusAwarded());
    }

    @Test
    void bothSpousesCompleteWithinWindowAwardsBonusOnce() throws SQLException {
        int a = newPlayer("A");
        int b = newPlayer("B");
        marry(a, b);

        BattleStateView viewA = activityService.startCoopBattle(a);
        finishBattle(viewA.battleId());
        activityService.reportCoopBattle(a, viewA.battleId());

        BattleStateView viewB = activityService.startCoopBattle(b);
        finishBattle(viewB.battleId());
        var reportB = activityService.reportCoopBattle(b, viewB.battleId());
        assertTrue(reportB.bonusAwarded());
        assertEquals(MarriageActivityConstants.COOP_BATTLE_INTIMACY, reportB.intimacyPoints());

        // vòng tiếp theo chưa ai đánh lại -> không cộng thêm nữa dù gọi report lần nữa cũng không thể (đã report rồi)
        var friendship = friendshipDao.find(a, b).orElseThrow();
        assertEquals(MarriageActivityConstants.COOP_BATTLE_INTIMACY, friendship.intimacyPoints());
    }

    private void finishBattle(String battleId) {
        int guard = 0;
        while (guard++ < 2000) {
            BattleStateView state = battleService.getState(battleId);
            if (state.status() != BattleStatus.ONGOING) break;
            int[] swap = findAnyMatchingSwap(state.board());
            if (swap == null) break;
            battleService.swap(battleId, swap[0], swap[1], swap[2], swap[3]);
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
