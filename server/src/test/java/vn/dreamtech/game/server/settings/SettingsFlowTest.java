package vn.dreamtech.game.server.settings;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.dao.UserSettingsDao;

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

class SettingsFlowTest {
    private HttpServer server;
    private int port;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:settings_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE user_settings (
                  user_id INT NOT NULL PRIMARY KEY, push_notifications TINYINT NOT NULL DEFAULT 1,
                  friend_request_privacy VARCHAR(20) NOT NULL DEFAULT 'EVERYONE',
                  message_privacy VARCHAR(20) NOT NULL DEFAULT 'EVERYONE', language VARCHAR(10) NOT NULL DEFAULT 'vi'
                )
                """);
        }
        UserSettingsDao settingsDao = new UserSettingsDao(dataSource);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/settings", new GetSettingsHandler(settingsDao));
        server.createContext("/api/settings/update", new UpdateSettingsHandler(settingsDao));
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
    void getReturnsDefaultsWhenNeverSaved() throws Exception {
        var res = get("/api/settings?userId=1");
        assertEquals(200, res.statusCode());
        JsonObject body = gson.fromJson(res.body(), JsonObject.class);
        assertTrue(body.get("pushNotifications").getAsBoolean());
        assertEquals("vi", body.get("language").getAsString());
    }

    @Test
    void updateInvalidPrivacyRejected() throws Exception {
        var res = post("/api/settings/update", new UpdateSettingsHandler.Req(1, null, "WEIRD", null, null));
        assertEquals(400, res.statusCode());
    }

    @Test
    void partialUpdateOnlyChangesGivenFields() throws Exception {
        // đổi language trước
        post("/api/settings/update", new UpdateSettingsHandler.Req(1, null, null, null, "en"));
        // rồi chỉ đổi pushNotifications -> language phải GIỮ NGUYÊN "en", không bị reset về mặc định
        var res = post("/api/settings/update", new UpdateSettingsHandler.Req(1, false, null, null, null));
        assertEquals(200, res.statusCode());
        JsonObject body = gson.fromJson(res.body(), JsonObject.class);
        assertEquals(false, body.get("pushNotifications").getAsBoolean());
        assertEquals("en", body.get("language").getAsString());

        var fetched = get("/api/settings?userId=1");
        JsonObject fetchedBody = gson.fromJson(fetched.body(), JsonObject.class);
        assertEquals("en", fetchedBody.get("language").getAsString());
    }
}
