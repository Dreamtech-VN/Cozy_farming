package vn.dreamtech.game.server.pvp;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.admin.AdminAdjustPvpRankHandler;
import vn.dreamtech.game.server.admin.AdminPvpMatchHistoryHandler;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.ChallengeAttemptDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.PvpMatchHistoryDao;
import vn.dreamtech.game.server.dao.PvpRankDao;
import vn.dreamtech.game.server.dao.TowerRecordDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.model.Character;

import javax.sql.DataSource;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PvpHttpFlowTest {
    private HttpServer server;
    private int port;
    private UserDao userDao;
    private CharacterDao characterDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:pvp_http_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
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
        BattleService battleService = new BattleService(levelDao, walletDao, new ChallengeAttemptDao(dataSource), new TowerRecordDao(dataSource));
        PvpRankDao pvpRankDao = new PvpRankDao(dataSource);
        PvpMatchHistoryDao pvpMatchHistoryDao = new PvpMatchHistoryDao(dataSource);
        PvpService pvpService = new PvpService(characterDao, battleService, pvpRankDao, pvpMatchHistoryDao);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/pvp/queue/join", new JoinQueueHandler(pvpService));
        server.createContext("/api/pvp/queue/leave", new LeaveQueueHandler(pvpService));
        server.createContext("/api/pvp/match/start", new StartMatchHandler(pvpService));
        server.createContext("/api/pvp/match/report", new ReportScoreHandler(pvpService));
        server.createContext("/api/pvp/match/status", new MatchStatusHandler(pvpService));
        server.createContext("/api/pvp/match/my", new MyMatchHandler(pvpService));
        server.createContext("/api/pvp/rank", new RankHandler(pvpService));
        server.createContext("/api/pvp/leaderboard", new RankingListHandler(pvpService));
        server.createContext("/api/admin/pvp/rank/adjust", new AdminAdjustPvpRankHandler(userDao, pvpRankDao));
        server.createContext("/api/admin/pvp/match/history", new AdminPvpMatchHistoryHandler(pvpMatchHistoryDao));
        server.setExecutor(null);
        server.start();
        port = server.getAddress().getPort();
    }

    @AfterEach
    void stop() {
        server.stop(0);
    }

    private HttpResponse<String> post(String path, Object body) throws Exception {
        var req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + path))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(gson.toJson(body)))
                .build();
        return http.send(req, HttpResponse.BodyHandlers.ofString());
    }

    private HttpResponse<String> get(String path) throws Exception {
        var req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + path)).GET().build();
        return http.send(req, HttpResponse.BodyHandlers.ofString());
    }

    private int newPlayer(String name) throws SQLException {
        int userId = userDao.createGuest("tok-" + name + "-" + System.nanoTime()).id();
        characterDao.create(new Character(userId, name, 0, 1, 1, 1));
        return userId;
    }

    @Test
    void joinWithoutCharacterRejected() throws Exception {
        int userId = userDao.createGuest("tok-nochar").id();
        var res = post("/api/pvp/queue/join", new JoinQueueHandler.Req(userId));
        assertEquals(404, res.statusCode());
    }

    @Test
    void rankDefaultsWithoutAnyMatch() throws Exception {
        int userId = newPlayer("Solo");
        var res = get("/api/pvp/rank?userId=" + userId);
        assertEquals(200, res.statusCode());
        JsonObject body = gson.fromJson(res.body(), JsonObject.class);
        assertEquals(1000, body.get("rating").getAsInt());
    }

    @Test
    void myMatchWithoutQueueingRejected() throws Exception {
        int userId = newPlayer("Solo");
        var res = get("/api/pvp/match/my?userId=" + userId);
        assertEquals(404, res.statusCode());
    }

    @Test
    void fullCycle_queueBothPlayersThenStart() throws Exception {
        int p1 = newPlayer("P1");
        int p2 = newPlayer("P2");

        var join1 = post("/api/pvp/queue/join", new JoinQueueHandler.Req(p1));
        assertEquals(200, join1.statusCode());
        JsonObject body1 = gson.fromJson(join1.body(), JsonObject.class);
        assertEquals(false, body1.get("matched").getAsBoolean());

        var join2 = post("/api/pvp/queue/join", new JoinQueueHandler.Req(p2));
        assertEquals(200, join2.statusCode());
        JsonObject body2 = gson.fromJson(join2.body(), JsonObject.class);
        assertEquals(true, body2.get("matched").getAsBoolean());
        String matchId = body2.get("matchId").getAsString();

        var myMatch = get("/api/pvp/match/my?userId=" + p1);
        assertEquals(200, myMatch.statusCode());

        var start = post("/api/pvp/match/start", new StartMatchHandler.Req(p1, matchId));
        assertEquals(201, start.statusCode());
        JsonObject battle = gson.fromJson(start.body(), JsonObject.class);
        assertEquals("PVP", battle.get("mode").getAsString());

        var status = get("/api/pvp/match/status?matchId=" + matchId);
        assertEquals(200, status.statusCode());
        assertTrue(status.body().contains(matchId));

        var leaderboard = get("/api/pvp/leaderboard");
        assertEquals(200, leaderboard.statusCode());
    }

    @Test
    void adminAdjustPvpRankRequiresAdminToken() throws Exception {
        int userId = newPlayer("Solo");
        var res = post("/api/admin/pvp/rank/adjust", new AdminAdjustPvpRankHandler.Req(userId, 100, false));
        assertEquals(503, res.statusCode());
    }

    @Test
    void adminPvpMatchHistoryRequiresAdminToken() throws Exception {
        int userId = newPlayer("Solo");
        var res = get("/api/admin/pvp/match/history?userId=" + userId);
        assertEquals(503, res.statusCode());
    }
}
