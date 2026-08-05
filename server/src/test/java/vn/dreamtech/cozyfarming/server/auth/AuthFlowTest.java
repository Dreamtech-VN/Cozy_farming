package vn.dreamtech.cozyfarming.server.auth;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.cozyfarming.server.dao.PasswordResetDao;
import vn.dreamtech.cozyfarming.server.dao.UserDao;

import javax.sql.DataSource;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Test toàn luồng đăng ký -> đổi mật khẩu sai -> quên mật khẩu -> đặt lại ->
 * đăng nhập lại bằng mật khẩu mới, gọi HTTP THẬT (không mock) tới 4 handler,
 * DB là H2 nhúng (mô phỏng đúng bảng `users` thật + bảng phụ `password_resets`).
 */
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
                  id INT AUTO_INCREMENT PRIMARY KEY,
                  username VARCHAR(20) NOT NULL UNIQUE,
                  password VARCHAR(255) NOT NULL,
                  role SMALLINT DEFAULT -1,
                  ban VARCHAR(500),
                  active INT DEFAULT 0,
                  phone VARCHAR(11) DEFAULT '0',
                  gmail VARCHAR(50),
                  vnd INT DEFAULT 0,
                  tongnap INT DEFAULT 0,
                  timeCreate DATE,
                  login_lock TINYINT DEFAULT 0
                )
                """);
            st.execute("""
                CREATE TABLE password_resets (
                  user_id INT NOT NULL PRIMARY KEY,
                  code_hash VARCHAR(255) NOT NULL,
                  expires_at TIMESTAMP NOT NULL
                )
                """);
        }
        UserDao userDao = new UserDao(dataSource);
        PasswordResetDao resetDao = new PasswordResetDao(dataSource);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/register", new RegisterHandler(userDao));
        server.createContext("/api/login", new LoginHandler(userDao));
        server.createContext("/api/forgot/request", new ForgotPasswordRequestHandler(userDao, resetDao));
        server.createContext("/api/forgot/reset", new ForgotPasswordResetHandler(userDao, resetDao));
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
    void fullRegisterLoginForgotResetFlow() throws Exception {
        // 1. đăng ký
        var reg = post("/api/register", new RegisterHandler.Req("tester1", "matkhau123", "tester1@example.com"));
        assertEquals(201, reg.statusCode());

        // 2. đăng nhập sai mật khẩu -> 401
        var wrongLogin = post("/api/login", new LoginHandler.Req("tester1", "saimatkhau"));
        assertEquals(401, wrongLogin.statusCode());

        // 3. đăng nhập đúng -> 200
        var okLogin = post("/api/login", new LoginHandler.Req("tester1", "matkhau123"));
        assertEquals(200, okLogin.statusCode());

        // 4. quên mật khẩu -> lấy mã (devOnlyCode, giai đoạn này chưa gửi email thật)
        var forgot = post("/api/forgot/request", new ForgotPasswordRequestHandler.Req("tester1"));
        assertEquals(200, forgot.statusCode());
        JsonObject forgotBody = gson.fromJson(forgot.body(), JsonObject.class);
        String code = forgotBody.get("devOnlyCode").getAsString();
        assertTrue(code.matches("\\d{6}"));

        // 5. đặt lại mật khẩu bằng mã đúng
        var reset = post("/api/forgot/reset", new ForgotPasswordResetHandler.Req("tester1", code, "matkhaumoi456"));
        assertEquals(200, reset.statusCode());

        // 6. đăng nhập lại bằng mật khẩu MỚI -> 200; mật khẩu CŨ giờ phải sai
        var loginNew = post("/api/login", new LoginHandler.Req("tester1", "matkhaumoi456"));
        assertEquals(200, loginNew.statusCode());
        var loginOld = post("/api/login", new LoginHandler.Req("tester1", "matkhau123"));
        assertEquals(401, loginOld.statusCode());
    }

    @Test
    void registerDuplicateUsernameRejected() throws Exception {
        post("/api/register", new RegisterHandler.Req("dup1", "matkhau123", null));
        var second = post("/api/register", new RegisterHandler.Req("dup1", "khacmatkhau", null));
        assertEquals(409, second.statusCode());
    }

    @Test
    void resetWithWrongCodeRejected() throws Exception {
        post("/api/register", new RegisterHandler.Req("tester2", "matkhau123", null));
        post("/api/forgot/request", new ForgotPasswordRequestHandler.Req("tester2"));
        var reset = post("/api/forgot/reset", new ForgotPasswordResetHandler.Req("tester2", "000000", "matkhaumoi"));
        assertEquals(400, reset.statusCode());
    }
}
