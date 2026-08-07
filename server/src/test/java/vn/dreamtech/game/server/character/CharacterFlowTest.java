package vn.dreamtech.game.server.character;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.dao.CharacterDao;
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

/** Test trọn luồng tạo nhân vật qua HTTP thật, DB H2 nhúng. */
class CharacterFlowTest {
    private HttpServer server;
    private int port;
    private int userId;
    private UserDao userDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:character_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
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
        }
        userDao = new UserDao(dataSource);
        CharacterDao characterDao = new CharacterDao(dataSource);
        userId = userDao.createGuest("tok-1").id();

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/character/create", new CreateCharacterHandler(userDao, characterDao));
        server.createContext("/api/character/outfit", new UpdateOutfitHandler(characterDao));
        server.createContext("/api/character", new CharacterHandler(characterDao));
        server.createContext("/api/admin/character/rename", new AdminRenameCharacterHandler(characterDao));
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
    void getBeforeCreateReturns404() throws Exception {
        var res = get("/api/character?userId=" + userId);
        assertEquals(404, res.statusCode());
    }

    @Test
    void unknownUserRejected() throws Exception {
        var res = post("/api/character/create", new CreateCharacterHandler.Req(99999, "Ghost", 0, 1, 1, 1));
        assertEquals(404, res.statusCode());
    }

    @Test
    void invalidNameRejected() throws Exception {
        var res = post("/api/character/create", new CreateCharacterHandler.Req(userId, "A", 0, 1, 1, 1));
        assertEquals(400, res.statusCode());
    }

    @Test
    void invalidGenderRejected() throws Exception {
        var res = post("/api/character/create", new CreateCharacterHandler.Req(userId, "Alice", 5, 1, 1, 1));
        assertEquals(400, res.statusCode());
    }

    @Test
    void fullCycle_createThenGetThenUpdateOutfit() throws Exception {
        var create = post("/api/character/create", new CreateCharacterHandler.Req(userId, "Alice", 1, 3, 5, 7));
        assertEquals(201, create.statusCode());

        // đã có nhân vật -> tạo lần 2 phải bị chặn
        var createAgain = post("/api/character/create", new CreateCharacterHandler.Req(userId, "Alice2", 1, 1, 1, 1));
        assertEquals(409, createAgain.statusCode());

        var get = get("/api/character?userId=" + userId);
        assertEquals(200, get.statusCode());
        JsonObject body = gson.fromJson(get.body(), JsonObject.class);
        assertEquals("Alice", body.get("name").getAsString());

        var updateOutfit = post("/api/character/outfit", new UpdateOutfitHandler.Req(userId, 9, 8, 7));
        assertEquals(200, updateOutfit.statusCode());
        JsonObject updated = gson.fromJson(updateOutfit.body(), JsonObject.class);
        assertEquals(9, updated.get("hairId").getAsInt());
    }

    @Test
    void duplicateNameFromDifferentUserRejected() throws Exception {
        post("/api/character/create", new CreateCharacterHandler.Req(userId, "Alice", 0, 1, 1, 1));

        // user thứ 2, có thật trong DB, tên trùng phải bị chặn (409, không phải 404)
        int secondUserId = userDao.createGuest("tok-2").id();
        var res = post("/api/character/create", new CreateCharacterHandler.Req(secondUserId, "Alice", 0, 1, 1, 1));
        assertEquals(409, res.statusCode());
    }

    @Test
    void adminRenameRequiresAdminToken() throws Exception {
        post("/api/character/create", new CreateCharacterHandler.Req(userId, "Alice", 0, 1, 1, 1));
        var res = post("/api/admin/character/rename", new AdminRenameCharacterHandler.Req(userId, "NewName"));
        assertEquals(503, res.statusCode());
    }
}
