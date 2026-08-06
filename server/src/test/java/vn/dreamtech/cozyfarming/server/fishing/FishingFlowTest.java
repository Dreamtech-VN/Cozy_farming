package vn.dreamtech.cozyfarming.server.fishing;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.cozyfarming.server.dao.BagDao;
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
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test trọn luồng câu cá: hết mồi bị chặn -> mỗi lần quăng trừ đúng 1 mồi -> câu được thì cộng đúng xu (tự bán ngay, khớp Lttt thật). */
class FishingFlowTest {
    private HttpServer server;
    private int port;
    private BagDao bagDao;
    private WalletDao walletDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:fishing_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE bag_items (user_id INT NOT NULL, item_id VARCHAR(60) NOT NULL, qty INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, item_id))");
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, coins BIGINT NOT NULL DEFAULT 500, gems BIGINT NOT NULL DEFAULT 0)");
        }
        bagDao = new BagDao(dataSource);
        walletDao = new WalletDao(dataSource);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/fishing/cast", new CastHandler(bagDao, walletDao));
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
    void castWithoutBaitRejected() throws Exception {
        var res = post("/api/fishing/cast", new CastHandler.Req(1));
        assertEquals(409, res.statusCode());
    }

    @Test
    void eachCastConsumesExactlyOneBait() throws Exception {
        bagDao.addTo(1, FishCatalog.BAIT_ITEM_ID, 3);
        for (int i = 0; i < 3; i++) {
            var res = post("/api/fishing/cast", new CastHandler.Req(1));
            assertEquals(200, res.statusCode());
        }
        assertEquals(0, bagDao.countOf(1, FishCatalog.BAIT_ITEM_ID));
        var overCast = post("/api/fishing/cast", new CastHandler.Req(1));
        assertEquals(409, overCast.statusCode());
    }

    @Test
    void catchAlwaysCreditsExactCoinOfCaughtFish() throws Exception {
        // câu nhiều lần tới khi có ít nhất 1 lần trúng, xác nhận xu cộng đúng giá cá đó
        bagDao.addTo(1, FishCatalog.BAIT_ITEM_ID, 200);
        boolean sawCatch = false;
        for (int i = 0; i < 200; i++) {
            long before = walletDao.find(1).coins();
            var res = post("/api/fishing/cast", new CastHandler.Req(1));
            assertEquals(200, res.statusCode());
            JsonObject body = gson.fromJson(res.body(), JsonObject.class);
            long after = walletDao.find(1).coins();
            if (body.get("caught").getAsBoolean()) {
                sawCatch = true;
                int coin = body.get("coin").getAsInt();
                assertEquals(before + coin, after);
                assertTrue(coin > 0);
            } else {
                assertEquals(before, after);
            }
        }
        assertTrue(sawCatch, "phải có ít nhất 1 lần câu được trong 200 lượt (xác suất trúng ~54%)");
    }
}
