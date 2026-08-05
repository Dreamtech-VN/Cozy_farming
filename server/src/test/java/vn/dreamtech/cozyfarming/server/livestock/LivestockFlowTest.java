package vn.dreamtech.cozyfarming.server.livestock;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.cozyfarming.server.dao.AnimalDao;

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

/** Test trọn luồng mua -> cho ăn -> (chưa lớn nên chưa thu được) -> bán, qua HTTP thật, DB H2 nhúng. */
class LivestockFlowTest {
    private HttpServer server;
    private int port;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:livestock_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE animals (
                  id VARCHAR(40) NOT NULL PRIMARY KEY, user_id INT NOT NULL, type VARCHAR(20) NOT NULL,
                  bought_at TIMESTAMP NOT NULL, fed_at TIMESTAMP NOT NULL, collected_at TIMESTAMP NOT NULL,
                  health DOUBLE DEFAULT 100, sick TINYINT DEFAULT 0, health_at TIMESTAMP
                )
                """);
        }
        AnimalDao animalDao = new AnimalDao(dataSource);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/livestock", new AnimalsHandler(animalDao));
        server.createContext("/api/livestock/buy", new BuyAnimalHandler(animalDao));
        server.createContext("/api/livestock/feed", new FeedAnimalHandler(animalDao));
        server.createContext("/api/livestock/collect", new CollectAnimalHandler(animalDao));
        server.createContext("/api/livestock/sell", new SellAnimalHandler(animalDao));
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
    void buyInvalidTypeRejected() throws Exception {
        var res = post("/api/livestock/buy", new BuyAnimalHandler.Req(1, "dragon"));
        assertEquals(400, res.statusCode());
    }

    @Test
    void fullCycle_buyFeedListSell() throws Exception {
        var buy = post("/api/livestock/buy", new BuyAnimalHandler.Req(1, "chicken"));
        assertEquals(201, buy.statusCode());
        JsonObject bought = gson.fromJson(buy.body(), JsonObject.class);
        String id = bought.get("id").getAsString();

        // vừa mua xong (fedAt=0, khớp buyAnimal() client) -> đã đói ngay, phải cho ăn được luôn
        var feedFirst = post("/api/livestock/feed", new FeedAnimalHandler.Req(1, id));
        assertEquals(200, feedFirst.statusCode());
        // vừa cho ăn xong -> no rồi, cho ăn lại ngay phải bị chặn
        var feedTooSoon = post("/api/livestock/feed", new FeedAnimalHandler.Req(1, id));
        assertEquals(409, feedTooSoon.statusCode());

        var list = get("/api/livestock?userId=1");
        assertEquals(200, list.statusCode());
        JsonArray animals = gson.fromJson(list.body(), JsonArray.class);
        assertEquals(1, animals.size());
        JsonObject view = animals.get(0).getAsJsonObject();
        assertFalse(view.get("hungry").getAsBoolean());
        // gà vừa mua period=0 (chưa lớn) -> chưa có sản phẩm dù không đói
        assertFalse(view.get("hasProduct").getAsBoolean());

        // thu hoạch lúc chưa lớn phải bị chặn
        var collectTooEarly = post("/api/livestock/collect", new CollectAnimalHandler.Req(1, id));
        assertEquals(409, collectTooEarly.statusCode());

        // bán được, hoàn 50% giá (chicken giá 300 -> hoàn 150)
        var sell = post("/api/livestock/sell", new SellAnimalHandler.Req(1, id));
        assertEquals(200, sell.statusCode());
        JsonObject sellBody = gson.fromJson(sell.body(), JsonObject.class);
        assertEquals(150, sellBody.get("refund").getAsInt());

        var listAfterSell = get("/api/livestock?userId=1");
        assertTrue(gson.fromJson(listAfterSell.body(), JsonArray.class).isEmpty());
    }
}
