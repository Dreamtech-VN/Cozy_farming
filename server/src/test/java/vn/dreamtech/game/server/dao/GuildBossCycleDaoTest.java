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

class GuildBossCycleDaoTest {
    private GuildBossCycleDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:guild_boss_cycle_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE guild_boss_cycles (guild_id INT NOT NULL PRIMARY KEY, remaining_hp INT NOT NULL, cycle_started_at TIMESTAMP NOT NULL, cycle_ends_at TIMESTAMP NOT NULL)");
        }
        this.dao = new GuildBossCycleDao(dataSource);
    }

    @Test
    void emptyByDefault() throws SQLException {
        assertTrue(dao.find(1).isEmpty());
    }

    @Test
    void saveAndFind() throws SQLException {
        dao.save(new GuildBossCycleDao.Cycle(1, 5000, 1000, 2000));
        var found = dao.find(1);
        assertTrue(found.isPresent());
        assertEquals(5000, found.get().remainingHp());
    }

    @Test
    void saveOverwrites() throws SQLException {
        dao.save(new GuildBossCycleDao.Cycle(1, 5000, 1000, 2000));
        dao.save(new GuildBossCycleDao.Cycle(1, 4000, 1000, 2000));
        assertEquals(4000, dao.find(1).orElseThrow().remainingHp());
    }
}
