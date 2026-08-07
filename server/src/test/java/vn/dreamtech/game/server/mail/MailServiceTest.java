package vn.dreamtech.game.server.mail;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
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

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class MailServiceTest {
    private MailService mailService;
    private ItemDao itemDao;
    private WalletDao walletDao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:mail_service_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
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
    }

    @Test
    void emptyInboxByDefault() {
        assertTrue(mailService.list(1).isEmpty());
    }

    @Test
    void sendToUserThenAppearsInList() {
        mailService.sendToUser(1, "Chào mừng", "Thân", List.of(), "ADMIN", null);
        var list = mailService.list(1);
        assertEquals(1, list.size());
        assertEquals("Chào mừng", list.get(0).title());
    }

    @Test
    void claimGrantsRewardAndMarksClaimed() throws SQLException {
        var item = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        var mail = mailService.sendToUser(1, "Quà", null, List.of(new RewardEntry(item.id(), 300)), "GIFTCODE", null);

        var result = mailService.claim(1, mail.id());
        assertEquals(1, result.granted().size());
        assertEquals(300, walletDao.find(1).gold());

        var mails = mailService.list(1);
        assertEquals(mails.get(0).claimedAt() != null, true);
    }

    @Test
    void claimTwiceRejected() throws SQLException {
        var item = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        var mail = mailService.sendToUser(1, "Quà", null, List.of(new RewardEntry(item.id(), 300)), "GIFTCODE", null);
        mailService.claim(1, mail.id());

        var e = assertThrows(ItemException.class, () -> mailService.claim(1, mail.id()));
        assertEquals(409, e.status());
    }

    @Test
    void claimByWrongUserRejected() {
        var mail = mailService.sendToUser(1, "Quà", null, List.of(), "ADMIN", null);
        var e = assertThrows(ItemException.class, () -> mailService.claim(2, mail.id()));
        assertEquals(403, e.status());
    }

    @Test
    void claimExpiredMailRejected() {
        var mail = mailService.sendToUser(1, "Hết hạn", null, List.of(), "ADMIN", System.currentTimeMillis() - 1000);
        var e = assertThrows(ItemException.class, () -> mailService.claim(1, mail.id()));
        assertEquals(410, e.status());
    }

    @Test
    void claimUnknownMailRejected() {
        var e = assertThrows(ItemException.class, () -> mailService.claim(1, "not-a-real-id"));
        assertEquals(404, e.status());
    }

    @Test
    void broadcastMaterializesLazyOnFirstListPerUser() {
        mailService.broadcast("Toàn server", "Nội dung", List.of(), null);

        var list1 = mailService.list(1);
        assertEquals(1, list1.size());
        assertEquals("Toàn server", list1.get(0).title());

        // gọi list lại không tạo thêm bản sao thứ 2
        var list1Again = mailService.list(1);
        assertEquals(1, list1Again.size());

        // user khác cũng nhận được bản sao riêng của họ
        var list2 = mailService.list(2);
        assertEquals(1, list2.size());
    }

    @Test
    void markReadDoesNotGrantReward() throws SQLException {
        var item = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        var mail = mailService.sendToUser(1, "Quà", null, List.of(new RewardEntry(item.id(), 300)), "GIFTCODE", null);
        mailService.markRead(1, mail.id());
        assertEquals(0, walletDao.find(1).gold());
        assertTrue(mailService.list(1).get(0).readAt() != null);
    }
}
