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

/** Test DAO tài khoản bằng H2 nhúng — trọng tâm: 1 user id xuyên suốt qua các lần liên kết. */
class UserDaoTest {
    private UserDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:users_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE users (
                  id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(50) UNIQUE, password_hash VARCHAR(255),
                  guest_token VARCHAR(64) UNIQUE, google_id VARCHAR(128) UNIQUE, apple_id VARCHAR(128) UNIQUE,
                  display_name VARCHAR(50), created_at TIMESTAMP NOT NULL
                )
                """);
        }
        this.dao = new UserDao(dataSource);
    }

    @Test
    void createGuestThenFindByToken() throws SQLException {
        var created = dao.createGuest("tok-1");
        assertTrue(created.isGuestOnly());
        var found = dao.findByGuestToken("tok-1");
        assertEquals(created.id(), found.orElseThrow().id());
    }

    @Test
    void multipleGuestsCanCoexistWithNullUsernames() throws SQLException {
        dao.createGuest("tok-a");
        dao.createGuest("tok-b");
        assertTrue(dao.findByGuestToken("tok-a").isPresent());
        assertTrue(dao.findByGuestToken("tok-b").isPresent());
    }

    @Test
    void upgradeGuestToRealKeepsSameUserId() throws SQLException {
        var guest = dao.createGuest("tok-1");
        dao.upgradeGuestToReal(guest.id(), "player1", "hashed", "player1");
        var found = dao.findById(guest.id()).orElseThrow();
        assertEquals(guest.id(), found.id());
        assertEquals("player1", found.username());
        assertTrue(!found.isGuestOnly());
        // token khách vẫn còn (không xoá), chỉ thêm username/password
        assertEquals("tok-1", found.guestToken());
    }

    @Test
    void linkGoogleThenFindByGoogleId() throws SQLException {
        var user = dao.createReal("player1", "hashed", "player1");
        dao.linkGoogle(user.id(), "g-123");
        var found = dao.findByGoogleId("g-123");
        assertEquals(user.id(), found.orElseThrow().id());
    }
}
