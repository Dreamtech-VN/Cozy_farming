package vn.dreamtech.game.server.lobby;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.PresenceDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.model.Character;

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

/** Test trọn luồng sảnh (presence qua REST polling) qua HTTP thật, DB H2 nhúng. */
class LobbyFlowTest {
    private HttpServer server;
    private int port;
    private int userId;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:lobby_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
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
            st.execute("CREATE TABLE lobby_presence (user_id INT NOT NULL PRIMARY KEY, x INT NOT NULL, y INT NOT NULL, last_seen TIMESTAMP NOT NULL)");
        }
        UserDao userDao = new UserDao(dataSource);
        CharacterDao characterDao = new CharacterDao(dataSource);
        PresenceDao presenceDao = new PresenceDao(dataSource);
        userId = userDao.createGuest("tok-1").id();
        characterDao.create(new Character(userId, "Alice", 0, 1, 1, 1));

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/lobby/heartbeat", new HeartbeatHandler(characterDao, presenceDao));
        server.createContext("/api/lobby/leave", new LeaveLobbyHandler(presenceDao));
        server.createContext("/api/lobby/players", new LobbyPlayersHandler(presenceDao, characterDao));
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
    void heartbeatWithoutCharacterRejected() throws Exception {
        var res = post("/api/lobby/heartbeat", new HeartbeatHandler.Req(99999, 0, 0));
        assertEquals(404, res.statusCode());
    }

    @Test
    void emptyLobbyByDefault() throws Exception {
        var res = get("/api/lobby/players");
        assertEquals(200, res.statusCode());
        assertEquals(0, gson.fromJson(res.body(), JsonArray.class).size());
    }

    @Test
    void fullCycle_heartbeatShowsUpThenLeaveRemoves() throws Exception {
        var heartbeat = post("/api/lobby/heartbeat", new HeartbeatHandler.Req(userId, 50, 60));
        assertEquals(200, heartbeat.statusCode());

        var players = get("/api/lobby/players");
        assertEquals(200, players.statusCode());
        JsonArray arr = gson.fromJson(players.body(), JsonArray.class);
        assertEquals(1, arr.size());
        JsonObject p = arr.get(0).getAsJsonObject();
        assertEquals("Alice", p.get("name").getAsString());
        assertEquals(50, p.get("x").getAsInt());

        var leave = post("/api/lobby/leave", new LeaveLobbyHandler.Req(userId));
        assertEquals(200, leave.statusCode());

        var playersAfterLeave = get("/api/lobby/players");
        assertTrue(gson.fromJson(playersAfterLeave.body(), JsonArray.class).isEmpty());
    }
}
