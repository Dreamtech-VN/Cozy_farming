package vn.dreamtech.game.server.admin;

import com.google.gson.Gson;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.dao.BannedUserDao;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.dao.WalletDao;

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

/** Test nối dây HTTP thật cho /api/admin/users/* — không set biến môi trường ADMIN_TOKEN thật nên chỉ kiểm nhánh 503 (chưa cấu hình); logic so khớp token đã kiểm ở AdminAuthTest. */
class AdminUserManagementHttpFlowTest {
    private HttpServer server;
    private int port;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();
    private UserDao userDao;
    private WalletDao walletDao;
    private BannedUserDao bannedUserDao;

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:admin_user_mgmt_http_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
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
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, gold BIGINT NOT NULL DEFAULT 0, diamond BIGINT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE character_levels (user_id INT NOT NULL PRIMARY KEY, level INT NOT NULL DEFAULT 1, exp INT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE banned_users (user_id INT NOT NULL PRIMARY KEY, reason VARCHAR(255), banned_at TIMESTAMP NOT NULL)");
        }
        userDao = new UserDao(dataSource);
        CharacterDao characterDao = new CharacterDao(dataSource);
        walletDao = new WalletDao(dataSource);
        LevelDao levelDao = new LevelDao(dataSource);
        bannedUserDao = new BannedUserDao(dataSource);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/admin/users/ban", new AdminBanUserHandler(userDao, bannedUserDao));
        server.createContext("/api/admin/users/unban", new AdminUnbanUserHandler(bannedUserDao));
        server.createContext("/api/admin/users/wallet/adjust", new AdminAdjustWalletHandler(userDao, walletDao));
        server.createContext("/api/admin/users/lookup", new AdminLookupUserHandler(userDao, characterDao, walletDao, levelDao, bannedUserDao));
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
    void banWithoutAdminTokenRejected() throws Exception {
        int userId = userDao.createGuest("tok-noadmin-" + System.nanoTime()).id();
        var res = post("/api/admin/users/ban", Map.of("userId", userId, "reason", "test"));
        // ADMIN_TOKEN chưa cấu hình trong môi trường test -> 503 (an toàn theo mặc định)
        assertEquals(503, res.statusCode());
    }

    @Test
    void unbanWithoutAdminTokenRejected() throws Exception {
        var res = post("/api/admin/users/unban", Map.of("userId", 1));
        assertEquals(503, res.statusCode());
    }

    @Test
    void walletAdjustWithoutAdminTokenRejected() throws Exception {
        var res = post("/api/admin/users/wallet/adjust", Map.of("userId", 1, "goldDelta", 100, "diamondDelta", 0));
        assertEquals(503, res.statusCode());
    }

    @Test
    void lookupWithoutAdminTokenRejected() throws Exception {
        var res = get("/api/admin/users/lookup?userId=1");
        assertEquals(503, res.statusCode());
    }
}
