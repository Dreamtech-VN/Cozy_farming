package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class MarriageActivityDaoTest {
    private MarriageActivityDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:marriage_activity_dao_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE marriage_activity (
                  user_id_a INT NOT NULL, user_id_b INT NOT NULL,
                  last_online_tick_at TIMESTAMP, last_duo_quest_at TIMESTAMP,
                  coop_a_completed_at TIMESTAMP, coop_b_completed_at TIMESTAMP, coop_last_awarded_at TIMESTAMP,
                  PRIMARY KEY (user_id_a, user_id_b)
                )
                """);
        }
        this.dao = new MarriageActivityDao(dataSource);
    }

    @Test
    void emptyByDefault() throws SQLException {
        assertTrue(dao.find(1, 2).isEmpty());
    }

    @Test
    void ensureRowIsIdempotent() throws SQLException {
        dao.ensureRow(1, 2);
        dao.ensureRow(1, 2);
        dao.ensureRow(2, 1);
        var found = dao.find(1, 2);
        assertTrue(found.isPresent());
        assertNull(found.get().lastOnlineTickAt());
    }

    @Test
    void updateOnlineTickPersists() throws SQLException {
        dao.ensureRow(1, 2);
        dao.updateOnlineTick(1, 2, 5000L);
        assertEquals(5000L, dao.find(2, 1).orElseThrow().lastOnlineTickAt());
    }

    @Test
    void updateDuoQuestPersists() throws SQLException {
        dao.ensureRow(1, 2);
        dao.updateDuoQuest(1, 2, 7000L);
        assertEquals(7000L, dao.find(1, 2).orElseThrow().lastDuoQuestAt());
    }

    @Test
    void coopCompletedWritesCorrectColumnRegardlessOfCallOrder() throws SQLException {
        dao.ensureRow(5, 9);
        dao.updateCoopCompleted(9, 5, 9, 1000L);
        var found = dao.find(5, 9).orElseThrow();
        assertEquals(1000L, found.coopBCompletedAt());
        assertNull(found.coopACompletedAt());

        dao.updateCoopCompleted(5, 9, 5, 1500L);
        found = dao.find(5, 9).orElseThrow();
        assertEquals(1500L, found.coopACompletedAt());
    }

    @Test
    void coopAwardedPersists() throws SQLException {
        dao.ensureRow(1, 2);
        dao.updateCoopAwarded(1, 2, 9000L);
        assertEquals(9000L, dao.find(1, 2).orElseThrow().coopLastAwardedAt());
    }
}
