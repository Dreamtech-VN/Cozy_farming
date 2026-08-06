package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.model.Guild;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class GuildDaoTest {
    private GuildDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:guild_dao_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE guilds (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(30) NOT NULL UNIQUE, tag VARCHAR(6) NOT NULL UNIQUE, description VARCHAR(200), leader_user_id INT NOT NULL, created_at TIMESTAMP NOT NULL)");
        }
        this.dao = new GuildDao(dataSource);
    }

    @Test
    void createAndFindById() throws SQLException {
        Guild g = dao.create("Rồng Lửa", "RL", "Guild test", 1);
        var found = dao.findById(g.id());
        assertTrue(found.isPresent());
        assertEquals("Rồng Lửa", found.get().name());
        assertEquals("RL", found.get().tag());
        assertEquals(1, found.get().leaderUserId());
    }

    @Test
    void nameAndTagTaken() throws SQLException {
        dao.create("Rồng Lửa", "RL", null, 1);
        assertTrue(dao.nameTaken("Rồng Lửa"));
        assertTrue(dao.tagTaken("RL"));
        assertFalse(dao.nameTaken("Khác"));
        assertFalse(dao.tagTaken("XX"));
    }

    @Test
    void updateLeaderAndDelete() throws SQLException {
        Guild g = dao.create("Rồng Lửa", "RL", null, 1);
        dao.updateLeader(g.id(), 2);
        assertEquals(2, dao.findById(g.id()).orElseThrow().leaderUserId());

        dao.delete(g.id());
        assertTrue(dao.findById(g.id()).isEmpty());
    }

    @Test
    void listAllReturnsAllGuilds() throws SQLException {
        dao.create("A", "A1", null, 1);
        dao.create("B", "B1", null, 2);
        assertEquals(2, dao.listAll().size());
    }
}
