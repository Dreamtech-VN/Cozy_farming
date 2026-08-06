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

class WorldBossCycleDaoTest {
    private WorldBossCycleDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:world_boss_cycle_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE world_boss_cycle (id INT NOT NULL PRIMARY KEY, remaining_hp INT NOT NULL, cycle_started_at TIMESTAMP NOT NULL, cycle_ends_at TIMESTAMP NOT NULL)");
        }
        this.dao = new WorldBossCycleDao(dataSource);
    }

    @Test
    void emptyByDefault() throws SQLException {
        assertTrue(dao.find().isEmpty());
    }

    @Test
    void saveAndFind() throws SQLException {
        dao.save(new WorldBossCycleDao.Cycle(50_000, 1000, 2000));
        var found = dao.find();
        assertTrue(found.isPresent());
        assertEquals(50_000, found.get().remainingHp());
    }

    @Test
    void saveOverwritesSingleton() throws SQLException {
        dao.save(new WorldBossCycleDao.Cycle(50_000, 1000, 2000));
        dao.save(new WorldBossCycleDao.Cycle(40_000, 1000, 2000));
        assertEquals(40_000, dao.find().orElseThrow().remainingHp());
    }
}
