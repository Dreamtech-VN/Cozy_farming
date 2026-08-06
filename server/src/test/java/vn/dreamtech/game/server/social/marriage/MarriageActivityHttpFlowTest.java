package vn.dreamtech.game.server.social.marriage;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.ChallengeAttemptDao;
import vn.dreamtech.game.server.dao.FriendshipDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.MarriageActivityDao;
import vn.dreamtech.game.server.dao.MarriageDao;
import vn.dreamtech.game.server.dao.PresenceDao;
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
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test nối dây HTTP thật cho các endpoint /api/marriage/online-tick, /duo-quest/claim, /battle/* — logic chi tiết đã kiểm ở MarriageActivityServiceTest. */
class MarriageActivityHttpFlowTest {
    private HttpServer server;
    private int port;
    private UserDao userDao;
    private CharacterDao characterDao;
    private MarriageDao marriageDao;
    private FriendshipDao friendshipDao;
    private PresenceDao presenceDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:marriage_activity_http_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
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
        BattleService battleService = new BattleService(levelDao, walletDao, new ChallengeAttemptDao(dataSource));
        MarriageActivityService activityService = new MarriageActivityService(marriageDao, activityDao, friendshipDao, presenceDao, battleService);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/marriage/online-tick", new OnlineTickHandler(activityService));
        server.createContext("/api/marriage/duo-quest/claim", new ClaimDuoQuestHandler(activityService));
        server.createContext("/api/marriage/battle/start", new StartCoopBattleHandler(activityService));
        server.createContext("/api/marriage/battle/report", new ReportCoopBattleHandler(activityService));
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
    void onlineTickWithoutMarriageRejected() throws Exception {
        int solo = newPlayer("Solo");
        var res = post("/api/marriage/online-tick", new OnlineTickHandler.Req(solo));
        assertEquals(404, res.statusCode());
    }

    @Test
    void onlineTickAwardedWhenBothOnline() throws Exception {
        int a = newPlayer("A");
        int b = newPlayer("B");
        marry(a, b);
        long now = System.currentTimeMillis();
        presenceDao.heartbeat(a, 0, 0, now);
        presenceDao.heartbeat(b, 0, 0, now);

        var res = post("/api/marriage/online-tick", new OnlineTickHandler.Req(a));
        assertEquals(200, res.statusCode());
        JsonObject body = gson.fromJson(res.body(), JsonObject.class);
        assertTrue(body.get("awarded").getAsBoolean());
    }

    @Test
    void duoQuestRequiresBothOnline() throws Exception {
        int a = newPlayer("A");
        int b = newPlayer("B");
        marry(a, b);

        var res = post("/api/marriage/duo-quest/claim", new ClaimDuoQuestHandler.Req(a));
        assertEquals(409, res.statusCode());
    }

    @Test
    void fullCycle_startCoopBattleThenReportBeforeEndRejected() throws Exception {
        int a = newPlayer("A");
        int b = newPlayer("B");
        marry(a, b);

        var start = post("/api/marriage/battle/start", new StartCoopBattleHandler.Req(a));
        assertEquals(201, start.statusCode());
        JsonObject battle = gson.fromJson(start.body(), JsonObject.class);
        assertEquals("MARRIAGE_COOP", battle.get("mode").getAsString());

        var reportOngoing = post("/api/marriage/battle/report", new ReportCoopBattleHandler.Req(a, battle.get("battleId").getAsString()));
        assertEquals(409, reportOngoing.statusCode());
    }

    @Test
    void coopBattleStartWithoutMarriageRejected() throws Exception {
        int solo = newPlayer("Solo");
        var res = post("/api/marriage/battle/start", new StartCoopBattleHandler.Req(solo));
        assertEquals(404, res.statusCode());
    }
}
