package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;

class GuildBossContributionDaoTest {
    private GuildBossContributionDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:guild_boss_contribution_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE guild_boss_contributions (guild_id INT NOT NULL, user_id INT NOT NULL, cycle_started_at TIMESTAMP NOT NULL, total_damage INT NOT NULL DEFAULT 0, PRIMARY KEY (guild_id, user_id, cycle_started_at))");
        }
        this.dao = new GuildBossContributionDao(dataSource);
    }

    @Test
    void addDamageAccumulates() throws SQLException {
        dao.addDamage(1, 10, 1000, 50);
        dao.addDamage(1, 10, 1000, 30);
        var list = dao.listByCycle(1, 1000);
        assertEquals(1, list.size());
        assertEquals(80, list.get(0).totalDamage());
    }

    @Test
    void listOrderedByDamageDesc() throws SQLException {
        dao.addDamage(1, 10, 1000, 30);
        dao.addDamage(1, 20, 1000, 90);
        var list = dao.listByCycle(1, 1000);
        assertEquals(20, list.get(0).userId());
        assertEquals(10, list.get(1).userId());
    }

    @Test
    void differentCyclesTrackedSeparately() throws SQLException {
        dao.addDamage(1, 10, 1000, 50);
        dao.addDamage(1, 10, 2000, 20);
        assertEquals(50, dao.listByCycle(1, 1000).get(0).totalDamage());
        assertEquals(20, dao.listByCycle(1, 2000).get(0).totalDamage());
    }
}
