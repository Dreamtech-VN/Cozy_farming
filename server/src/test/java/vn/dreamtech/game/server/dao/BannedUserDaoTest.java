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

class BannedUserDaoTest {
    private BannedUserDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:banned_user_dao_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE banned_users (user_id INT NOT NULL PRIMARY KEY, reason VARCHAR(255), banned_at TIMESTAMP NOT NULL)");
        }
        this.dao = new BannedUserDao(dataSource);
    }

    @Test
    void notBannedByDefault() throws SQLException {
        assertFalse(dao.isBanned(1));
    }

    @Test
    void banThenBannedTrue() throws SQLException {
        dao.ban(1, "gian lận");
        assertTrue(dao.isBanned(1));
        assertEquals("gian lận", dao.find(1).orElseThrow().reason());
    }

    @Test
    void unbanRemoves() throws SQLException {
        dao.ban(1, "gian lận");
        dao.unban(1);
        assertFalse(dao.isBanned(1));
    }

    @Test
    void banTwiceOverwritesReason() throws SQLException {
        dao.ban(1, "lý do 1");
        dao.ban(1, "lý do 2");
        assertEquals("lý do 2", dao.find(1).orElseThrow().reason());
    }

    @Test
    void scopedPerUser() throws SQLException {
        dao.ban(1, "x");
        assertFalse(dao.isBanned(2));
    }
}
