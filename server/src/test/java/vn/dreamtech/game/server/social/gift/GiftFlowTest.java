package vn.dreamtech.game.server.social.gift;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.dao.FriendshipDao;

import javax.sql.DataSource;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;

/** Test trọn luồng tặng quà tăng thân mật qua HTTP thật, DB H2 nhúng. */
class GiftFlowTest {
    private HttpServer server;
    private int port;
    private FriendshipDao friendshipDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:gift_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE friendships (
                  user_id_a INT NOT NULL, user_id_b INT NOT NULL, intimacy_points INT NOT NULL DEFAULT 0,
                  last_gift_at TIMESTAMP, created_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id_a, user_id_b)
                )
                """);
        }
        friendshipDao = new FriendshipDao(dataSource);
        friendshipDao.create(1, 2, System.currentTimeMillis());

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/friends/gift", new SendGiftHandler(friendshipDao));
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

    @Test
    void giftToNonFriendRejected() throws Exception {
        var res = post("/api/friends/gift", new SendGiftHandler.Req(1, 99, "flower"));
        assertEquals(404, res.statusCode());
    }

    @Test
    void invalidGiftIdRejected() throws Exception {
        var res = post("/api/friends/gift", new SendGiftHandler.Req(1, 2, "spaceship"));
        assertEquals(400, res.statusCode());
    }

    @Test
    void giftIncreasesIntimacyThenCooldownBlocksSecondGiftSameDay() throws Exception {
        var first = post("/api/friends/gift", new SendGiftHandler.Req(1, 2, "chocolate"));
        assertEquals(200, first.statusCode());
        JsonObject body = gson.fromJson(first.body(), JsonObject.class);
        assertEquals(25, body.get("intimacyPoints").getAsInt());

        var second = post("/api/friends/gift", new SendGiftHandler.Req(1, 2, "flower"));
        assertEquals(429, second.statusCode());
        // bị chặn -> điểm không đổi thêm
        assertEquals(25, friendshipDao.find(1, 2).orElseThrow().intimacyPoints());
    }

    @Test
    void giftWorksRegardlessOfWhoIsFromOrTo() throws Exception {
        post("/api/friends/gift", new SendGiftHandler.Req(2, 1, "jewelry"));
        assertEquals(100, friendshipDao.find(1, 2).orElseThrow().intimacyPoints());
    }
}
