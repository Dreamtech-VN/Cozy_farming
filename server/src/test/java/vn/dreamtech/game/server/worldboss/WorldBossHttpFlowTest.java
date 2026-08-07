package vn.dreamtech.game.server.worldboss;

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
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.TowerRecordDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.dao.WorldBossAttemptDao;
import vn.dreamtech.game.server.dao.WorldBossContributionDao;
import vn.dreamtech.game.server.dao.WorldBossCycleDao;
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

class WorldBossHttpFlowTest {
    private HttpServer server;
    private int port;
    private UserDao userDao;
    private CharacterDao characterDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:world_boss_http_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
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
        WalletDao walletDao = new WalletDao(dataSource);
        LevelDao levelDao = new LevelDao(dataSource);
        BattleService battleService = new BattleService(levelDao, walletDao, new ChallengeAttemptDao(dataSource), new TowerRecordDao(dataSource));
        WorldBossService worldBossService = new WorldBossService(characterDao, new WorldBossCycleDao(dataSource),
                new WorldBossAttemptDao(dataSource), new WorldBossContributionDao(dataSource), battleService, levelDao, walletDao);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/world-boss/attack", new AttackHandler(worldBossService));
        server.createContext("/api/world-boss/report", new ReportBossResultHandler(worldBossService));
        server.createContext("/api/world-boss/status", new StatusHandler(worldBossService));
        server.createContext("/api/world-boss/attack-status", new AttackStatusHandler(worldBossService));
        server.createContext("/api/world-boss/leaderboard", new LeaderboardHandler(worldBossService));
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
    void attackWithoutCharacterRejected() throws Exception {
        int userId = userDao.createGuest("tok-nochar").id();
        var res = post("/api/world-boss/attack", new AttackHandler.Req(userId));
        assertEquals(404, res.statusCode());
    }

    @Test
    void statusAccessibleWithoutAnyPlayer() throws Exception {
        var res = get("/api/world-boss/status");
        assertEquals(200, res.statusCode());
        assertTrue(res.body().contains("\"remainingHp\":50000"));
    }

    @Test
    void fullCycle_attackThenReportOngoingRejected() throws Exception {
        int userId = newPlayer("Solo");
        var attack = post("/api/world-boss/attack", new AttackHandler.Req(userId));
        assertEquals(201, attack.statusCode());
        JsonObject battle = gson.fromJson(attack.body(), JsonObject.class);
        assertEquals("WORLD_BOSS", battle.get("mode").getAsString());

        var reportOngoing = post("/api/world-boss/report", new ReportBossResultHandler.Req(userId, battle.get("battleId").getAsString()));
        assertEquals(409, reportOngoing.statusCode());

        var leaderboard = get("/api/world-boss/leaderboard");
        assertEquals(200, leaderboard.statusCode());
    }
}
