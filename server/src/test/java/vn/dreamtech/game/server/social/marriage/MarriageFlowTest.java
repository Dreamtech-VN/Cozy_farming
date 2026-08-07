package vn.dreamtech.game.server.social.marriage;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.admin.AdminAnnulMarriageHandler;
import vn.dreamtech.game.server.admin.AdminCancelMarriageProposalHandler;
import vn.dreamtech.game.server.dao.DivorceCooldownDao;
import vn.dreamtech.game.server.dao.FriendshipDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.MarriageDao;
import vn.dreamtech.game.server.dao.MarriageProposalDao;
import vn.dreamtech.game.server.dao.PresenceDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.model.LevelInfo;

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

/** Test trọn luồng cầu hôn/kết hôn/ly hôn qua HTTP thật, DB H2 nhúng. */
class MarriageFlowTest {
    private HttpServer server;
    private int port;
    private FriendshipDao friendshipDao;
    private MarriageProposalDao proposalDao;
    private MarriageDao marriageDao;
    private LevelDao levelDao;
    private PresenceDao presenceDao;
    private WalletDao walletDao;
    private DivorceCooldownDao divorceCooldownDao;
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
            st.execute("CREATE TABLE character_levels (user_id INT NOT NULL PRIMARY KEY, level INT NOT NULL DEFAULT 1, exp INT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE lobby_presence (user_id INT NOT NULL PRIMARY KEY, x INT NOT NULL, y INT NOT NULL, last_seen TIMESTAMP NOT NULL)");
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, gold BIGINT NOT NULL DEFAULT 0, diamond BIGINT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE divorce_cooldowns (user_id INT NOT NULL PRIMARY KEY, cooldown_until TIMESTAMP NOT NULL)");
        }
        friendshipDao = new FriendshipDao(dataSource);
        MarriageProposalDao proposalDao = new MarriageProposalDao(dataSource);
        this.proposalDao = proposalDao;
        marriageDao = new MarriageDao(dataSource);
        levelDao = new LevelDao(dataSource);
        presenceDao = new PresenceDao(dataSource);
        walletDao = new WalletDao(dataSource);
        divorceCooldownDao = new DivorceCooldownDao(dataSource);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/marriage/propose", new ProposeHandler(friendshipDao, marriageDao, proposalDao,
                levelDao, presenceDao, walletDao, divorceCooldownDao));
        server.createContext("/api/marriage/respond", new RespondProposalHandler(proposalDao, marriageDao));
        server.createContext("/api/marriage/status", new MarriageStatusHandler(marriageDao));
        server.createContext("/api/marriage/divorce", new DivorceHandler(marriageDao, divorceCooldownDao));
        server.createContext("/api/admin/marriage/annul", new AdminAnnulMarriageHandler(marriageDao, divorceCooldownDao));
        server.createContext("/api/admin/marriage/proposal/cancel", new AdminCancelMarriageProposalHandler(proposalDao));
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

    /** Thiết lập đủ điều kiện cầu hôn CHO CẢ HAI ngoại trừ điều kiện đang test — giữ test tập trung vào 1 nhánh. */
    private void makeEligible(int userA, int userB) throws Exception {
        friendshipDao.create(userA, userB, System.currentTimeMillis() - MarriageConstants.MIN_FRIENDSHIP_DURATION_MS - 60_000);
        friendshipDao.addIntimacy(userA, userB, MarriageConstants.PROPOSAL_THRESHOLD, System.currentTimeMillis());
        levelDao.save(new LevelInfo(userA, MarriageConstants.MIN_LEVEL, 0));
        levelDao.save(new LevelInfo(userB, MarriageConstants.MIN_LEVEL, 0));
        presenceDao.heartbeat(userA, 0, 0, System.currentTimeMillis());
        presenceDao.heartbeat(userB, 0, 0, System.currentTimeMillis());
        walletDao.addGold(userA, MarriageConstants.RING_COST_GOLD);
    }

    @Test
    void cannotProposeSelf() throws Exception {
        var res = post("/api/marriage/propose", new ProposeHandler.Req(1, 1, "gold"));
        assertEquals(400, res.statusCode());
    }

    @Test
    void invalidCurrencyRejected() throws Exception {
        var res = post("/api/marriage/propose", new ProposeHandler.Req(1, 2, "bitcoin"));
        assertEquals(400, res.statusCode());
    }

    @Test
    void proposeToNonFriendRejected() throws Exception {
        var res = post("/api/marriage/propose", new ProposeHandler.Req(1, 2, "gold"));
        assertEquals(404, res.statusCode());
    }

    @Test
    void proposeBelowMinLevelRejected() throws Exception {
        makeEligible(1, 2);
        levelDao.save(new LevelInfo(1, MarriageConstants.MIN_LEVEL - 1, 0));
        var res = post("/api/marriage/propose", new ProposeHandler.Req(1, 2, "gold"));
        assertEquals(409, res.statusCode());
    }

    @Test
    void proposeTooSoonAfterFriendingRejected() throws Exception {
        // kết bạn VỪA XONG (created_at = hiện tại) thay vì đủ 7 ngày như makeEligible()
        friendshipDao.create(1, 2, System.currentTimeMillis());
        friendshipDao.addIntimacy(1, 2, MarriageConstants.PROPOSAL_THRESHOLD, System.currentTimeMillis());
        levelDao.save(new LevelInfo(1, MarriageConstants.MIN_LEVEL, 0));
        levelDao.save(new LevelInfo(2, MarriageConstants.MIN_LEVEL, 0));
        presenceDao.heartbeat(1, 0, 0, System.currentTimeMillis());
        presenceDao.heartbeat(2, 0, 0, System.currentTimeMillis());
        walletDao.addGold(1, MarriageConstants.RING_COST_GOLD);

        var res = post("/api/marriage/propose", new ProposeHandler.Req(1, 2, "gold"));
        assertEquals(409, res.statusCode());
    }

    @Test
    void proposeWithoutEnoughIntimacyRejected() throws Exception {
        friendshipDao.create(1, 2, System.currentTimeMillis() - MarriageConstants.MIN_FRIENDSHIP_DURATION_MS - 60_000);
        friendshipDao.addIntimacy(1, 2, 500, System.currentTimeMillis());
        levelDao.save(new LevelInfo(1, MarriageConstants.MIN_LEVEL, 0));
        levelDao.save(new LevelInfo(2, MarriageConstants.MIN_LEVEL, 0));
        presenceDao.heartbeat(1, 0, 0, System.currentTimeMillis());
        presenceDao.heartbeat(2, 0, 0, System.currentTimeMillis());
        var res = post("/api/marriage/propose", new ProposeHandler.Req(1, 2, "gold"));
        assertEquals(409, res.statusCode());
    }

    @Test
    void proposeWhilePartnerOfflineRejected() throws Exception {
        makeEligible(1, 2);
        presenceDao.remove(2);
        var res = post("/api/marriage/propose", new ProposeHandler.Req(1, 2, "gold"));
        assertEquals(409, res.statusCode());
    }

    @Test
    void proposeWithoutEnoughGoldRejected() throws Exception {
        makeEligible(1, 2);
        // makeEligible chỉ cấp đúng đủ gold, thử tiêu hết trước rồi cầu hôn lại
        walletDao.spendGold(1, MarriageConstants.RING_COST_GOLD);
        var res = post("/api/marriage/propose", new ProposeHandler.Req(1, 2, "gold"));
        assertEquals(402, res.statusCode());
    }

    @Test
    void respondByWrongUserRejected() throws Exception {
        makeEligible(1, 2);
        var propose = post("/api/marriage/propose", new ProposeHandler.Req(1, 2, "gold"));
        long proposalId = gson.fromJson(propose.body(), JsonObject.class).get("id").getAsLong();
        var res = post("/api/marriage/respond", new RespondProposalHandler.Req(proposalId, 1, true));
        assertEquals(403, res.statusCode());
    }

    @Test
    void fullCycle_proposeSpendsGoldThenAcceptCreatesMarriageThenDivorce() throws Exception {
        makeEligible(1, 2);

        var propose = post("/api/marriage/propose", new ProposeHandler.Req(1, 2, "gold"));
        assertEquals(201, propose.statusCode());
        assertEquals(0, walletDao.find(1).gold());
        long proposalId = gson.fromJson(propose.body(), JsonObject.class).get("id").getAsLong();

        var statusBefore = get("/api/marriage/status?userId=1");
        assertFalse(gson.fromJson(statusBefore.body(), JsonObject.class).get("married").getAsBoolean());

        var accept = post("/api/marriage/respond", new RespondProposalHandler.Req(proposalId, 2, true));
        assertEquals(200, accept.statusCode());

        var statusAfter = get("/api/marriage/status?userId=1");
        JsonObject afterBody = gson.fromJson(statusAfter.body(), JsonObject.class);
        assertTrue(afterBody.get("married").getAsBoolean());
        assertEquals(2, afterBody.get("spouseUserId").getAsInt());

        // ly hôn -> hết hôn nhân, cả hai vào cooldown, không cưới lại được ngay
        var divorce = post("/api/marriage/divorce", new DivorceHandler.Req(1));
        assertEquals(200, divorce.statusCode());
        assertFalse(marriageDao.isMarried(1));
        assertTrue(divorceCooldownDao.isInCooldown(1, System.currentTimeMillis()));
        assertTrue(divorceCooldownDao.isInCooldown(2, System.currentTimeMillis()));

        walletDao.addGold(1, MarriageConstants.RING_COST_GOLD);
        var reproposeTooSoon = post("/api/marriage/propose", new ProposeHandler.Req(1, 2, "gold"));
        assertEquals(409, reproposeTooSoon.statusCode());
    }

    @Test
    void cannotProposeWhenAlreadyMarried() throws Exception {
        makeEligible(1, 2);
        marriageDao.create(1, 2, System.currentTimeMillis());

        makeEligible(1, 3);
        var res = post("/api/marriage/propose", new ProposeHandler.Req(1, 3, "gold"));
        assertEquals(409, res.statusCode());
    }

    @Test
    void divorceWithoutMarriageRejected() throws Exception {
        var res = post("/api/marriage/divorce", new DivorceHandler.Req(1));
        assertEquals(404, res.statusCode());
    }

    @Test
    void rejectDeletesProposalWithoutMarriageAndGoldNotRefunded() throws Exception {
        makeEligible(1, 2);
        var propose = post("/api/marriage/propose", new ProposeHandler.Req(1, 2, "gold"));
        long proposalId = gson.fromJson(propose.body(), JsonObject.class).get("id").getAsLong();

        var reject = post("/api/marriage/respond", new RespondProposalHandler.Req(proposalId, 2, false));
        assertEquals(200, reject.statusCode());
        assertFalse(marriageDao.isMarried(1));
        assertEquals(0, walletDao.find(1).gold());
    }

    @Test
    void adminAnnulMarriageRequiresAdminToken() throws Exception {
        var res = post("/api/admin/marriage/annul", new AdminAnnulMarriageHandler.Req(1));
        assertEquals(503, res.statusCode());
    }

    @Test
    void adminCancelMarriageProposalRequiresAdminToken() throws Exception {
        var res = post("/api/admin/marriage/proposal/cancel", new AdminCancelMarriageProposalHandler.Req(1));
        assertEquals(503, res.statusCode());
    }
}
