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

class GuildWarDaoTest {
    private GuildWarDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:guild_war_dao_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE guild_wars (id VARCHAR(36) NOT NULL PRIMARY KEY, guild_a INT NOT NULL, guild_b INT NOT NULL, score_a INT NOT NULL DEFAULT 0, score_b INT NOT NULL DEFAULT 0, status VARCHAR(10) NOT NULL, started_at TIMESTAMP NOT NULL, ends_at TIMESTAMP NOT NULL, winner_guild_id INT)");
        }
        this.dao = new GuildWarDao(dataSource);
    }

    @Test
    void emptyByDefault() throws SQLException {
        assertTrue(dao.find("w1").isEmpty());
        assertTrue(dao.findActiveByGuild(1).isEmpty());
        assertTrue(dao.findLatestByGuild(1).isEmpty());
    }

    @Test
    void createAndFind() throws SQLException {
        dao.create(new GuildWarDao.War("w1", 1, 2, 0, 0, "ONGOING", 1000, 2000, null));
        var found = dao.find("w1");
        assertTrue(found.isPresent());
        assertEquals(1, found.get().guildA());
        assertEquals(2, found.get().guildB());
        assertEquals("ONGOING", found.get().status());
        assertEquals(null, found.get().winnerGuildId());
    }

    @Test
    void saveOverwritesScoresAndStatus() throws SQLException {
        dao.create(new GuildWarDao.War("w1", 1, 2, 0, 0, "ONGOING", 1000, 2000, null));
        dao.save(new GuildWarDao.War("w1", 1, 2, 300, 150, "RESOLVED", 1000, 2000, 1));
        var found = dao.find("w1").orElseThrow();
        assertEquals(300, found.scoreA());
        assertEquals(150, found.scoreB());
        assertEquals("RESOLVED", found.status());
        assertEquals(1, found.winnerGuildId());
    }

    @Test
    void findActiveByGuildOnlyReturnsOngoing() throws SQLException {
        dao.create(new GuildWarDao.War("w1", 1, 2, 0, 0, "RESOLVED", 1000, 2000, 1));
        assertFalse(dao.findActiveByGuild(1).isPresent());

        dao.create(new GuildWarDao.War("w2", 1, 3, 0, 0, "ONGOING", 1500, 2500, null));
        var active = dao.findActiveByGuild(1);
        assertTrue(active.isPresent());
        assertEquals("w2", active.get().id());

        // cả 2 phía (guildA hoặc guildB) đều tìm ra
        assertTrue(dao.findActiveByGuild(3).isPresent());
    }

    @Test
    void findLatestByGuildReturnsMostRecentRegardlessOfStatus() throws SQLException {
        dao.create(new GuildWarDao.War("w1", 1, 2, 0, 0, "RESOLVED", 1000, 2000, 1));
        dao.create(new GuildWarDao.War("w2", 1, 3, 0, 0, "ONGOING", 3000, 4000, null));

        var latest = dao.findLatestByGuild(1);
        assertTrue(latest.isPresent());
        assertEquals("w2", latest.get().id());
    }
}
