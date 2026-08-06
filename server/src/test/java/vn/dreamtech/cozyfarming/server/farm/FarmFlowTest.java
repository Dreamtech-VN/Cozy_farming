package vn.dreamtech.cozyfarming.server.farm;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.cozyfarming.server.dao.FarmPlotDao;
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

/** Test trọn luồng cuốc -> trồng -> tưới -> thu hoạch qua HTTP thật, DB là H2 nhúng. */
class FarmFlowTest {
    private HttpServer server;
    private int port;
    private FarmStoreDao farmStoreDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:farm_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE farm_plots (
                  user_id INT NOT NULL, idx INT NOT NULL, state VARCHAR(10) NOT NULL,
                  crop_id VARCHAR(30), planted_at TIMESTAMP, watered TINYINT DEFAULT 0,
                  watered_at TIMESTAMP, fertilized TINYINT DEFAULT 0, health INT DEFAULT 100,
                  PRIMARY KEY (user_id, idx)
                )
                """);
            // ô 0 bắt đầu ở trạng thái "empty" (đất đã mở nhưng chưa cuốc)
            st.execute("INSERT INTO farm_plots (user_id, idx, state, health) VALUES (1, 0, 'empty', 100)");
            st.execute("CREATE TABLE farm_store (user_id INT NOT NULL, kind VARCHAR(10) NOT NULL, item_id VARCHAR(60) NOT NULL, qty INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, kind, item_id))");
            // sẵn 5 hạt cà rốt trong kho để test trồng được
            st.execute("INSERT INTO farm_store VALUES (1, 'seeds', 'carrot', 5)");
        }
        FarmPlotDao plotDao = new FarmPlotDao(dataSource);
        farmStoreDao = new FarmStoreDao(dataSource);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/farm/plots", new FarmPlotsHandler(plotDao));
        server.createContext("/api/farm/till", new TillHandler(plotDao));
        server.createContext("/api/farm/plant", new PlantHandler(plotDao, farmStoreDao));
        server.createContext("/api/farm/water", new WaterHandler(plotDao));
        server.createContext("/api/farm/harvest", new HarvestHandler(plotDao, farmStoreDao));
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
    void tillThenPlantOnUntilledPlotRejected() throws Exception {
        var plant = post("/api/farm/plant", new PlantHandler.Req(1, 0, "carrot"));
        assertEquals(409, plant.statusCode());   // chưa cuốc thì không trồng được
    }

    @Test
    void fullCycle_tillPlantWaterHarvest() throws Exception {
        var till = post("/api/farm/till", new TillHandler.Req(1, 0));
        assertEquals(200, till.statusCode());

        var plant = post("/api/farm/plant", new PlantHandler.Req(1, 0, "carrot"));
        assertEquals(200, plant.statusCode());
        // trồng xong phải trừ đúng 1 hạt trong kho (5 -> 4)
        assertEquals(4, farmStoreDao.countOf(1, "seeds", "carrot"));

        var water = post("/api/farm/water", new WaterHandler.Req(1, 0));
        assertEquals(200, water.statusCode());
        JsonObject wateredBody = gson.fromJson(water.body(), JsonObject.class);
        assertTrue(wateredBody.get("watered").getAsBoolean());

        // cà rốt growMin=2 phút -> chưa chín ngay lúc vừa trồng
        var harvestTooSoon = post("/api/farm/harvest", new HarvestHandler.Req(1, 0));
        assertEquals(409, harvestTooSoon.statusCode());

        // xem danh sách ô đất: phải thấy đúng trạng thái planted + đã tưới
        var list = get("/api/farm/plots?userId=1");
        assertEquals(200, list.statusCode());
        JsonArray plots = gson.fromJson(list.body(), JsonArray.class);
        assertEquals(1, plots.size());
        assertEquals("planted", plots.get(0).getAsJsonObject().get("state").getAsString());
    }
}
