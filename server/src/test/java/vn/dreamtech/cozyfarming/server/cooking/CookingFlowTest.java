package vn.dreamtech.cozyfarming.server.cooking;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.cozyfarming.server.dao.CookingStateDao;
import vn.dreamtech.cozyfarming.server.dao.FarmStoreDao;

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

/** Test trọn luồng nấu ăn: thiếu nguyên liệu bị chặn -> đủ nguyên liệu trừ kho -> bận bếp chặn món 2 -> chưa chín chặn lấy -> hủy trả nguyên liệu. */
class CookingFlowTest {
    private HttpServer server;
    private int port;
    private FarmStoreDao farmStoreDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:cooking_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE cooking_state (user_id INT NOT NULL PRIMARY KEY, food_id VARCHAR(30) NOT NULL, started_at TIMESTAMP NOT NULL)");
            st.execute("CREATE TABLE farm_store (user_id INT NOT NULL, kind VARCHAR(10) NOT NULL, item_id VARCHAR(60) NOT NULL, qty INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, kind, item_id))");
        }
        CookingStateDao cookingStateDao = new CookingStateDao(dataSource);
        farmStoreDao = new FarmStoreDao(dataSource);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/cooking", new CookingHandler(cookingStateDao));
        server.createContext("/api/cooking/start", new StartCookHandler(cookingStateDao, farmStoreDao));
        server.createContext("/api/cooking/collect", new CollectCookHandler(cookingStateDao, farmStoreDao));
        server.createContext("/api/cooking/cancel", new CancelCookHandler(cookingStateDao, farmStoreDao));
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
    void startWithoutIngredientsRejected() throws Exception {
        // corn_grill cần 2 ngô, kho đang trống
        var res = post("/api/cooking/start", new StartCookHandler.Req(1, "corn_grill"));
        assertEquals(409, res.statusCode());
    }

    @Test
    void collectWithNothingCookingRejected() throws Exception {
        var res = post("/api/cooking/collect", new CollectCookHandler.Req(1));
        assertEquals(404, res.statusCode());
    }

    @Test
    void fullCycle_startDeductsThenBusyThenCancelRefunds() throws Exception {
        farmStoreDao.addTo(1, "produce", "corn", 2);

        var start = post("/api/cooking/start", new StartCookHandler.Req(1, "corn_grill"));
        assertEquals(200, start.statusCode());
        assertEquals(0, farmStoreDao.countOf(1, "produce", "corn"));

        // bếp đang bận -> nấu món khác ngay phải bị chặn
        var startAgain = post("/api/cooking/start", new StartCookHandler.Req(1, "corn_grill"));
        assertEquals(409, startAgain.statusCode());

        // chưa đủ giờ -> lấy món ngay phải bị chặn
        var collectTooSoon = post("/api/cooking/collect", new CollectCookHandler.Req(1));
        assertEquals(409, collectTooSoon.statusCode());

        var status = get("/api/cooking?userId=1");
        assertEquals(200, status.statusCode());
        JsonObject view = gson.fromJson(status.body(), JsonObject.class);
        assertEquals("corn_grill", view.get("foodId").getAsString());
        assertTrue(view.get("remainSec").getAsLong() > 0);

        // hủy nấu -> trả lại đúng 2 ngô, bếp rảnh lại
        var cancel = post("/api/cooking/cancel", new CancelCookHandler.Req(1));
        assertEquals(200, cancel.statusCode());
        assertEquals(2, farmStoreDao.countOf(1, "produce", "corn"));

        var statusAfterCancel = get("/api/cooking?userId=1");
        assertEquals("null", statusAfterCancel.body());
    }
}
