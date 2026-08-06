package vn.dreamtech.game.server.social.marriage;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.dao.FriendshipDao;
import vn.dreamtech.game.server.dao.MarriageDao;
import vn.dreamtech.game.server.dao.MarriageProposalDao;

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

/** Test trọn luồng cầu hôn/kết hôn qua HTTP thật, DB H2 nhúng. */
class MarriageFlowTest {
    private HttpServer server;
    private int port;
    private FriendshipDao friendshipDao;
    private MarriageDao marriageDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:marriage_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE friendships (
                  user_id_a INT NOT NULL, user_id_b INT NOT NULL, intimacy_points INT NOT NULL DEFAULT 0,
                  last_gift_at TIMESTAMP, created_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id_a, user_id_b)
                )
                """);
            st.execute("""
                CREATE TABLE marriage_proposals (
                  id BIGINT AUTO_INCREMENT PRIMARY KEY, from_user_id INT NOT NULL, to_user_id INT NOT NULL,
                  created_at TIMESTAMP NOT NULL, UNIQUE (from_user_id, to_user_id)
                )
                """);
            st.execute("CREATE TABLE marriages (user_id_a INT NOT NULL, user_id_b INT NOT NULL, married_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id_a, user_id_b))");
        }
        friendshipDao = new FriendshipDao(dataSource);
        MarriageProposalDao proposalDao = new MarriageProposalDao(dataSource);
        marriageDao = new MarriageDao(dataSource);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/marriage/propose", new ProposeHandler(friendshipDao, marriageDao, proposalDao));
        server.createContext("/api/marriage/respond", new RespondProposalHandler(proposalDao, marriageDao));
        server.createContext("/api/marriage/status", new MarriageStatusHandler(marriageDao));
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
    void cannotProposeSelf() throws Exception {
        var res = post("/api/marriage/propose", new ProposeHandler.Req(1, 1));
        assertEquals(400, res.statusCode());
    }

    @Test
    void proposeToNonFriendRejected() throws Exception {
        var res = post("/api/marriage/propose", new ProposeHandler.Req(1, 2));
        assertEquals(404, res.statusCode());
    }

    @Test
    void proposeWithoutEnoughIntimacyRejected() throws Exception {
        friendshipDao.create(1, 2, System.currentTimeMillis());
        friendshipDao.addIntimacy(1, 2, 500, System.currentTimeMillis());
        var res = post("/api/marriage/propose", new ProposeHandler.Req(1, 2));
        assertEquals(409, res.statusCode());
    }

    @Test
    void respondByWrongUserRejected() throws Exception {
        friendshipDao.create(1, 2, System.currentTimeMillis());
        friendshipDao.addIntimacy(1, 2, 1000, System.currentTimeMillis());
        var propose = post("/api/marriage/propose", new ProposeHandler.Req(1, 2));
        long proposalId = gson.fromJson(propose.body(), JsonObject.class).get("id").getAsLong();
        // người cầu hôn không được tự chấp nhận lời cầu hôn của chính mình
        var res = post("/api/marriage/respond", new RespondProposalHandler.Req(proposalId, 1, true));
        assertEquals(403, res.statusCode());
    }

    @Test
    void fullCycle_proposeSpendsRingCostThenAcceptCreatesMarriage() throws Exception {
        friendshipDao.create(1, 2, System.currentTimeMillis());
        friendshipDao.addIntimacy(1, 2, 1000, System.currentTimeMillis());

        var propose = post("/api/marriage/propose", new ProposeHandler.Req(1, 2));
        assertEquals(201, propose.statusCode());
        // mua nhẫn trừ 200 điểm -> còn 800
        assertEquals(1000 - MarriageConstants.RING_COST, friendshipDao.find(1, 2).orElseThrow().intimacyPoints());
        long proposalId = gson.fromJson(propose.body(), JsonObject.class).get("id").getAsLong();

        var statusBefore = get("/api/marriage/status?userId=1");
        assertFalse(gson.fromJson(statusBefore.body(), JsonObject.class).get("married").getAsBoolean());

        var accept = post("/api/marriage/respond", new RespondProposalHandler.Req(proposalId, 2, true));
        assertEquals(200, accept.statusCode());

        var statusAfter = get("/api/marriage/status?userId=1");
        JsonObject afterBody = gson.fromJson(statusAfter.body(), JsonObject.class);
        assertTrue(afterBody.get("married").getAsBoolean());
        assertEquals(2, afterBody.get("spouseUserId").getAsInt());
        assertTrue(marriageDao.isMarried(2));
    }

    @Test
    void cannotProposeWhenAlreadyMarried() throws Exception {
        friendshipDao.create(1, 2, System.currentTimeMillis());
        friendshipDao.addIntimacy(1, 2, 1000, System.currentTimeMillis());
        marriageDao.create(1, 2, System.currentTimeMillis());

        friendshipDao.create(1, 3, System.currentTimeMillis());
        friendshipDao.addIntimacy(1, 3, 1000, System.currentTimeMillis());
        var res = post("/api/marriage/propose", new ProposeHandler.Req(1, 3));
        assertEquals(409, res.statusCode());
    }

    @Test
    void rejectDeletesProposalWithoutMarriageAndRingCostNotRefunded() throws Exception {
        friendshipDao.create(1, 2, System.currentTimeMillis());
        friendshipDao.addIntimacy(1, 2, 1000, System.currentTimeMillis());
        var propose = post("/api/marriage/propose", new ProposeHandler.Req(1, 2));
        long proposalId = gson.fromJson(propose.body(), JsonObject.class).get("id").getAsLong();

        var reject = post("/api/marriage/respond", new RespondProposalHandler.Req(proposalId, 2, false));
        assertEquals(200, reject.statusCode());
        assertFalse(marriageDao.isMarried(1));
        assertEquals(1000 - MarriageConstants.RING_COST, friendshipDao.find(1, 2).orElseThrow().intimacyPoints());
    }
}
