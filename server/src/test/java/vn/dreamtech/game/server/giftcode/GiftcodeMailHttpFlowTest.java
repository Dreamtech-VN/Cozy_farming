package vn.dreamtech.game.server.giftcode;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.dao.EventBoardDao;
import vn.dreamtech.game.server.dao.GiftcodeDao;
import vn.dreamtech.game.server.dao.GiftcodeRedemptionDao;
import vn.dreamtech.game.server.dao.ItemDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.MailBroadcastReceiptDao;
import vn.dreamtech.game.server.dao.MailDao;
import vn.dreamtech.game.server.dao.MailTemplateDao;
import vn.dreamtech.game.server.dao.PlayerCosmeticDao;
import vn.dreamtech.game.server.dao.PlayerItemDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.event.EventBoardHandler;
import vn.dreamtech.game.server.event.EventBoardService;
import vn.dreamtech.game.server.item.ItemCatalogHandler;
import vn.dreamtech.game.server.item.ItemCategory;
import vn.dreamtech.game.server.item.RewardEntry;
import vn.dreamtech.game.server.item.RewardGrantService;
import vn.dreamtech.game.server.mail.MailClaimHandler;
import vn.dreamtech.game.server.mail.MailListHandler;
import vn.dreamtech.game.server.mail.MailService;

import javax.sql.DataSource;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;

