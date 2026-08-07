package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.item.ItemCategory;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ItemDaoTest {
    private ItemDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:item_dao_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE items (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL, category VARCHAR(20) NOT NULL, ref_id INT, description VARCHAR(500))");
        }
        this.dao = new ItemDao(dataSource);
    }

    @Test
    void createAndFind() throws SQLException {
        var item = dao.create("Vàng nhỏ", ItemCategory.GOLD, null, "100 vàng");
        var found = dao.find(item.id());
        assertTrue(found.isPresent());
        assertEquals("Vàng nhỏ", found.get().name());
        assertEquals(ItemCategory.GOLD, found.get().category());
        assertNull(found.get().refId());
    }

    @Test
    void createCosmeticWithRefId() throws SQLException {
        var item = dao.create("Nón rơm", ItemCategory.COSMETIC, 50, "Cosmetic id 50");
        var found = dao.find(item.id()).orElseThrow();
        assertEquals(50, found.refId());
    }

    @Test
    void updateOverwrites() throws SQLException {
        var item = dao.create("Vàng nhỏ", ItemCategory.GOLD, null, null);
        dao.update(item.id(), "Vàng lớn", ItemCategory.DIAMOND, 5, "đổi loại");
        var found = dao.find(item.id()).orElseThrow();
        assertEquals("Vàng lớn", found.name());
        assertEquals(ItemCategory.DIAMOND, found.category());
        assertEquals(5, found.refId());
    }

    @Test
    void deleteRemoves() throws SQLException {
        var item = dao.create("Tạm", ItemCategory.MATERIAL, null, null);
        dao.delete(item.id());
        assertTrue(dao.find(item.id()).isEmpty());
    }

    @Test
    void findAllReturnsEverything() throws SQLException {
        dao.create("A", ItemCategory.GOLD, null, null);
        dao.create("B", ItemCategory.DIAMOND, null, null);
        assertEquals(2, dao.findAll().size());
    }
}
