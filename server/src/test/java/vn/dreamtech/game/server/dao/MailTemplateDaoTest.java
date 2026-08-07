package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class MailTemplateDaoTest {
    private MailTemplateDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:mail_template_dao_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE mail_templates (
                  id VARCHAR(36) NOT NULL PRIMARY KEY, title VARCHAR(100) NOT NULL, body VARCHAR(1000),
                  rewards VARCHAR(2000) NOT NULL, created_at TIMESTAMP NOT NULL, expires_at TIMESTAMP,
                  active BOOLEAN NOT NULL DEFAULT TRUE
                )
                """);
        }
        this.dao = new MailTemplateDao(dataSource);
    }

    @Test
    void findActiveExcludesExpired() throws SQLException {
        dao.create("Còn hạn", null, List.of(), 1000L, 5000L);
        dao.create("Hết hạn", null, List.of(), 1000L, 2000L);
        var active = dao.findActive(3000L);
        assertEquals(1, active.size());
        assertEquals("Còn hạn", active.get(0).title());
    }

    @Test
    void findActiveIncludesNoExpiry() throws SQLException {
        dao.create("Vô thời hạn", null, List.of(), 1000L, null);
        var active = dao.findActive(999_999_999L);
        assertEquals(1, active.size());
    }

    @Test
    void createdTemplateStartsActive() throws SQLException {
        var t = dao.create("A", null, List.of(), 1000L, null);
        assertTrue(t.active());
    }
}
