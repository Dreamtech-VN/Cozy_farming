package vn.dreamtech.cozyfarming.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.cozyfarming.server.model.PondFish;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test DAO ao cá bằng H2 nhúng — bảng {@code pond_fish} là bảng MỚI, không có trong avatar_2x.sql gốc. */
class PondFishDaoTest {
    private DataSource dataSource;
    private PondFishDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:pondfish_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        this.dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE pond_fish (
                  id VARCHAR(40) NOT NULL PRIMARY KEY, user_id INT NOT NULL, type VARCHAR(20) NOT NULL,
                  at TIMESTAMP NOT NULL, fed_at TIMESTAMP
                )
                """);
        }
        this.dao = new PondFishDao(dataSource);
    }

    @Test
    void upsertThenFindRoundTripsNullFedAt() throws SQLException {
        PondFish f = new PondFish("f1", "ca_ro", System.currentTimeMillis(), null);
        dao.upsert(1, f);
        Optional<PondFish> found = dao.find(1, "f1");
        assertTrue(found.isPresent());
        assertNull(found.get().fedAt());
        assertEquals("ca_ro", found.get().type());
    }

    @Test
    void countByUserOnlyCountsOwnFish() throws SQLException {
        dao.upsert(1, new PondFish("f1", "ca_ro", System.currentTimeMillis(), null));
        dao.upsert(1, new PondFish("f2", "ca_chep", System.currentTimeMillis(), null));
        dao.upsert(2, new PondFish("f3", "ca_ro", System.currentTimeMillis(), null));
        assertEquals(2, dao.countByUser(1));
        assertEquals(1, dao.countByUser(2));
    }

    @Test
    void deleteRemovesFish() throws SQLException {
        dao.upsert(1, new PondFish("f1", "ca_ro", System.currentTimeMillis(), null));
        dao.delete(1, "f1");
        assertTrue(dao.find(1, "f1").isEmpty());
    }
}
