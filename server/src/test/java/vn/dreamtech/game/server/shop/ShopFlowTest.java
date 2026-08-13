package vn.dreamtech.game.server.shop;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.character.CosmeticCatalog;
import vn.dreamtech.game.server.dao.PlayerCosmeticDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.dao.WalletDao;

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

class ShopFlowTest {
    private HttpServer server;
    private int port;
    private UserDao userDao;
    private WalletDao walletDao;
    private PlayerCosmeticDao playerCosmeticDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:shop_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE users (
                  id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(50) UNIQUE, password_hash VARCHAR(255),
                  guest_token VARCHAR(64) UNIQUE, google_id VARCHAR(128) UNIQUE, apple_id VARCHAR(128) UNIQUE,
                  display_name VARCHAR(50), created_at TIMESTAMP NOT NULL
                )
                """);
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, gold BIGINT NOT NULL DEFAULT 0, diamond BIGINT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE player_cosmetics (user_id INT NOT NULL, item_id INT NOT NULL, unlocked_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, item_id))");
        }
        userDao = new UserDao(dataSource);
        walletDao = new WalletDao(dataSource);
        playerCosmeticDao = new PlayerCosmeticDao(dataSource);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/shop/cosmetics", new ShopListHandler());
        server.createContext("/api/shop/cosmetics/buy", new BuyCosmeticHandler(userDao, walletDao, playerCosmeticDao));
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

    private int newPlayer(long gold) throws SQLException {
        int userId = userDao.createGuest("tok-" + System.nanoTime()).id();
        if (gold > 0) walletDao.addGold(userId, gold);
        return userId;
    }

    record BuyReq(int userId, int itemId) {
    }

    @Test
    void everyCosmeticHasAPrice() {
        assertEquals(CosmeticCatalog.all().size(), ShopCatalog.all().size());
    }

    @Test
    void shopListsAllItemsWithPrice() throws Exception {
        var res = get("/api/shop/cosmetics");
        assertEquals(200, res.statusCode());
        JsonArray items = gson.fromJson(res.body(), JsonArray.class);
        assertEquals(CosmeticCatalog.all().size(), items.size());
        assertTrue(res.body().contains("priceGold"));
    }

    @Test
    void buyDeductsGoldAndGrantsOwnership() throws Exception {
        int userId = newPlayer(1_000);

        var res = post("/api/shop/cosmetics/buy", new BuyReq(userId, 51)); // hat_crown, 800 vàng
        assertEquals(200, res.statusCode());
        JsonObject body = gson.fromJson(res.body(), JsonObject.class);
        assertEquals(800, body.get("paidGold").getAsLong());
        assertEquals(200, body.get("goldRemaining").getAsLong());
        assertTrue(playerCosmeticDao.isOwned(userId, 51));
    }

    @Test
    void buyWithoutEnoughGoldRejected() throws Exception {
        int userId = newPlayer(100);
        var res = post("/api/shop/cosmetics/buy", new BuyReq(userId, 51));
        assertEquals(402, res.statusCode());
        assertEquals(100, walletDao.find(userId).gold());
    }

    @Test
    void buyAlreadyOwnedRejected() throws Exception {
        int userId = newPlayer(2_000);
        post("/api/shop/cosmetics/buy", new BuyReq(userId, 51));
        var res = post("/api/shop/cosmetics/buy", new BuyReq(userId, 51));
        assertEquals(409, res.statusCode());
        assertEquals(1_200, walletDao.find(userId).gold()); // không trừ thêm lần 2
    }

    @Test
    void buyUnknownItemRejected() throws Exception {
        int userId = newPlayer(1_000);
        var res = post("/api/shop/cosmetics/buy", new BuyReq(userId, 999));
        assertEquals(404, res.statusCode());
    }

    @Test
    void buyUnknownUserRejected() throws Exception {
        var res = post("/api/shop/cosmetics/buy", new BuyReq(999, 51));
        assertEquals(404, res.statusCode());
    }

    @Test
    void freeItemClaimableWithZeroGold() throws Exception {
        int userId = newPlayer(0);
        var res = post("/api/shop/cosmetics/buy", new BuyReq(userId, 1)); // eyes_default, giá 0
        assertEquals(200, res.statusCode());
        assertTrue(playerCosmeticDao.isOwned(userId, 1));
    }
}
