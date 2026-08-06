package vn.dreamtech.cozyfarming.server.fishpond;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.cozyfarming.server.dao.BagDao;
import vn.dreamtech.cozyfarming.server.dao.FarmStoreDao;
import vn.dreamtech.cozyfarming.server.dao.PondFishDao;
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
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test trọn luồng thả cá -> cho ăn -> (chưa lớn nên chưa vớt được) -> ao đầy, qua HTTP thật, DB H2 nhúng. */
class FishPondFlowTest {
    private HttpServer server;
    private int port;
    private FarmStoreDao farmStoreDao;
    private WalletDao walletDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:fishpond_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE pond_fish (
                  id VARCHAR(40) NOT NULL PRIMARY KEY, user_id INT NOT NULL, type VARCHAR(20) NOT NULL,
                  at TIMESTAMP NOT NULL, fed_at TIMESTAMP
                )
                """);
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, coins BIGINT NOT NULL DEFAULT 500, gems BIGINT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE farm_store (user_id INT NOT NULL, kind VARCHAR(10) NOT NULL, item_id VARCHAR(60) NOT NULL, qty INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, kind, item_id))");
            st.execute("CREATE TABLE bag_items (user_id INT NOT NULL, item_id VARCHAR(60) NOT NULL, qty INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, item_id))");
            st.execute("INSERT INTO bag_items VALUES (1, 'feed', 5)");
        }
        PondFishDao pondFishDao = new PondFishDao(dataSource);
        walletDao = new WalletDao(dataSource);
        farmStoreDao = new FarmStoreDao(dataSource);
        BagDao bagDao = new BagDao(dataSource);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/fishpond", new PondHandler(pondFishDao));
        server.createContext("/api/fishpond/stock", new StockFryHandler(pondFishDao, walletDao));
        server.createContext("/api/fishpond/feed", new FeedFishHandler(pondFishDao, bagDao));
        server.createContext("/api/fishpond/net", new NetFishHandler(pondFishDao, farmStoreDao));
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
    void stockInvalidTypeRejected() throws Exception {
        var res = post("/api/fishpond/stock", new StockFryHandler.Req(1, "ca_voi"));
        assertEquals(400, res.statusCode());
    }

    @Test
    void fullCycle_stockFeedListNetTooSoon() throws Exception {
        // ví 500 xu, cá rô giá 120 -> còn 380
        var stock = post("/api/fishpond/stock", new StockFryHandler.Req(1, "ca_ro"));
        assertEquals(201, stock.statusCode());
        JsonObject stocked = gson.fromJson(stock.body(), JsonObject.class);
        String id = stocked.get("id").getAsString();
        var wallet = get("/api/wallet?userId=1");
        assertEquals(380, gson.fromJson(wallet.body(), JsonObject.class).get("coins").getAsLong());

        // vừa thả -> đói ngay (fedAt=null, khớp stockFry() client) -> cho ăn được luôn
        var feedFirst = post("/api/fishpond/feed", new FeedFishHandler.Req(1, id));
        assertEquals(200, feedFirst.statusCode());
        var feedTooSoon = post("/api/fishpond/feed", new FeedFishHandler.Req(1, id));
        assertEquals(409, feedTooSoon.statusCode());

        var list = get("/api/fishpond?userId=1");
        assertEquals(200, list.statusCode());
        JsonArray fishes = gson.fromJson(list.body(), JsonArray.class);
        assertEquals(1, fishes.size());
        JsonObject view = fishes.get(0).getAsJsonObject();
        assertFalse(view.get("hungry").getAsBoolean());
        // cá rô growMin=20 phút -> vừa cho ăn xong chưa lớn ngay
        assertFalse(view.get("grown").getAsBoolean());

        var netTooEarly = post("/api/fishpond/net", new NetFishHandler.Req(1, id));
        assertEquals(409, netTooEarly.statusCode());
    }

    @Test
    void pondCapEnforced() throws Exception {
        // 6 cá rô x 120 xu = 720, ví mặc định 500 không đủ -> nạp thêm trước khi test giới hạn ao
        walletDao.addCoins(1, 1000);
        for (int i = 0; i < FishPondService.POND_CAP; i++) {
            var res = post("/api/fishpond/stock", new StockFryHandler.Req(1, "ca_ro"));
            assertEquals(201, res.statusCode());
        }
        var overCap = post("/api/fishpond/stock", new StockFryHandler.Req(1, "ca_ro"));
        assertEquals(409, overCap.statusCode());
    }
}
