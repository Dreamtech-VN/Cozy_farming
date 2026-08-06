package vn.dreamtech.game.server.dao;

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

class MarriageDaoTest {
    private MarriageDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:marriage_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE marriages (user_id_a INT NOT NULL, user_id_b INT NOT NULL, married_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id_a, user_id_b))");
        }
        this.dao = new MarriageDao(dataSource);
    }

    @Test
    void notMarriedByDefault() throws SQLException {
        assertFalse(dao.isMarried(1));
    }

    @Test
    void createThenIsMarriedForBothRegardlessOfOrder() throws SQLException {
        dao.create(5, 2, System.currentTimeMillis());
        assertTrue(dao.isMarried(5));
        assertTrue(dao.isMarried(2));
        assertFalse(dao.isMarried(99));
    }

    @Test
    void findSpouseReturnsTheOtherUser() throws SQLException {
        dao.create(5, 2, System.currentTimeMillis());
        assertEquals(2, dao.findSpouse(5).orElseThrow());
        assertEquals(5, dao.findSpouse(2).orElseThrow());
    }
}
