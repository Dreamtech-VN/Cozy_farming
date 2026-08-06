package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PlayerCosmeticDaoTest {
    private PlayerCosmeticDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:player_cosmetic_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE player_cosmetics (user_id INT NOT NULL, item_id INT NOT NULL, unlocked_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, item_id))");
        }
        this.dao = new PlayerCosmeticDao(dataSource);
    }

    @Test
    void notOwnedByDefault() throws SQLException {
        assertFalse(dao.isOwned(1, 10));
    }

    @Test
    void unlockGrantsOwnership() throws SQLException {
        dao.unlock(1, 10);
        assertTrue(dao.isOwned(1, 10));
        assertTrue(dao.listOwned(1).contains(10));
    }

    @Test
    void unlockIsIdempotent() throws SQLException {
        dao.unlock(1, 10);
        dao.unlock(1, 10);
        assertEqualsSize(1, dao.listOwned(1));
    }

    private static void assertEqualsSize(int expected, java.util.List<Integer> list) {
        org.junit.jupiter.api.Assertions.assertEquals(expected, list.size());
    }
}
