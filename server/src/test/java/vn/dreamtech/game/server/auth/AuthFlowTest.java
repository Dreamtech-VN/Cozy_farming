package vn.dreamtech.game.server.auth;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.auth.oauth.ProviderIdentity;
import vn.dreamtech.game.server.dao.PasswordResetDao;
import vn.dreamtech.game.server.dao.UserDao;

import javax.sql.DataSource;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.Statement;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test trọn luồng tài khoản qua HTTP thật, DB H2 nhúng: đăng ký/đăng nhập/quên mật khẩu, khách, liên kết. */
class AuthFlowTest {
    private HttpServer server;
    private int port;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:auth_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE users (
                  id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(50) UNIQUE, password_hash VARCHAR(255),
                  guest_token VARCHAR(64) UNIQUE, google_id VARCHAR(128) UNIQUE, apple_id VARCHAR(128) UNIQUE,
                  display_name VARCHAR(50), created_at TIMESTAMP NOT NULL
                )
                """);
            st.execute("CREATE TABLE password_resets (user_id INT NOT NULL PRIMARY KEY, code_hash VARCHAR(255) NOT NULL, expires_at TIMESTAMP NOT NULL)");
        }
        UserDao userDao = new UserDao(dataSource);
        PasswordResetDao resetDao = new PasswordResetDao(dataSource);
        var fakeGoogle = new FakeOAuthVerifier(Map.of("good-google-token", new ProviderIdentity("g-1", "a@x.com")));
        var fakeApple = new FakeOAuthVerifier(Map.of("good-apple-token", new ProviderIdentity("a-1", "b@x.com")));

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/auth/register", new RegisterHandler(userDao));
        server.createContext("/api/auth/login", new LoginHandler(userDao));
        server.createContext("/api/auth/guest", new GuestLoginHandler(userDao));
        server.createContext("/api/auth/forgot/request", new ForgotPasswordRequestHandler(userDao, resetDao));
        server.createContext("/api/auth/forgot/reset", new ForgotPasswordResetHandler(userDao, resetDao));
        server.createContext("/api/auth/link/upgrade", new UpgradeGuestHandler(userDao));
        server.createContext("/api/auth/social/google", new SocialLoginHandler(userDao, fakeGoogle, SocialLoginHandler.Provider.GOOGLE));
        server.createContext("/api/auth/link/google", new LinkSocialHandler(userDao, fakeGoogle, SocialLoginHandler.Provider.GOOGLE));
        server.createContext("/api/auth/link/apple", new LinkSocialHandler(userDao, fakeApple, SocialLoginHandler.Provider.APPLE));
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

    @Test
    void fullCycle_registerLoginForgotResetLogin() throws Exception {
        var register = post("/api/auth/register", new RegisterHandler.Req("alice", "s3cret1"));
        assertEquals(201, register.statusCode());

        var duplicateRegister = post("/api/auth/register", new RegisterHandler.Req("alice", "other1"));
        assertEquals(409, duplicateRegister.statusCode());

        var wrongLogin = post("/api/auth/login", new LoginHandler.Req("alice", "wrongpass"));
        assertEquals(401, wrongLogin.statusCode());

        var login = post("/api/auth/login", new LoginHandler.Req("alice", "s3cret1"));
        assertEquals(200, login.statusCode());

        var forgot = post("/api/auth/forgot/request", new ForgotPasswordRequestHandler.Req("alice"));
        assertEquals(200, forgot.statusCode());
        JsonObject forgotBody = gson.fromJson(forgot.body(), JsonObject.class);
        String code = forgotBody.get("devOnlyCode").getAsString();

        var wrongCode = post("/api/auth/forgot/reset", new ForgotPasswordResetHandler.Req("alice", "000000", "newpass1"));
        assertEquals(400, wrongCode.statusCode());

        var reset = post("/api/auth/forgot/reset", new ForgotPasswordResetHandler.Req("alice", code, "newpass1"));
        assertEquals(200, reset.statusCode());

        var loginOldPassword = post("/api/auth/login", new LoginHandler.Req("alice", "s3cret1"));
        assertEquals(401, loginOldPassword.statusCode());

        var loginNewPassword = post("/api/auth/login", new LoginHandler.Req("alice", "newpass1"));
        assertEquals(200, loginNewPassword.statusCode());
    }

    @Test
    void guestLoginCreatesThenResumesWithSameToken() throws Exception {
        var first = post("/api/auth/guest", new GuestLoginHandler.Req(null));
        assertEquals(201, first.statusCode());
        JsonObject firstBody = gson.fromJson(first.body(), JsonObject.class);
        int userId = firstBody.get("userId").getAsInt();
        String token = firstBody.get("guestToken").getAsString();

        var second = post("/api/auth/guest", new GuestLoginHandler.Req(token));
        assertEquals(200, second.statusCode());
        JsonObject secondBody = gson.fromJson(second.body(), JsonObject.class);
        assertEquals(userId, secondBody.get("userId").getAsInt());
        assertTrue(!secondBody.get("isNew").getAsBoolean());
    }

    @Test
    void unknownGuestTokenCreatesNewAccount() throws Exception {
        var res = post("/api/auth/guest", new GuestLoginHandler.Req("never-seen-before"));
        assertEquals(201, res.statusCode());
    }

    @Test
    void upgradeGuestToRealKeepsProgressThenCanLoginWithPassword() throws Exception {
        var guest = post("/api/auth/guest", new GuestLoginHandler.Req(null));
        int guestId = gson.fromJson(guest.body(), JsonObject.class).get("userId").getAsInt();

        var upgrade = post("/api/auth/link/upgrade", new UpgradeGuestHandler.Req(guestId, "bob", "password1"));
        assertEquals(200, upgrade.statusCode());

        // đã nâng cấp -> nâng cấp lại lần nữa phải bị chặn
        var upgradeAgain = post("/api/auth/link/upgrade", new UpgradeGuestHandler.Req(guestId, "bob2", "password1"));
        assertEquals(409, upgradeAgain.statusCode());

        var login = post("/api/auth/login", new LoginHandler.Req("bob", "password1"));
        assertEquals(200, login.statusCode());
        assertEquals(guestId, gson.fromJson(login.body(), JsonObject.class).get("userId").getAsInt());
    }

    @Test
    void socialLoginInvalidTokenRejected() throws Exception {
        var res = post("/api/auth/social/google", new SocialLoginHandler.Req("bad-token"));
        assertEquals(401, res.statusCode());
    }

    @Test
    void socialLoginCreatesNewAccountThenResumesOnSecondLogin() throws Exception {
        var first = post("/api/auth/social/google", new SocialLoginHandler.Req("good-google-token"));
        assertEquals(201, first.statusCode());
        int userId = gson.fromJson(first.body(), JsonObject.class).get("userId").getAsInt();

        var second = post("/api/auth/social/google", new SocialLoginHandler.Req("good-google-token"));
        assertEquals(200, second.statusCode());
        assertEquals(userId, gson.fromJson(second.body(), JsonObject.class).get("userId").getAsInt());
    }

    @Test
    void linkGoogleToRealAccountThenConflictOnAnotherAccount() throws Exception {
        var register = post("/api/auth/register", new RegisterHandler.Req("carol", "password1"));
        int carolId = gson.fromJson(register.body(), JsonObject.class).get("userId").getAsInt();

        var link = post("/api/auth/link/google", new LinkSocialHandler.Req(carolId, "good-google-token"));
        assertEquals(200, link.statusCode());

        var register2 = post("/api/auth/register", new RegisterHandler.Req("dave", "password1"));
        int daveId = gson.fromJson(register2.body(), JsonObject.class).get("userId").getAsInt();

        // cùng google id đã gắn cho carol -> gắn cho dave phải bị chặn
        var conflict = post("/api/auth/link/google", new LinkSocialHandler.Req(daveId, "good-google-token"));
        assertEquals(409, conflict.statusCode());
        assertNotEquals(carolId, daveId);
    }
}
