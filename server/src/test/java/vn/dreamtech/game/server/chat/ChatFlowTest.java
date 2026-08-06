package vn.dreamtech.game.server.chat;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.ChatMessageDao;
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

/** Test trọn luồng chat sảnh qua HTTP thật, DB H2 nhúng. */
class ChatFlowTest {
    private HttpServer server;
    private int port;
    private int userId;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:chat_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
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
            st.execute("""
                CREATE TABLE chat_messages (
                  id BIGINT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, sender_name VARCHAR(20) NOT NULL,
                  text VARCHAR(500) NOT NULL, created_at TIMESTAMP NOT NULL
                )
                """);
        }
        UserDao userDao = new UserDao(dataSource);
        CharacterDao characterDao = new CharacterDao(dataSource);
        ChatMessageDao chatMessageDao = new ChatMessageDao(dataSource);
        userId = userDao.createGuest("tok-1").id();
        characterDao.create(new Character(userId, "Alice", 0, 1, 1, 1));

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/chat/send", new SendMessageHandler(characterDao, chatMessageDao));
        server.createContext("/api/chat/recent", new RecentMessagesHandler(chatMessageDao));
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
    void sendWithoutCharacterRejected() throws Exception {
        var res = post("/api/chat/send", new SendMessageHandler.Req(99999, "chào"));
        assertEquals(404, res.statusCode());
    }

    @Test
    void sendBlankTextRejected() throws Exception {
        var res = post("/api/chat/send", new SendMessageHandler.Req(userId, "   "));
        assertEquals(400, res.statusCode());
    }

    @Test
    void emptyChatByDefault() throws Exception {
        var res = get("/api/chat/recent");
        assertEquals(200, res.statusCode());
        assertEquals(0, gson.fromJson(res.body(), JsonArray.class).size());
    }

    @Test
    void fullCycle_sendThenPollIncrementally() throws Exception {
        var send1 = post("/api/chat/send", new SendMessageHandler.Req(userId, "chào mọi người"));
        assertEquals(201, send1.statusCode());
        JsonObject msg1 = gson.fromJson(send1.body(), JsonObject.class);
        assertEquals("Alice", msg1.get("senderName").getAsString());
        long id1 = msg1.get("id").getAsLong();

        var recentFromStart = get("/api/chat/recent");
        JsonArray fromStart = gson.fromJson(recentFromStart.body(), JsonArray.class);
        assertEquals(1, fromStart.size());

        var send2 = post("/api/chat/send", new SendMessageHandler.Req(userId, "có ai không"));
        assertEquals(201, send2.statusCode());

        // poll từ id tin đầu -> chỉ thấy tin thứ 2, không lặp lại tin đã thấy
        var recentSinceFirst = get("/api/chat/recent?sinceId=" + id1);
        JsonArray onlyNew = gson.fromJson(recentSinceFirst.body(), JsonArray.class);
        assertEquals(1, onlyNew.size());
        assertEquals("có ai không", onlyNew.get(0).getAsJsonObject().get("text").getAsString());
    }
}
