package vn.dreamtech.cozyfarming.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test DAO bếp bằng H2 nhúng — bảng {@code cooking_state} là bảng MỚI, mỗi user tối đa 1 dòng. */
class CookingStateDaoTest {
    private CookingStateDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:cooking_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE cooking_state (user_id INT NOT NULL PRIMARY KEY, food_id VARCHAR(30) NOT NULL, started_at TIMESTAMP NOT NULL)");
        }
        this.dao = new CookingStateDao(dataSource);
    }

    @Test
    void startThenFindRoundTrips() throws SQLException {
        long now = System.currentTimeMillis();
        dao.start(1, "corn_grill", now);
        var found = dao.find(1);
        assertTrue(found.isPresent());
        assertEquals("corn_grill", found.get().foodId());
    }

    @Test
    void startOverwritesPreviousForSameUser() throws SQLException {
        dao.start(1, "corn_grill", System.currentTimeMillis());
        dao.start(1, "salad", System.currentTimeMillis());
        assertEquals("salad", dao.find(1).orElseThrow().foodId());
    }

    @Test
    void clearRemovesState() throws SQLException {
        dao.start(1, "corn_grill", System.currentTimeMillis());
        dao.clear(1);
        assertTrue(dao.find(1).isEmpty());
    }
}
