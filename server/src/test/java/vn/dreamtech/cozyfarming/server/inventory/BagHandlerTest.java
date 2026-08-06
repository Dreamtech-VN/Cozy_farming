package vn.dreamtech.cozyfarming.server.inventory;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.cozyfarming.server.dao.BagDao;

import javax.sql.DataSource;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;

class BagHandlerTest {
    private HttpServer server;
    private int port;
    private final Gson gson = new Gson();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:bag_handler_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE bag_items (user_id INT NOT NULL, item_id VARCHAR(60) NOT NULL, qty INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, item_id))");
            st.execute("INSERT INTO bag_items VALUES (1, 'feed', 4)");
        }
        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/inventory/bag", new BagHandler(new BagDao(dataSource)));
        server.setExecutor(null);
        server.start();
        port = server.getAddress().getPort();
    }

    @AfterEach
    void stop() {
        server.stop(0);
    }

    @Test
    void listsBagItems() throws Exception {
        var req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/api/inventory/bag?userId=1")).GET().build();
        HttpResponse<String> res = HttpClient.newHttpClient().send(req, HttpResponse.BodyHandlers.ofString());
        assertEquals(200, res.statusCode());
        JsonObject body = gson.fromJson(res.body(), JsonObject.class);
        assertEquals(4, body.get("feed").getAsInt());
    }

    @Test
    void missingUserIdReturns400() throws Exception {
        var req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/api/inventory/bag")).GET().build();
        HttpResponse<String> res = HttpClient.newHttpClient().send(req, HttpResponse.BodyHandlers.ofString());
        assertEquals(400, res.statusCode());
    }
}
