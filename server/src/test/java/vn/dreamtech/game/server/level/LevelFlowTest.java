package vn.dreamtech.game.server.level;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.admin.AdminSetLevelHandler;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.UserDao;

import javax.sql.DataSource;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;

class LevelFlowTest {
    private HttpServer server;
    private int port;
    private UserDao userDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:level_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE character_levels (user_id INT NOT NULL PRIMARY KEY, level INT NOT NULL DEFAULT 1, exp INT NOT NULL DEFAULT 0)");
            st.execute("""
                CREATE TABLE users (
                  id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(50) UNIQUE, password_hash VARCHAR(255),
                  guest_token VARCHAR(64) UNIQUE, google_id VARCHAR(128) UNIQUE, apple_id VARCHAR(128) UNIQUE,
                  display_name VARCHAR(50), created_at TIMESTAMP NOT NULL
                )
                """);
        }
        LevelDao levelDao = new LevelDao(dataSource);
        userDao = new UserDao(dataSource);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/level", new GetLevelHandler(levelDao));
        server.createContext("/api/level/add-exp", new AddExpHandler(levelDao));
        server.createContext("/api/admin/level/set", new AdminSetLevelHandler(userDao, levelDao));
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
    void defaultsToLevel1() throws Exception {
        var res = get("/api/level?userId=1");
        JsonObject body = gson.fromJson(res.body(), JsonObject.class);
        assertEquals(1, body.get("level").getAsInt());
    }

    @Test
    void negativeExpRejected() throws Exception {
        var res = post("/api/level/add-exp", new AddExpHandler.Req(1, -5));
        assertEquals(400, res.statusCode());
    }

    @Test
    void addExpLevelsUpThenPersists() throws Exception {
        var res = post("/api/level/add-exp", new AddExpHandler.Req(1, 250));
        assertEquals(200, res.statusCode());
        JsonObject body = gson.fromJson(res.body(), JsonObject.class);
        assertEquals(2, body.get("level").getAsInt());
        assertEquals(150, body.get("exp").getAsInt());

        var fetched = get("/api/level?userId=1");
        assertEquals(2, gson.fromJson(fetched.body(), JsonObject.class).get("level").getAsInt());
    }

    @Test
    void adminSetLevelRequiresAdminToken() throws Exception {
        int userId = userDao.createGuest("tok-level-" + System.nanoTime()).id();
        var res = post("/api/admin/level/set", new AdminSetLevelHandler.Req(userId, 10, 0));
        assertEquals(503, res.statusCode());
    }
}
