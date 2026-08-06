package vn.dreamtech.cozyfarming.server.shop;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.cozyfarming.server.dao.BagDao;
import vn.dreamtech.cozyfarming.server.dao.FarmStoreDao;
import vn.dreamtech.cozyfarming.server.dao.WalletDao;
import vn.dreamtech.cozyfarming.server.wallet.WalletHandler;

import javax.sql.DataSource;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;

/** Test trọn luồng mua hạt giống -> trồng thật (kho seeds) và bán nông sản, qua HTTP thật, DB H2 nhúng. */
class ShopFlowTest {
    private HttpServer server;
    private int port;
    private FarmStoreDao farmStoreDao;
    private BagDao bagDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:shop_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, coins BIGINT NOT NULL DEFAULT 500, gems BIGINT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE farm_store (user_id INT NOT NULL, kind VARCHAR(10) NOT NULL, item_id VARCHAR(60) NOT NULL, qty INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, kind, item_id))");
            st.execute("CREATE TABLE bag_items (user_id INT NOT NULL, item_id VARCHAR(60) NOT NULL, qty INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, item_id))");
        }
        WalletDao walletDao = new WalletDao(dataSource);
        farmStoreDao = new FarmStoreDao(dataSource);
        bagDao = new BagDao(dataSource);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/shop/buy", new BuyItemHandler(farmStoreDao, bagDao, walletDao));
        server.createContext("/api/shop/sell", new SellItemHandler(farmStoreDao, bagDao, walletDao));
        server.createContext("/api/wallet", new WalletHandler(walletDao));
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
    void buyNonPurchasableItemRejected() throws Exception {
        var res = post("/api/shop/buy", new BuyItemHandler.Req(1, "egg", 1));
        assertEquals(400, res.statusCode());
    }

    @Test
    void buySeedsThenSellCropsRoundTrip() throws Exception {
        // mua 3 hạt cà rốt (10 xu/hạt) -> 500 - 30 = 470
        var buy = post("/api/shop/buy", new BuyItemHandler.Req(1, "seed_carrot", 3));
        assertEquals(200, buy.statusCode());
        assertEquals(3, farmStoreDao.countOf(1, "seeds", "carrot"));
        var walletAfterBuy = get("/api/wallet?userId=1");
        assertEquals(470, gson.fromJson(walletAfterBuy.body(), JsonObject.class).get("coins").getAsLong());

        // giả lập thu hoạch được 5 cà rốt trong kho produce rồi bán hết (18 xu/củ)
        farmStoreDao.addTo(1, "produce", "carrot", 5);
        var sell = post("/api/shop/sell", new SellItemHandler.Req(1, "carrot", 5));
        assertEquals(200, sell.statusCode());
        JsonObject sellBody = gson.fromJson(sell.body(), JsonObject.class);
        assertEquals(90, sellBody.get("revenue").getAsInt());
        assertEquals(0, farmStoreDao.countOf(1, "produce", "carrot"));

        var walletAfterSell = get("/api/wallet?userId=1");
        assertEquals(560, gson.fromJson(walletAfterSell.body(), JsonObject.class).get("coins").getAsLong());
    }

    @Test
    void buyGenericBagItemRoutesToBag() throws Exception {
        var res = post("/api/shop/buy", new BuyItemHandler.Req(1, "feed", 4));
        assertEquals(200, res.statusCode());
        assertEquals(4, bagDao.countOf(1, "feed"));
        // 4 x 10 xu = 40 -> 500 - 40 = 460
        var wallet = get("/api/wallet?userId=1");
        assertEquals(460, gson.fromJson(wallet.body(), JsonObject.class).get("coins").getAsLong());
    }

    @Test
    void sellMoreThanOwnedRejected() throws Exception {
        var res = post("/api/shop/sell", new SellItemHandler.Req(1, "carrot", 1));
        assertEquals(409, res.statusCode());
    }
}
