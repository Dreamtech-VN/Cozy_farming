package vn.dreamtech.cozyfarming.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test DAO túi đồ bằng H2 nhúng — khớp {@code S.inventory} client (đồ dùng/quà/nguyên liệu). */
class BagDaoTest {
    private BagDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:bag_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE bag_items (user_id INT NOT NULL, item_id VARCHAR(60) NOT NULL, qty INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, item_id))");
        }
        this.dao = new BagDao(dataSource);
    }

    @Test
    void addToAccumulates() throws SQLException {
        dao.addTo(1, "feed", 3);
        dao.addTo(1, "feed", 2);
        assertEquals(5, dao.countOf(1, "feed"));
    }

    @Test
    void takeFromFailsWhenNotEnough() throws SQLException {
        dao.addTo(1, "feed", 1);
        assertFalse(dao.takeFrom(1, "feed", 2));
        assertEquals(1, dao.countOf(1, "feed"));
    }

    @Test
    void takeFromSucceedsAndDeducts() throws SQLException {
        dao.addTo(1, "feed", 3);
        assertTrue(dao.takeFrom(1, "feed", 1));
        assertEquals(2, dao.countOf(1, "feed"));
    }

    @Test
    void listAllExcludesZero() throws SQLException {
        dao.addTo(1, "feed", 2);
        dao.addTo(1, "animal_med", 1);
        dao.takeFrom(1, "animal_med", 1);
        assertEquals(1, dao.listAll(1).size());
        assertTrue(dao.listAll(1).containsKey("feed"));
    }
}
