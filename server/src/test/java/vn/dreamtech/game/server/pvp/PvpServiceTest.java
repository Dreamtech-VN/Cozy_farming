package vn.dreamtech.game.server.pvp;

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
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.PvpMatchHistoryDao;
import vn.dreamtech.game.server.dao.PvpRankDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.model.Character;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test PvpService trực tiếp (không HTTP — nối dây HTTP đã kiểm ở các *FlowTest khác trong dự án). */
class PvpServiceTest {
    private PvpService pvpService;
    private BattleService battleService;
    private UserDao userDao;
    private CharacterDao characterDao;
    private PvpRankDao rankDao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:pvp_service_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
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
            st.execute("CREATE TABLE pvp_ranks (user_id INT NOT NULL PRIMARY KEY, rating INT NOT NULL DEFAULT 1000, wins INT NOT NULL DEFAULT 0, losses INT NOT NULL DEFAULT 0, draws INT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE pvp_match_history (match_id VARCHAR(36) NOT NULL PRIMARY KEY, player_a INT NOT NULL, player_b INT NOT NULL, score_a INT NOT NULL, score_b INT NOT NULL, winner_user_id INT, resolved_at TIMESTAMP NOT NULL)");
        }
        userDao = new UserDao(dataSource);
        characterDao = new CharacterDao(dataSource);
        WalletDao walletDao = new WalletDao(dataSource);
        LevelDao levelDao = new LevelDao(dataSource);
        rankDao = new PvpRankDao(dataSource);
        PvpMatchHistoryDao historyDao = new PvpMatchHistoryDao(dataSource);
        battleService = new BattleService(levelDao, walletDao, new ChallengeAttemptDao(dataSource));
        pvpService = new PvpService(characterDao, battleService, rankDao, historyDao);
    }

    private int newPlayer(String name) throws SQLException {
        int userId = userDao.createGuest("tok-" + name + "-" + System.nanoTime()).id();
        characterDao.create(new Character(userId, name, 0, 1, 1, 1));
        return userId;
    }

    @Test
    void joinQueueWithoutCharacterRejected() throws SQLException {
        int userId = userDao.createGuest("tok-nochar").id();
        var e = assertThrows(PvpException.class, () -> pvpService.joinQueue(userId));
        assertEquals(404, e.status());
    }

    @Test
    void firstJoinerWaits() throws SQLException {
        int p1 = newPlayer("P1");
        var result = pvpService.joinQueue(p1);
        assertFalse(result.matched());
    }

    @Test
    void secondJoinerGetsMatchedImmediately() throws SQLException {
        int p1 = newPlayer("P1");
        int p2 = newPlayer("P2");
        pvpService.joinQueue(p1);
        var result = pvpService.joinQueue(p2);
        assertTrue(result.matched());
        assertNotNull(result.matchId());
        assertEquals(p1, result.opponentUserId());
    }

    @Test
    void multipleWaitersMatchedByClosestRatingWithinThreshold() throws SQLException {
        int p1 = newPlayer("P1"); // rating 1000 (mặc định)
        int p2 = newPlayer("P2");
        int p3 = newPlayer("P3");
        int p4 = newPlayer("P4");
        rankDao.save(new PvpRankDao.Rank(p2, 1500, 0, 0, 0)); // chênh 500 so với p1 -> ngoài ngưỡng 300
        rankDao.save(new PvpRankDao.Rank(p3, 1050, 0, 0, 0)); // chênh 50 so với p1 -> trong ngưỡng
        rankDao.save(new PvpRankDao.Rank(p4, 1450, 0, 0, 0)); // chênh 50 so với p2 -> trong ngưỡng

        var join1 = pvpService.joinQueue(p1);
        assertFalse(join1.matched()); // hàng chờ trống, p1 phải chờ

        var join2 = pvpService.joinQueue(p2);
        assertFalse(join2.matched()); // chênh rating với p1 quá ngưỡng -> KHÔNG ghép bừa, p2 cũng phải chờ
        // -> tại đây cả p1 lẫn p2 đang cùng chờ, chứng minh hàng chờ giữ được NHIỀU người cùng lúc

        var join3 = pvpService.joinQueue(p3); // gần p1 hơn p2 nhiều -> phải ghép với p1, không phải FIFO (p2 vào trước)
        assertTrue(join3.matched());
        assertEquals(p1, join3.opponentUserId());

        var join4 = pvpService.joinQueue(p4); // chỉ còn p2 đang chờ, đủ gần -> ghép với p2
        assertTrue(join4.matched());
        assertEquals(p2, join4.opponentUserId());
    }

    @Test
    void leaveQueueOnlyRemovesThatPlayer() throws SQLException {
        int p1 = newPlayer("P1");
        int p2 = newPlayer("P2");
        rankDao.save(new PvpRankDao.Rank(p2, 1500, 0, 0, 0)); // ngoài ngưỡng ghép với p1

        pvpService.joinQueue(p1);
        pvpService.joinQueue(p2); // cả 2 cùng chờ (rating cách xa nhau)

        pvpService.leaveQueue(p1);
        var e = assertThrows(PvpException.class, () -> pvpService.leaveQueue(p1));
        assertEquals(404, e.status()); // p1 đã rời rồi, rời lần nữa bị chặn

        // p2 vẫn còn trong hàng chờ -> người mới rating gần p2 sẽ ghép được
        int p3 = newPlayer("P3");
        rankDao.save(new PvpRankDao.Rank(p3, 1480, 0, 0, 0));
        var result = pvpService.joinQueue(p3);
        assertTrue(result.matched());
        assertEquals(p2, result.opponentUserId());
    }

    @Test
    void joinQueueTwiceRejected() throws SQLException {
        int p1 = newPlayer("P1");
        pvpService.joinQueue(p1);
        var e = assertThrows(PvpException.class, () -> pvpService.joinQueue(p1));
        assertEquals(409, e.status());
    }

    @Test
    void leaveQueueWithoutWaitingRejected() throws SQLException {
        int p1 = newPlayer("P1");
        var e = assertThrows(PvpException.class, () -> pvpService.leaveQueue(p1));
        assertEquals(404, e.status());
    }

    @Test
    void startMatchByNonParticipantRejected() throws SQLException {
        int p1 = newPlayer("P1");
        int p2 = newPlayer("P2");
        pvpService.joinQueue(p1);
        var matched = pvpService.joinQueue(p2);
        int outsider = newPlayer("Outsider");
        var e = assertThrows(PvpException.class, () -> pvpService.startMatch(outsider, matched.matchId()));
        assertEquals(403, e.status());
    }

    @Test
    void reportBeforeBattleEndsRejected() throws SQLException {
        int p1 = newPlayer("P1");
        int p2 = newPlayer("P2");
        pvpService.joinQueue(p1);
        var matched = pvpService.joinQueue(p2);
        BattleStateView view = pvpService.startMatch(p1, matched.matchId());
        var e = assertThrows(PvpException.class, () -> pvpService.reportScore(p1, matched.matchId(), view.battleId()));
        assertEquals(409, e.status());
    }

    @Test
    void fullMatch_bothPlayToEndThenReportResolvesAndUpdatesRating() throws SQLException {
        int p1 = newPlayer("P1");
        int p2 = newPlayer("P2");
        pvpService.joinQueue(p1);
        var matched = pvpService.joinQueue(p2);
        String matchId = matched.matchId();

        BattleStateView battleA = pvpService.startMatch(p1, matchId);
        BattleStateView battleB = pvpService.startMatch(p2, matchId);

        int finalDamageA = playToEnd(battleA.battleId());
        int finalDamageB = playToEnd(battleB.battleId());

        var reportA = pvpService.reportScore(p1, matchId, battleA.battleId());
        assertEquals(PvpMatchStatus.ONGOING, reportA.status()); // chưa đủ 2 bên report

        var reportB = pvpService.reportScore(p2, matchId, battleB.battleId());
        assertEquals(PvpMatchStatus.RESOLVED, reportB.status());
        assertEquals(finalDamageA, reportB.scoreA());
        assertEquals(finalDamageB, reportB.scoreB());

        if (finalDamageA > finalDamageB) {
            assertEquals(p1, reportB.winnerUserId());
        } else if (finalDamageB > finalDamageA) {
            assertEquals(p2, reportB.winnerUserId());
        } else {
            assertEquals(null, reportB.winnerUserId());
        }

        var rankP1 = pvpService.rank(p1);
        var rankP2 = pvpService.rank(p2);
        assertTrue(rankP1.wins() + rankP1.losses() + rankP1.draws() == 1);
        assertTrue(rankP2.wins() + rankP2.losses() + rankP2.draws() == 1);

        // report trùng bị chặn
        var e = assertThrows(PvpException.class, () -> pvpService.reportScore(p1, matchId, battleA.battleId()));
        assertEquals(409, e.status());
    }

    @Test
    void afterMatchResolvedCanQueueAgain() throws SQLException {
        int p1 = newPlayer("P1");
        int p2 = newPlayer("P2");
        pvpService.joinQueue(p1);
        var matched = pvpService.joinQueue(p2);
        BattleStateView battleA = pvpService.startMatch(p1, matched.matchId());
        BattleStateView battleB = pvpService.startMatch(p2, matched.matchId());
        playToEnd(battleA.battleId());
        playToEnd(battleB.battleId());
        pvpService.reportScore(p1, matched.matchId(), battleA.battleId());
        pvpService.reportScore(p2, matched.matchId(), battleB.battleId());

        // sau khi trận đã resolve, p1 vào hàng chờ mới được (không còn trận ONGOING)
        var result = pvpService.joinQueue(p1);
        assertFalse(result.matched());
    }

    private int playToEnd(String battleId) {
        int guard = 0;
        while (guard++ < 2000) {
            BattleStateView state = battleService.getState(battleId);
            if (state.status() != BattleStatus.ONGOING) return state.totalDamageDealt();
            int[] swap = findAnyMatchingSwap(state.board());
            if (swap == null) {
                // không tìm được nước khớp — vẫn phải tiêu lượt để tới move limit, đổi 2 ô bất kỳ liền kề
                swap = new int[]{0, 0, 0, 1};
            }
            battleService.swap(battleId, swap[0], swap[1], swap[2], swap[3]);
        }
        return battleService.getState(battleId).totalDamageDealt();
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
