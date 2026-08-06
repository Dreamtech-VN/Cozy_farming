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

class GuildWarAttemptDaoTest {
    private GuildWarAttemptDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:guild_war_attempt_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE guild_war_attempts (user_id INT NOT NULL, war_id VARCHAR(36) NOT NULL, attempted_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, war_id))");
        }
        this.dao = new GuildWarAttemptDao(dataSource);
    }

    @Test
    void notAttemptedByDefault() throws SQLException {
        assertFalse(dao.hasAttempted(1, "w1"));
    }

    @Test
    void recordThenAttemptedTrue() throws SQLException {
        dao.recordAttempt(1, "w1");
        assertTrue(dao.hasAttempted(1, "w1"));
    }

    @Test
    void attemptScopedPerWar() throws SQLException {
        dao.recordAttempt(1, "w1");
        assertFalse(dao.hasAttempted(1, "w2"));
    }

    @Test
    void attemptScopedPerUser() throws SQLException {
        dao.recordAttempt(1, "w1");
        assertFalse(dao.hasAttempted(2, "w1"));
    }
}
