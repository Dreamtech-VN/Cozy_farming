package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.item.RewardEntry;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class GiftcodeDaoTest {
    private GiftcodeDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:giftcode_dao_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE giftcodes (
                  code VARCHAR(50) NOT NULL PRIMARY KEY, title VARCHAR(100) NOT NULL, rewards VARCHAR(2000) NOT NULL,
                  max_uses INT, used_count INT NOT NULL DEFAULT 0, expires_at TIMESTAMP,
                  active BOOLEAN NOT NULL DEFAULT TRUE, created_at TIMESTAMP NOT NULL
                )
                """);
        }
        this.dao = new GiftcodeDao(dataSource);
    }

    @Test
    void createAndFind() throws SQLException {
        dao.create("SUMMER2026", "Quà hè", List.of(new RewardEntry(1, 500)), 100, null);
        var found = dao.find("SUMMER2026").orElseThrow();
        assertEquals("Quà hè", found.title());
        assertEquals(100, found.maxUses());
        assertEquals(0, found.usedCount());
        assertTrue(found.active());
        assertNull(found.expiresAt());
    }

    @Test
    void unlimitedUsesWhenMaxUsesNull() throws SQLException {
        dao.create("FREE", "Không giới hạn", List.of(), null, null);
        assertNull(dao.find("FREE").orElseThrow().maxUses());
    }

    @Test
    void incrementUsedCountAccumulates() throws SQLException {
        dao.create("CODE1", "T", List.of(), null, null);
        dao.incrementUsedCount("CODE1");
        dao.incrementUsedCount("CODE1");
        assertEquals(2, dao.find("CODE1").orElseThrow().usedCount());
    }

    @Test
    void updateOverwritesFieldsButKeepsUsedCount() throws SQLException {
        dao.create("CODE1", "T", List.of(), null, null);
        dao.incrementUsedCount("CODE1");
        dao.update("CODE1", "Mới", List.of(new RewardEntry(2, 1)), 5, 9999L, false);
        var found = dao.find("CODE1").orElseThrow();
        assertEquals("Mới", found.title());
        assertEquals(5, found.maxUses());
        assertFalse(found.active());
        assertEquals(1, found.usedCount());
    }

    @Test
    void deleteRemoves() throws SQLException {
        dao.create("CODE1", "T", List.of(), null, null);
        dao.delete("CODE1");
        assertTrue(dao.find("CODE1").isEmpty());
    }

    @Test
    void findAllReturnsEverything() throws SQLException {
        dao.create("A", "T", List.of(), null, null);
        dao.create("B", "T", List.of(), null, null);
        assertEquals(2, dao.findAll().size());
    }
}
