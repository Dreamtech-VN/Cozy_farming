package vn.dreamtech.cozyfarming.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test DAO kho nông trại bằng H2 nhúng — khớp {@code FarmStore} client (seeds/produce/fert/fish). */
class FarmStoreDaoTest {
    private FarmStoreDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:farmstore_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE farm_store (user_id INT NOT NULL, kind VARCHAR(10) NOT NULL, item_id VARCHAR(60) NOT NULL, qty INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, kind, item_id))");
        }
        this.dao = new FarmStoreDao(dataSource);
    }

    @Test
    void addToCreatesThenAccumulates() throws SQLException {
        dao.addTo(1, "seeds", "carrot", 5);
        dao.addTo(1, "seeds", "carrot", 3);
        assertEquals(8, dao.countOf(1, "seeds", "carrot"));
    }

    @Test
    void addToNegativeDeletesRowWhenReachesZero() throws SQLException {
        dao.addTo(1, "seeds", "carrot", 2);
        dao.addTo(1, "seeds", "carrot", -2);
        assertEquals(0, dao.countOf(1, "seeds", "carrot"));
        assertTrue(dao.listOf(1, "seeds").isEmpty());
    }

    @Test
    void takeFromFailsWhenNotEnough() throws SQLException {
        dao.addTo(1, "seeds", "carrot", 1);
        assertFalse(dao.takeFrom(1, "seeds", "carrot", 5));
        assertEquals(1, dao.countOf(1, "seeds", "carrot"));
    }

    @Test
    void takeFromSucceedsAndDeducts() throws SQLException {
        dao.addTo(1, "produce", "egg", 10);
        assertTrue(dao.takeFrom(1, "produce", "egg", 4));
        assertEquals(6, dao.countOf(1, "produce", "egg"));
    }

    @Test
    void listOfFiltersByKindAndUser() throws SQLException {
        dao.addTo(1, "seeds", "carrot", 2);
        dao.addTo(1, "produce", "egg", 3);
        dao.addTo(2, "seeds", "carrot", 9);
        Map<String, Integer> seeds = dao.listOf(1, "seeds");
        assertEquals(1, seeds.size());
        assertEquals(2, seeds.get("carrot"));
    }
}
