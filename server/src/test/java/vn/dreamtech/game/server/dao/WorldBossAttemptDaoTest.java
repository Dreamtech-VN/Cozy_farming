package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class WorldBossAttemptDaoTest {
    private WorldBossAttemptDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:world_boss_attempt_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE world_boss_attempts (user_id INT NOT NULL PRIMARY KEY, cycle_started_at TIMESTAMP NOT NULL)");
        }
        this.dao = new WorldBossAttemptDao(dataSource);
    }

    @Test
    void emptyByDefault() throws SQLException {
        assertTrue(dao.findAttemptedCycle(1).isEmpty());
    }

    @Test
    void recordAndFind() throws SQLException {
        dao.recordAttempt(1, 1000);
        assertEquals(1000, dao.findAttemptedCycle(1).orElseThrow());
    }

    @Test
    void recordOverwritesForNewCycle() throws SQLException {
        dao.recordAttempt(1, 1000);
        dao.recordAttempt(1, 2000);
        assertEquals(2000, dao.findAttemptedCycle(1).orElseThrow());
    }
}
