package vn.dreamtech.game.server.item;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.dao.ItemDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.PlayerCosmeticDao;
import vn.dreamtech.game.server.dao.PlayerItemDao;
import vn.dreamtech.game.server.dao.WalletDao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class RewardGrantServiceTest {
    private RewardGrantService service;
    private ItemDao itemDao;
    private WalletDao walletDao;
    private LevelDao levelDao;
    private PlayerCosmeticDao playerCosmeticDao;
    private PlayerItemDao playerItemDao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:reward_grant_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE items (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL, category VARCHAR(20) NOT NULL, ref_id INT, description VARCHAR(500))");
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, gold BIGINT NOT NULL DEFAULT 0, diamond BIGINT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE character_levels (user_id INT NOT NULL PRIMARY KEY, level INT NOT NULL DEFAULT 1, exp INT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE player_cosmetics (user_id INT NOT NULL, item_id INT NOT NULL, unlocked_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, item_id))");
            st.execute("CREATE TABLE player_items (user_id INT NOT NULL, item_id INT NOT NULL, quantity INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, item_id))");
        }
        itemDao = new ItemDao(dataSource);
        walletDao = new WalletDao(dataSource);
        levelDao = new LevelDao(dataSource);
        playerCosmeticDao = new PlayerCosmeticDao(dataSource);
        playerItemDao = new PlayerItemDao(dataSource);
        service = new RewardGrantService(itemDao, walletDao, levelDao, playerCosmeticDao, playerItemDao);
    }

    @Test
    void grantGoldAddsToWallet() throws SQLException {
        var item = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        service.grant(1, List.of(new RewardEntry(item.id(), 500)));
        assertEquals(500, walletDao.find(1).gold());
    }

    @Test
    void grantDiamondAddsToWallet() throws SQLException {
        var item = itemDao.create("Kim cương", ItemCategory.DIAMOND, null, null);
        service.grant(1, List.of(new RewardEntry(item.id(), 20)));
        assertEquals(20, walletDao.find(1).diamond());
    }

    @Test
    void grantExpAddsAndLevelsUp() throws SQLException {
        var item = itemDao.create("EXP", ItemCategory.EXP, null, null);
        service.grant(1, List.of(new RewardEntry(item.id(), 150)));
        var level = levelDao.find(1);
        assertEquals(2, level.level());
        assertEquals(50, level.exp());
    }

    @Test
    void grantCosmeticUnlocks() throws SQLException {
        var item = itemDao.create("Nón rơm", ItemCategory.COSMETIC, 50, null);
        service.grant(1, List.of(new RewardEntry(item.id(), 1)));
        assertTrue(playerCosmeticDao.isOwned(1, 50));
    }

    @Test
    void grantMaterialAddsToInventory() throws SQLException {
        var item = itemDao.create("Vật liệu", ItemCategory.MATERIAL, null, null);
        service.grant(1, List.of(new RewardEntry(item.id(), 7)));
        assertEquals(7, playerItemDao.findQuantity(1, item.id()));
    }

    @Test
    void grantMultipleEntriesAppliesAll() throws SQLException {
        var gold = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        var diamond = itemDao.create("Kim cương", ItemCategory.DIAMOND, null, null);
        var granted = service.grant(1, List.of(new RewardEntry(gold.id(), 100), new RewardEntry(diamond.id(), 10)));
        assertEquals(2, granted.size());
        assertEquals(100, walletDao.find(1).gold());
        assertEquals(10, walletDao.find(1).diamond());
    }

    @Test
    void grantUnknownItemRejected() {
        var e = assertThrows(ItemException.class, () -> service.grant(1, List.of(new RewardEntry(999, 1))));
        assertEquals(404, e.status());
    }

    @Test
    void validateRewardsRejectsUnknownItem() {
        var e = assertThrows(ItemException.class, () -> service.validateRewards(List.of(new RewardEntry(999, 1))));
        assertEquals(404, e.status());
    }

    @Test
    void validateRewardsRejectsNonPositiveQuantity() throws SQLException {
        var item = itemDao.create("Vàng", ItemCategory.GOLD, null, null);
        var e = assertThrows(ItemException.class, () -> service.validateRewards(List.of(new RewardEntry(item.id(), 0))));
        assertEquals(400, e.status());
    }

    @Test
    void validateRewardsRejectsEmptyList() {
        var e = assertThrows(ItemException.class, () -> service.validateRewards(List.of()));
        assertEquals(400, e.status());
    }
}
