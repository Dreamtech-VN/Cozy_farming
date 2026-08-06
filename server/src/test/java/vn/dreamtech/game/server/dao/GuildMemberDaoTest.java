package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.model.GuildRole;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class GuildMemberDaoTest {
    private GuildMemberDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:guild_member_dao_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE guild_members (user_id INT NOT NULL PRIMARY KEY, guild_id INT NOT NULL, role VARCHAR(10) NOT NULL, joined_at TIMESTAMP NOT NULL)");
        }
        this.dao = new GuildMemberDao(dataSource);
    }

    @Test
    void joinAndFind() throws SQLException {
        dao.join(1, 100, GuildRole.LEADER);
        var found = dao.findByUserId(1);
        assertTrue(found.isPresent());
        assertEquals(100, found.get().guildId());
        assertEquals(GuildRole.LEADER, found.get().role());
    }

    @Test
    void countAndListByGuild() throws SQLException {
        dao.join(1, 100, GuildRole.LEADER);
        dao.join(2, 100, GuildRole.MEMBER);
        dao.join(3, 200, GuildRole.LEADER);
        assertEquals(2, dao.countMembers(100));
        assertEquals(2, dao.listByGuild(100).size());
        assertEquals(1, dao.countMembers(200));
    }

    @Test
    void leaveRemovesMembership() throws SQLException {
        dao.join(1, 100, GuildRole.LEADER);
        dao.leave(1);
        assertTrue(dao.findByUserId(1).isEmpty());
    }

    @Test
    void leaveGuildRemovesAllMembers() throws SQLException {
        dao.join(1, 100, GuildRole.LEADER);
        dao.join(2, 100, GuildRole.MEMBER);
        dao.leaveGuild(100);
        assertEquals(0, dao.countMembers(100));
    }

    @Test
    void updateRoleChangesRole() throws SQLException {
        dao.join(1, 100, GuildRole.MEMBER);
        dao.updateRole(1, GuildRole.OFFICER);
        assertEquals(GuildRole.OFFICER, dao.findByUserId(1).orElseThrow().role());
    }
}
