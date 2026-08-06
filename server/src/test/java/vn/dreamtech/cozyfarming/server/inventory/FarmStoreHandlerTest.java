package vn.dreamtech.cozyfarming.server.inventory;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
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

class FarmStoreHandlerTest {
    private HttpServer server;
    private int port;
    private final Gson gson = new Gson();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:farmstore_handler_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE farm_store (user_id INT NOT NULL, kind VARCHAR(10) NOT NULL, item_id VARCHAR(60) NOT NULL, qty INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, kind, item_id))");
            st.execute("INSERT INTO farm_store VALUES (1, 'seeds', 'carrot', 5)");
            st.execute("INSERT INTO farm_store VALUES (1, 'produce', 'egg', 2)");
        }
        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/inventory/farmstore", new FarmStoreHandler(new FarmStoreDao(dataSource)));
        server.setExecutor(null);
        server.start();
        port = server.getAddress().getPort();
    }

    @AfterEach
    void stop() {
        server.stop(0);
    }

    private HttpResponse<String> get(String path) throws Exception {
        var req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + path)).GET().build();
        return HttpClient.newHttpClient().send(req, HttpResponse.BodyHandlers.ofString());
    }

    @Test
    void filtersByKind() throws Exception {
        var res = get("/api/inventory/farmstore?userId=1&kind=seeds");
        assertEquals(200, res.statusCode());
        JsonObject body = gson.fromJson(res.body(), JsonObject.class);
        assertEquals(5, body.get("carrot").getAsInt());
    }

    @Test
    void withoutKindReturnsAllFourSlots() throws Exception {
        var res = get("/api/inventory/farmstore?userId=1");
        assertEquals(200, res.statusCode());
        JsonObject body = gson.fromJson(res.body(), JsonObject.class);
        assertTrue(body.has("seeds"));
        assertTrue(body.has("produce"));
        assertTrue(body.has("fert"));
        assertTrue(body.has("fish"));
    }

    @Test
    void invalidKindRejected() throws Exception {
        var res = get("/api/inventory/farmstore?userId=1&kind=bogus");
        assertEquals(400, res.statusCode());
    }
}
