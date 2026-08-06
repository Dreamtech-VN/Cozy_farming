package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.model.UserSettings;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class UserSettingsDaoTest {
    private UserSettingsDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:settings_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE user_settings (
                  user_id INT NOT NULL PRIMARY KEY, push_notifications TINYINT NOT NULL DEFAULT 1,
                  friend_request_privacy VARCHAR(20) NOT NULL DEFAULT 'EVERYONE',
                  message_privacy VARCHAR(20) NOT NULL DEFAULT 'EVERYONE', language VARCHAR(10) NOT NULL DEFAULT 'vi'
                )
                """);
        }
        this.dao = new UserSettingsDao(dataSource);
    }

    @Test
    void findReturnsDefaultsWhenNeverSaved() throws SQLException {
        var settings = dao.find(1);
        assertTrue(settings.pushNotifications());
        assertEquals("EVERYONE", settings.friendRequestPrivacy());
        assertEquals("vi", settings.language());
    }

    @Test
    void saveThenFindRoundTrips() throws SQLException {
        dao.save(new UserSettings(1, false, "NOBODY", "EVERYONE", "en"));
        var found = dao.find(1);
        assertEquals(false, found.pushNotifications());
        assertEquals("NOBODY", found.friendRequestPrivacy());
        assertEquals("en", found.language());
    }

    @Test
    void saveOverwritesPreviousValue() throws SQLException {
        dao.save(new UserSettings(1, true, "EVERYONE", "EVERYONE", "vi"));
        dao.save(new UserSettings(1, false, "NOBODY", "NOBODY", "en"));
        var found = dao.find(1);
        assertEquals(false, found.pushNotifications());
        assertEquals("NOBODY", found.messagePrivacy());
    }
}
