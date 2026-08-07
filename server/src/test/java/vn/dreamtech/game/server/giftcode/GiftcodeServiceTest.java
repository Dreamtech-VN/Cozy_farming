package vn.dreamtech.game.server.giftcode;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
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
import vn.dreamtech.game.server.item.ItemCategory;
import vn.dreamtech.game.server.item.ItemException;
import vn.dreamtech.game.server.item.RewardEntry;
import vn.dreamtech.game.server.item.RewardGrantService;
import vn.dreamtech.game.server.mail.MailService;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class GiftcodeServiceTest {
    private GiftcodeService giftcodeService;
    private MailService mailService;
    private ItemDao itemDao;
    private WalletDao walletDao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:giftcode_service_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE giftcodes (
                  code VARCHAR(50) NOT NULL PRIMARY KEY, title VARCHAR(100) NOT NULL, rewards VARCHAR(2000) NOT NULL,
                  max_uses INT, used_count INT NOT NULL DEFAULT 0, expires_at TIMESTAMP,
                  active BOOLEAN NOT NULL DEFAULT TRUE, created_at TIMESTAMP NOT NULL
                )
                """);
            st.execute("CREATE TABLE giftcode_redemptions (user_id INT NOT NULL, code VARCHAR(50) NOT NULL, redeemed_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, code))");
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
            st.execute("CREATE TABLE items (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL, category VARCHAR(20) NOT NULL, ref_id INT, description VARCHAR(500))");
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, gold BIGINT NOT NULL DEFAULT 0, diamond BIGINT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE character_levels (user_id INT NOT NULL PRIMARY KEY, level INT NOT NULL DEFAULT 1, exp INT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE player_cosmetics (user_id INT NOT NULL, item_id INT NOT NULL, unlocked_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, item_id))");
            st.execute("CREATE TABLE player_items (user_id INT NOT NULL, item_id INT NOT NULL, quantity INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, item_id))");
        }
        itemDao = new ItemDao(dataSource);
        walletDao = new WalletDao(dataSource);
        LevelDao levelDao = new LevelDao(dataSource);
        PlayerCosmeticDao playerCosmeticDao = new PlayerCosmeticDao(dataSource);
        PlayerItemDao playerItemDao = new PlayerItemDao(dataSource);
        RewardGrantService rewardGrantService = new RewardGrantService(itemDao, walletDao, levelDao, playerCosmeticDao, playerItemDao);
        mailService = new MailService(new MailDao(dataSource), new MailTemplateDao(dataSource),
                new MailBroadcastReceiptDao(dataSource), rewardGrantService);
        giftcodeService = new GiftcodeService(new GiftcodeDao(dataSource), new GiftcodeRedemptionDao(dataSource),
                rewardGrantService, mailService);
    }

    @Test
    void createRejectsDuplicateCode() throws SQLException {
        var item = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        giftcodeService.create("CODE1", "T", List.of(new RewardEntry(item.id(), 100)), null, null);
        var e = assertThrows(ItemException.class, () ->
                giftcodeService.create("CODE1", "T2", List.of(new RewardEntry(item.id(), 50)), null, null));
        assertEquals(409, e.status());
    }

    @Test
    void createRejectsInvalidReward() {
        var e = assertThrows(ItemException.class, () -> giftcodeService.create("CODE1", "T", List.of(new RewardEntry(999, 1)), null, null));
        assertEquals(404, e.status());
    }

    @Test
    void redeemUnknownCodeRejected() {
        var e = assertThrows(ItemException.class, () -> giftcodeService.redeem(1, "NOPE"));
        assertEquals(404, e.status());
    }

    @Test
    void redeemCreatesMailNotDirectGrant() throws SQLException {
        var item = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        giftcodeService.create("CODE1", "Quà tặng", List.of(new RewardEntry(item.id(), 200)), null, null);

        giftcodeService.redeem(1, "CODE1");
        assertEquals(0, walletDao.find(1).gold());
        assertEquals(1, mailService.list(1).size());
    }

    @Test
    void redeemTwiceBySameUserRejected() throws SQLException {
        var item = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        giftcodeService.create("CODE1", "T", List.of(new RewardEntry(item.id(), 100)), null, null);
        giftcodeService.redeem(1, "CODE1");

        var e = assertThrows(ItemException.class, () -> giftcodeService.redeem(1, "CODE1"));
        assertEquals(409, e.status());
    }

    @Test
    void redeemByDifferentUsersBothSucceed() throws SQLException {
        var item = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        giftcodeService.create("CODE1", "T", List.of(new RewardEntry(item.id(), 100)), null, null);
        giftcodeService.redeem(1, "CODE1");
        giftcodeService.redeem(2, "CODE1");
        assertEquals(1, mailService.list(1).size());
        assertEquals(1, mailService.list(2).size());
    }

    @Test
    void redeemAfterMaxUsesReachedRejected() throws SQLException {
        var item = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        giftcodeService.create("CODE1", "T", List.of(new RewardEntry(item.id(), 100)), 1, null);
        giftcodeService.redeem(1, "CODE1");

        var e = assertThrows(ItemException.class, () -> giftcodeService.redeem(2, "CODE1"));
        assertEquals(409, e.status());
    }

    @Test
    void redeemInactiveCodeRejected() throws SQLException {
        var item = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        giftcodeService.create("CODE1", "T", List.of(new RewardEntry(item.id(), 100)), null, null);
        giftcodeService.update("CODE1", "T", List.of(new RewardEntry(item.id(), 100)), null, null, false);

        var e = assertThrows(ItemException.class, () -> giftcodeService.redeem(1, "CODE1"));
        assertEquals(409, e.status());
    }

    @Test
    void redeemExpiredCodeRejected() throws SQLException {
        var item = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        giftcodeService.create("CODE1", "T", List.of(new RewardEntry(item.id(), 100)), null, System.currentTimeMillis() - 1000);

        var e = assertThrows(ItemException.class, () -> giftcodeService.redeem(1, "CODE1"));
        assertEquals(410, e.status());
    }

    @Test
    void deleteThenRedeemRejected() throws SQLException {
        var item = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        giftcodeService.create("CODE1", "T", List.of(new RewardEntry(item.id(), 100)), null, null);
        giftcodeService.delete("CODE1");

        var e = assertThrows(ItemException.class, () -> giftcodeService.redeem(1, "CODE1"));
        assertEquals(404, e.status());
    }

    @Test
    void listAllReturnsCreatedCodes() throws SQLException {
        var item = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        giftcodeService.create("CODE1", "T", List.of(new RewardEntry(item.id(), 100)), null, null);
        giftcodeService.create("CODE2", "T", List.of(new RewardEntry(item.id(), 100)), null, null);
        assertEquals(2, giftcodeService.listAll().size());
    }
}
