package vn.dreamtech.cozyfarming.server.wardrobe;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.cozyfarming.server.dao.ItemDao;

import javax.sql.DataSource;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;

class ItemsHandlerTest {
    private HttpServer server;
    private int port;

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:items_handler_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE items (
                  id INT PRIMARY KEY, coin INT, gold SMALLINT, type SMALLINT, icon SMALLINT,
                  name VARCHAR(200), sell TINYINT, expired_day TINYINT, zorder TINYINT,
                  gender TINYINT, level TINYINT, animation CLOB
                )
                """);
            st.execute("INSERT INTO items VALUES (1, 10000, -1, -1, 1, 'dựng đứng', 2, 0, 50, 1, 0, '[]')");
            st.execute("INSERT INTO items VALUES (21, 8000, -1, -1, 40, 'búp bê', 1, 0, 50, 2, 0, '[]')");
        }
        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/items", new ItemsHandler(new ItemDao(dataSource)));
        server.setExecutor(null);
        server.start();
        port = server.getAddress().getPort();
    }

    @AfterEach
    void stop() {
        server.stop(0);
    }

    @Test
    void filtersHairByGender() throws Exception {
        var req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/api/items?zorder=50&gender=1")).GET().build();
        HttpResponse<String> res = HttpClient.newHttpClient().send(req, HttpResponse.BodyHandlers.ofString());
        assertEquals(200, res.statusCode());
        JsonArray arr = new Gson().fromJson(res.body(), JsonArray.class);
        assertEquals(1, arr.size());
        assertEquals("dựng đứng", arr.get(0).getAsJsonObject().get("name").getAsString());
    }
}
