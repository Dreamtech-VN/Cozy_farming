package vn.dreamtech.game.server.battle.tower;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.battle.BattleService;
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

class TowerHttpFlowTest {
    private HttpServer server;
    private int port;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:tower_http_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE character_levels (user_id INT NOT NULL PRIMARY KEY, level INT NOT NULL DEFAULT 1, exp INT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, gold BIGINT NOT NULL DEFAULT 0, diamond BIGINT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE challenge_attempts (user_id INT NOT NULL, challenge_type VARCHAR(10) NOT NULL, last_completed_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, challenge_type))");
            st.execute("CREATE TABLE tower_records (user_id INT NOT NULL, tower_id INT NOT NULL, best_floor INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, tower_id))");
        }
        BattleService battleService = new BattleService(new LevelDao(dataSource), new WalletDao(dataSource), new ChallengeAttemptDao(dataSource), new TowerRecordDao(dataSource));

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/battle/tower/list", new TowerListHandler());
        server.createContext("/api/battle/tower/start", new StartTowerHandler(battleService));
        server.createContext("/api/battle/tower/leaderboard", new TowerLeaderboardHandler(battleService));
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
    void listReturnsTowers() throws Exception {
        var res = get("/api/battle/tower/list");
        assertEquals(200, res.statusCode());
        assertTrue(res.body().contains("Tháp vô tận"));
    }

    @Test
    void startUnknownTowerRejected() throws Exception {
        var res = post("/api/battle/tower/start", new StartTowerHandler.Req(1, 999));
        assertEquals(404, res.statusCode());
    }

    @Test
    void startReturnsFirstFloorState() throws Exception {
        var res = post("/api/battle/tower/start", new StartTowerHandler.Req(1, 1));
        assertEquals(201, res.statusCode());
        JsonObject body = gson.fromJson(res.body(), JsonObject.class);
        assertEquals("TOWER", body.get("mode").getAsString());
        assertEquals(1, body.get("floorIndex").getAsInt());
        assertEquals(30, body.get("totalFloors").getAsInt());
    }

    @Test
    void leaderboardMissingTowerIdRejected() throws Exception {
        var res = get("/api/battle/tower/leaderboard");
        assertEquals(400, res.statusCode());
    }

    @Test
    void leaderboardEmptyByDefault() throws Exception {
        var res = get("/api/battle/tower/leaderboard?towerId=1");
        assertEquals(200, res.statusCode());
        assertEquals("[]", res.body());
    }
}
