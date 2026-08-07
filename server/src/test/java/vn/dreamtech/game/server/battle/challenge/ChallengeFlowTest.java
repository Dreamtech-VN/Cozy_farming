package vn.dreamtech.game.server.battle.challenge;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.battle.BattleStateHandler;
import vn.dreamtech.game.server.battle.SwapHandler;
import vn.dreamtech.game.server.battle.UltimateHandler;
import vn.dreamtech.game.server.dao.TowerRecordDao;
import vn.dreamtech.game.server.dao.ChallengeAttemptDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.WalletDao;

import javax.sql.DataSource;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ChallengeFlowTest {
    private HttpServer server;
    private int port;
    private ChallengeAttemptDao challengeAttemptDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:challenge_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE character_levels (user_id INT NOT NULL PRIMARY KEY, level INT NOT NULL DEFAULT 1, exp INT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, gold BIGINT NOT NULL DEFAULT 0, diamond BIGINT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE challenge_attempts (user_id INT NOT NULL, challenge_type VARCHAR(10) NOT NULL, last_completed_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, challenge_type))");
        }
        challengeAttemptDao = new ChallengeAttemptDao(dataSource);
        BattleService battleService = new BattleService(new LevelDao(dataSource), new WalletDao(dataSource), challengeAttemptDao, new TowerRecordDao(dataSource));

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/battle/challenge/start", new StartChallengeHandler(battleService));
        server.createContext("/api/battle/challenge/status", new ChallengeStatusHandler(battleService));
        server.createContext("/api/battle/swap", new SwapHandler(battleService));
        server.createContext("/api/battle/ultimate", new UltimateHandler(battleService));
        server.createContext("/api/battle/state", new BattleStateHandler(battleService));
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

    @Test
    void statusAvailableByDefault() throws Exception {
        var res = get("/api/battle/challenge/status?userId=1&type=DAILY");
        assertEquals(200, res.statusCode());
        JsonObject body = gson.fromJson(res.body(), JsonObject.class);
        assertTrue(body.get("available").getAsBoolean());
        assertEquals(0, body.get("cooldownRemainingMs").getAsLong());
    }

    @Test
    void invalidTypeRejected() throws Exception {
        var res = post("/api/battle/challenge/start", new StartChallengeHandler.Req(1, "MONTHLY"));
        assertEquals(400, res.statusCode());
    }

    @Test
    void startChallengeCreatesOngoingBattle() throws Exception {
        var res = post("/api/battle/challenge/start", new StartChallengeHandler.Req(1, "DAILY"));
        assertEquals(201, res.statusCode());
        JsonObject body = gson.fromJson(res.body(), JsonObject.class);
        assertEquals("ONGOING", body.get("status").getAsString());
        assertEquals("DAILY", body.get("mode").getAsString());
    }

    @Test
    void secondAttemptBlockedAfterCompletion() throws Exception {
        challengeAttemptDao.recordCompletion(1, ChallengeType.DAILY, System.currentTimeMillis());
        var statusRes = get("/api/battle/challenge/status?userId=1&type=DAILY");
        JsonObject status = gson.fromJson(statusRes.body(), JsonObject.class);
        assertEquals(false, status.get("available").getAsBoolean());
        assertTrue(status.get("cooldownRemainingMs").getAsLong() > 0);

        var startRes = post("/api/battle/challenge/start", new StartChallengeHandler.Req(1, "DAILY"));
        assertEquals(429, startRes.statusCode());
    }

    @Test
    void availableAgainAfterCooldownExpired() throws Exception {
        long longAgo = System.currentTimeMillis() - ChallengeType.DAILY.cooldownMs - 1000;
        challengeAttemptDao.recordCompletion(1, ChallengeType.DAILY, longAgo);

        var startRes = post("/api/battle/challenge/start", new StartChallengeHandler.Req(1, "DAILY"));
        assertEquals(201, startRes.statusCode());
    }
}