/** Test nối dây HTTP thật: đổi giftcode -> hộp thư -> nhận thưởng, cùng /api/items/catalog và /api/events/board (public). */
class GiftcodeMailHttpFlowTest {
    private HttpServer server;
    private int port;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();
    private ItemDao itemDao;
    private GiftcodeService giftcodeService;
    private WalletDao walletDao;
    private EventBoardService eventBoardService;

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:giftcode_mail_http_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE items (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL, category VARCHAR(20) NOT NULL, ref_id INT, description VARCHAR(500))");
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, gold BIGINT NOT NULL DEFAULT 0, diamond BIGINT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE character_levels (user_id INT NOT NULL PRIMARY KEY, level INT NOT NULL DEFAULT 1, exp INT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE player_cosmetics (user_id INT NOT NULL, item_id INT NOT NULL, unlocked_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, item_id))");
            st.execute("CREATE TABLE player_items (user_id INT NOT NULL, item_id INT NOT NULL, quantity INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, item_id))");
            st.execute("""
                CREATE TABLE mails (
                  id VARCHAR(36) NOT NULL PRIMARY KEY, user_id INT NOT NULL, title VARCHAR(100) NOT NULL,
                  body VARCHAR(1000), rewards VARCHAR(2000) NOT NULL, source VARCHAR(20) NOT NULL,
                  created_at TIMESTAMP NOT NULL, expires_at TIMESTAMP, read_at TIMESTAMP, claimed_at TIMESTAMP
                )
                """);
            st.execute("""
                CREATE TABLE mail_templates (
                  id VARCHAR(36) NOT NULL PRIMARY KEY, title VARCHAR(100) NOT NULL, body VARCHAR(1000),
                  rewards VARCHAR(2000) NOT NULL, created_at TIMESTAMP NOT NULL, expires_at TIMESTAMP,
                  active BOOLEAN NOT NULL DEFAULT TRUE
                )
                """);
            st.execute("CREATE TABLE mail_broadcast_receipts (user_id INT NOT NULL, template_id VARCHAR(36) NOT NULL, PRIMARY KEY (user_id, template_id))");
            st.execute("""
                CREATE TABLE giftcodes (
                  code VARCHAR(50) NOT NULL PRIMARY KEY, title VARCHAR(100) NOT NULL, rewards VARCHAR(2000) NOT NULL,
                  max_uses INT, used_count INT NOT NULL DEFAULT 0, expires_at TIMESTAMP,
                  active BOOLEAN NOT NULL DEFAULT TRUE, created_at TIMESTAMP NOT NULL
                )
                """);
            st.execute("CREATE TABLE giftcode_redemptions (user_id INT NOT NULL, code VARCHAR(50) NOT NULL, redeemed_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, code))");
            st.execute("""
                CREATE TABLE event_board (
                  id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(100) NOT NULL, description VARCHAR(1000),
                  start_at TIMESTAMP NOT NULL, end_at TIMESTAMP NOT NULL, active BOOLEAN NOT NULL DEFAULT TRUE,
                  created_at TIMESTAMP NOT NULL
                )
                """);
        }
        itemDao = new ItemDao(dataSource);
        walletDao = new WalletDao(dataSource);
        LevelDao levelDao = new LevelDao(dataSource);
        PlayerCosmeticDao playerCosmeticDao = new PlayerCosmeticDao(dataSource);
        PlayerItemDao playerItemDao = new PlayerItemDao(dataSource);
        RewardGrantService rewardGrantService = new RewardGrantService(itemDao, walletDao, levelDao, playerCosmeticDao, playerItemDao);
        MailService mailService = new MailService(new MailDao(dataSource), new MailTemplateDao(dataSource),
                new MailBroadcastReceiptDao(dataSource), rewardGrantService);
        giftcodeService = new GiftcodeService(new GiftcodeDao(dataSource), new GiftcodeRedemptionDao(dataSource),
                rewardGrantService, mailService);
        eventBoardService = new EventBoardService(new EventBoardDao(dataSource));

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/items/catalog", new ItemCatalogHandler(itemDao));
        server.createContext("/api/giftcode/redeem", new RedeemGiftcodeHandler(giftcodeService));
        server.createContext("/api/mail/list", new MailListHandler(mailService));
        server.createContext("/api/mail/claim", new MailClaimHandler(mailService));
        server.createContext("/api/events/board", new EventBoardHandler(eventBoardService));
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
    void itemCatalogListsSeededItems() throws Exception {
        itemDao.create("Vàng nhỏ", ItemCategory.GOLD, null, "100 vàng");
        var res = get("/api/items/catalog");
        assertEquals(200, res.statusCode());
        JsonArray arr = gson.fromJson(res.body(), JsonArray.class);
        assertEquals(1, arr.size());
    }

    @Test
    void eventsBoardListsActiveEvents() throws Exception {
        long now = System.currentTimeMillis();
        eventBoardService.create("Lễ hội", "mô tả", now - 1000, now + 100_000);
        var res = get("/api/events/board");
        assertEquals(200, res.statusCode());
        JsonArray arr = gson.fromJson(res.body(), JsonArray.class);
        assertEquals(1, arr.size());
    }

    @Test
    void fullFlow_redeemGiftcodeThenClaimMailGrantsGold() throws Exception {
        var item = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        giftcodeService.create("HELLO2026", "Chào mừng", List.of(new RewardEntry(item.id(), 500)), null, null);

        var redeem = post("/api/giftcode/redeem", new RedeemGiftcodeHandler.Req(1, "HELLO2026"));
        assertEquals(201, redeem.statusCode());

        var listRes = get("/api/mail/list?userId=1");
        assertEquals(200, listRes.statusCode());
        JsonArray mails = gson.fromJson(listRes.body(), JsonArray.class);
        assertEquals(1, mails.size());
        String mailId = mails.get(0).getAsJsonObject().get("id").getAsString();

        var claimRes = post("/api/mail/claim", Map.of("userId", 1, "mailId", mailId));
        assertEquals(200, claimRes.statusCode());
        JsonObject claimBody = gson.fromJson(claimRes.body(), JsonObject.class);
        assertEquals(1, claimBody.getAsJsonArray("granted").size());

        assertEquals(500, walletDao.find(1).gold());
    }

    @Test
    void redeemSameCodeTwiceRejected() throws Exception {
        var item = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        giftcodeService.create("ONCE", "T", List.of(new RewardEntry(item.id(), 100)), null, null);

        post("/api/giftcode/redeem", new RedeemGiftcodeHandler.Req(1, "ONCE"));
        var second = post("/api/giftcode/redeem", new RedeemGiftcodeHandler.Req(1, "ONCE"));
        assertEquals(409, second.statusCode());
    }
}
