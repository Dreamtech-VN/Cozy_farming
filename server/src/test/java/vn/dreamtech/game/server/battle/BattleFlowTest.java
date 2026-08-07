package vn.dreamtech.game.server.battle;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.dao.ChallengeAttemptDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.TowerRecordDao;
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

/** Test nối dây HTTP thật cho các endpoint /api/battle/* — logic chi tiết đã kiểm ở BattleServiceTest. */
class BattleFlowTest {
    private HttpServer server;
    private int port;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:battle_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE character_levels (user_id INT NOT NULL PRIMARY KEY, level INT NOT NULL DEFAULT 1, exp INT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, gold BIGINT NOT NULL DEFAULT 0, diamond BIGINT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE challenge_attempts (user_id INT NOT NULL, challenge_type VARCHAR(10) NOT NULL, last_completed_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, challenge_type))");
        }
        BattleService battleService = new BattleService(new LevelDao(dataSource), new WalletDao(dataSource), new ChallengeAttemptDao(dataSource), new TowerRecordDao(dataSource));

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/battle/story/levels", new StoryLevelsHandler());
        server.createContext("/api/battle/story/start", new StartStoryHandler(battleService));
        server.createContext("/api/battle/swap", new SwapHandler(battleService));
        server.createContext("/api/battle/ultimate", new UltimateHandler(battleService));
        server.createContext("/api/battle/state", new BattleStateHandler(battleService));
        server.createContext("/api/battle/challenge/start", new vn.dreamtech.game.server.battle.challenge.StartChallengeHandler(battleService));
        server.createContext("/api/battle/challenge/status", new vn.dreamtech.game.server.battle.challenge.ChallengeStatusHandler(battleService));
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
    void levelsListed() throws Exception {
        var res = get("/api/battle/story/levels");
        assertEquals(200, res.statusCode());
        assertTrue(res.body().contains("Cánh đồng ban mai"));
    }

    @Test
    void startUnknownLevelRejected() throws Exception {
        var res = post("/api/battle/story/start", new StartStoryHandler.Req(1, 999));
        assertEquals(404, res.statusCode());
    }

    @Test
    void fullCycle_startGetStateInvalidSwap() throws Exception {
        var start = post("/api/battle/story/start", new StartStoryHandler.Req(1, 1));
        assertEquals(201, start.statusCode());
        JsonObject started = gson.fromJson(start.body(), JsonObject.class);
        String battleId = started.get("battleId").getAsString();
        assertEquals("ONGOING", started.get("status").getAsString());

        var state = get("/api/battle/state?battleId=" + battleId);
        assertEquals(200, state.statusCode());

        var badSwap = post("/api/battle/swap", new SwapHandler.Req(battleId, 0, 0, 5, 5));
        assertEquals(400, badSwap.statusCode());

        var ultimateTooEarly = post("/api/battle/ultimate", new UltimateHandler.Req(battleId));
        assertEquals(400, ultimateTooEarly.statusCode());

        var unknownState = get("/api/battle/state?battleId=does-not-exist");
        assertEquals(404, unknownState.statusCode());
    }
}
