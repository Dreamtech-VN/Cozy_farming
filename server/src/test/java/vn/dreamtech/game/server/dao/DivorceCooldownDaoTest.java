package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class DivorceCooldownDaoTest {
    private DivorceCooldownDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:divorce_cooldown_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE divorce_cooldowns (user_id INT NOT NULL PRIMARY KEY, cooldown_until TIMESTAMP NOT NULL)");
        }
        this.dao = new DivorceCooldownDao(dataSource);
    }

    @Test
    void noCooldownByDefault() throws SQLException {
        assertFalse(dao.isInCooldown(1, System.currentTimeMillis()));
    }

    @Test
    void inCooldownWhenUntilIsInFuture() throws SQLException {
        long now = System.currentTimeMillis();
        dao.setCooldown(1, now + 60_000);
        assertTrue(dao.isInCooldown(1, now));
    }

    @Test
    void notInCooldownAfterExpiry() throws SQLException {
        long now = System.currentTimeMillis();
        dao.setCooldown(1, now - 1000);
        assertFalse(dao.isInCooldown(1, now));
    }
}
