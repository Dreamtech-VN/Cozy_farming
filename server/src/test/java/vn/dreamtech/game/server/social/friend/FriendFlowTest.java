package vn.dreamtech.game.server.social.friend;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.admin.AdminRemoveFriendshipHandler;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.FriendRequestDao;
import vn.dreamtech.game.server.dao.FriendshipDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.dao.UserSettingsDao;
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

/** Test trọn luồng kết bạn qua HTTP thật, DB H2 nhúng. */
class FriendFlowTest {
    private HttpServer server;
    private int port;
    private UserSettingsDao settingsDao;
    private UserDao userDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:friend_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
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
                CREATE TABLE friend_requests (
                  id BIGINT AUTO_INCREMENT PRIMARY KEY, from_user_id INT NOT NULL, to_user_id INT NOT NULL,
                  created_at TIMESTAMP NOT NULL, UNIQUE (from_user_id, to_user_id)
                )
                """);
            st.execute("""
                CREATE TABLE friendships (
                  user_id_a INT NOT NULL, user_id_b INT NOT NULL, intimacy_points INT NOT NULL DEFAULT 0,
                  last_gift_at TIMESTAMP, created_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id_a, user_id_b)
                )
                """);
            st.execute("""
                CREATE TABLE user_settings (
                  user_id INT NOT NULL PRIMARY KEY, push_notifications TINYINT NOT NULL DEFAULT 1,
                  friend_request_privacy VARCHAR(20) NOT NULL DEFAULT 'EVERYONE',
                  message_privacy VARCHAR(20) NOT NULL DEFAULT 'EVERYONE', language VARCHAR(10) NOT NULL DEFAULT 'vi'
                )
                """);
            st.execute("""
                CREATE TABLE characters (
                  user_id INT NOT NULL PRIMARY KEY, name VARCHAR(20) NOT NULL UNIQUE, gender TINYINT NOT NULL,
                  hair_id INT NOT NULL, top_id INT NOT NULL, bottom_id INT NOT NULL, created_at TIMESTAMP NOT NULL
                )
                """);
        }
        FriendRequestDao friendRequestDao = new FriendRequestDao(dataSource);
        FriendshipDao friendshipDao = new FriendshipDao(dataSource);
        settingsDao = new UserSettingsDao(dataSource);
        userDao = new UserDao(dataSource);
        CharacterDao characterDao = new CharacterDao(dataSource);
        characterDao.create(new Character(1, "Alice", 0, 1, 1, 1));
        characterDao.create(new Character(2, "Bob", 1, 1, 1, 1));

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/friends/request", new SendFriendRequestHandler(friendRequestDao, friendshipDao, settingsDao));
        server.createContext("/api/friends/respond", new RespondFriendRequestHandler(friendRequestDao, friendshipDao));
        server.createContext("/api/friends/requests", new PendingRequestsHandler(friendRequestDao));
        server.createContext("/api/friends/remove", new RemoveFriendHandler(friendshipDao));
        server.createContext("/api/friends", new FriendsListHandler(friendshipDao, characterDao));
        server.createContext("/api/admin/friend/remove", new AdminRemoveFriendshipHandler(userDao, friendshipDao));
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
    void cannotFriendSelf() throws Exception {
        var res = post("/api/friends/request", new SendFriendRequestHandler.Req(1, 1));
        assertEquals(400, res.statusCode());
    }

    @Test
    void requestBlockedWhenTargetPrivacyIsNobody() throws Exception {
        settingsDao.save(new vn.dreamtech.game.server.model.UserSettings(2, true, "NOBODY", "EVERYONE", "vi"));
        var res = post("/api/friends/request", new SendFriendRequestHandler.Req(1, 2));
        assertEquals(403, res.statusCode());
    }

    @Test
    void duplicateRequestRejected() throws Exception {
        post("/api/friends/request", new SendFriendRequestHandler.Req(1, 2));
        var res = post("/api/friends/request", new SendFriendRequestHandler.Req(1, 2));
        assertEquals(409, res.statusCode());
    }

    @Test
    void respondByWrongUserRejected() throws Exception {
        var req = post("/api/friends/request", new SendFriendRequestHandler.Req(1, 2));
        long requestId = gson.fromJson(req.body(), JsonObject.class).get("id").getAsLong();
        // user 1 (người gửi) không được tự duyệt lời mời của mình
        var res = post("/api/friends/respond", new RespondFriendRequestHandler.Req(requestId, 1, true));
        assertEquals(403, res.statusCode());
    }

    @Test
    void fullCycle_requestAcceptThenAppearInFriendsList() throws Exception {
        var req = post("/api/friends/request", new SendFriendRequestHandler.Req(1, 2));
        assertEquals(201, req.statusCode());
        long requestId = gson.fromJson(req.body(), JsonObject.class).get("id").getAsLong();

        var pending = get("/api/friends/requests?userId=2");
        assertEquals(1, gson.fromJson(pending.body(), JsonArray.class).size());

        var accept = post("/api/friends/respond", new RespondFriendRequestHandler.Req(requestId, 2, true));
        assertEquals(200, accept.statusCode());

        var friendsOf1 = get("/api/friends?userId=1");
        JsonArray arr = gson.fromJson(friendsOf1.body(), JsonArray.class);
        assertEquals(1, arr.size());
        assertEquals("Bob", arr.get(0).getAsJsonObject().get("name").getAsString());

        var remove = post("/api/friends/remove", new RemoveFriendHandler.Req(1, 2));
        assertEquals(200, remove.statusCode());
        assertTrue(gson.fromJson(get("/api/friends?userId=1").body(), JsonArray.class).isEmpty());
    }

    @Test
    void rejectDeletesRequestWithoutCreatingFriendship() throws Exception {
        var req = post("/api/friends/request", new SendFriendRequestHandler.Req(1, 2));
        long requestId = gson.fromJson(req.body(), JsonObject.class).get("id").getAsLong();
        post("/api/friends/respond", new RespondFriendRequestHandler.Req(requestId, 2, false));
        assertTrue(gson.fromJson(get("/api/friends?userId=1").body(), JsonArray.class).isEmpty());
    }

    @Test
    void adminRemoveFriendshipRequiresAdminToken() throws Exception {
        var res = post("/api/admin/friend/remove", new AdminRemoveFriendshipHandler.Req(1, 2));
        assertEquals(503, res.statusCode());
    }
}
