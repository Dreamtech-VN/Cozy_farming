package vn.dreamtech.game.server.account;

import com.google.gson.Gson;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.security.PasswordHasher;

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

/** Test đổi mật khẩu (đang đăng nhập) + xoá tài khoản, qua HTTP thật, DB H2 nhúng. */
class AccountFlowTest {
    private HttpServer server;
    private int port;
    private UserDao userDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:account_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE users (
                  id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(50) UNIQUE, password_hash VARCHAR(255),
                  guest_token VARCHAR(64) UNIQUE, google_id VARCHAR(128) UNIQUE, apple_id VARCHAR(128) UNIQUE,
                  display_name VARCHAR(50), created_at TIMESTAMP NOT NULL
                )
                """);
        }
        userDao = new UserDao(dataSource);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/account/change-password", new ChangePasswordHandler(userDao));
        server.createContext("/api/account/delete", new DeleteAccountHandler(userDao));
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
    void changePasswordWrongCurrentRejected() throws Exception {
        var user = userDao.createReal("alice", PasswordHasher.hash("pass1234"), "alice");
        var res = post("/api/account/change-password", new ChangePasswordHandler.Req(user.id(), "wrong", "newpass1"));
        assertEquals(401, res.statusCode());
    }

    @Test
    void changePasswordOnGuestOnlyAccountRejected() throws Exception {
        var guest = userDao.createGuest("tok-1");
        var res = post("/api/account/change-password", new ChangePasswordHandler.Req(guest.id(), "x", "newpass1"));
        assertEquals(404, res.statusCode());
    }

    @Test
    void changePasswordSucceedsThenNewHashVerifies() throws Exception {
        var user = userDao.createReal("bob", PasswordHasher.hash("oldpass1"), "bob");
        var res = post("/api/account/change-password", new ChangePasswordHandler.Req(user.id(), "oldpass1", "newpass1"));
        assertEquals(200, res.statusCode());
        var updated = userDao.findById(user.id()).orElseThrow();
        assertTrue(PasswordHasher.verify("newpass1", updated.passwordHash()));
    }

    @Test
    void deleteRealAccountRequiresCorrectPassword() throws Exception {
        var user = userDao.createReal("carol", PasswordHasher.hash("pass1234"), "carol");
        var wrongPassword = post("/api/account/delete", new DeleteAccountHandler.Req(user.id(), "wrong"));
        assertEquals(401, wrongPassword.statusCode());
        assertTrue(userDao.findById(user.id()).isPresent());

        var correctPassword = post("/api/account/delete", new DeleteAccountHandler.Req(user.id(), "pass1234"));
        assertEquals(200, correctPassword.statusCode());
        assertTrue(userDao.findById(user.id()).isEmpty());
    }

    @Test
    void deleteGuestOnlyAccountNeedsNoPassword() throws Exception {
        var guest = userDao.createGuest("tok-1");
        var res = post("/api/account/delete", new DeleteAccountHandler.Req(guest.id(), null));
        assertEquals(200, res.statusCode());
        assertTrue(userDao.findById(guest.id()).isEmpty());
    }
}
