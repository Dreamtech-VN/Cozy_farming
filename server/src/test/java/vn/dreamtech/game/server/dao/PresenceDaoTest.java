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

class PresenceDaoTest {
    private PresenceDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:presence_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE lobby_presence (user_id INT NOT NULL PRIMARY KEY, x INT NOT NULL, y INT NOT NULL, last_seen TIMESTAMP NOT NULL)");
        }
        this.dao = new PresenceDao(dataSource);
    }

    @Test
    void heartbeatThenListActiveWithinWindow() throws SQLException {
        long now = System.currentTimeMillis();
        dao.heartbeat(1, 10, 20, now);
        var active = dao.listActive(now, 5_000);
        assertEquals(1, active.size());
        assertEquals(10, active.get(0).x());
    }

    @Test
    void staleHeartbeatExcludedFromActiveList() throws SQLException {
        long now = System.currentTimeMillis();
        dao.heartbeat(1, 0, 0, now - 60_000);
        var active = dao.listActive(now, 5_000);
        assertTrue(active.isEmpty());
    }

    @Test
    void heartbeatOverwritesPreviousPosition() throws SQLException {
        long now = System.currentTimeMillis();
        dao.heartbeat(1, 1, 1, now);
        dao.heartbeat(1, 99, 99, now);
        var active = dao.listActive(now, 5_000);
        assertEquals(1, active.size());
        assertEquals(99, active.get(0).x());
    }

    @Test
    void removeDropsFromActiveList() throws SQLException {
        long now = System.currentTimeMillis();
        dao.heartbeat(1, 0, 0, now);
        dao.remove(1);
        assertTrue(dao.listActive(now, 5_000).isEmpty());
    }
}
