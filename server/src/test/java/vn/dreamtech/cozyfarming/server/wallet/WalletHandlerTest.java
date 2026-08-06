package vn.dreamtech.cozyfarming.server.wallet;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.cozyfarming.server.dao.WalletDao;

import javax.sql.DataSource;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;

class WalletHandlerTest {
    private HttpServer server;
    private int port;

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:wallet_handler_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, coins BIGINT NOT NULL DEFAULT 500, gems BIGINT NOT NULL DEFAULT 0)");
        }
        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/wallet", new WalletHandler(new WalletDao(dataSource)));
        server.setExecutor(null);
        server.start();
        port = server.getAddress().getPort();
    }

    @AfterEach
    void stop() {
        server.stop(0);
    }

    @Test
    void missingUserIdReturns400() throws Exception {
        var req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/api/wallet")).GET().build();
        HttpResponse<String> res = HttpClient.newHttpClient().send(req, HttpResponse.BodyHandlers.ofString());
        assertEquals(400, res.statusCode());
    }

    @Test
    void newUserGetsStartingCoins() throws Exception {
        var req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/api/wallet?userId=7")).GET().build();
        HttpResponse<String> res = HttpClient.newHttpClient().send(req, HttpResponse.BodyHandlers.ofString());
        assertEquals(200, res.statusCode());
        JsonObject body = new Gson().fromJson(res.body(), JsonObject.class);
        assertEquals(500, body.get("coins").getAsLong());
        assertEquals(0, body.get("gems").getAsLong());
    }
}
