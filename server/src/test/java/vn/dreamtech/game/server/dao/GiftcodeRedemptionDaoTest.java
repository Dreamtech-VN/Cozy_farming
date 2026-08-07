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

class GiftcodeRedemptionDaoTest {
    private GiftcodeRedemptionDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:giftcode_redemption_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE giftcode_redemptions (user_id INT NOT NULL, code VARCHAR(50) NOT NULL, redeemed_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, code))");
        }
        this.dao = new GiftcodeRedemptionDao(dataSource);
    }

    @Test
    void notRedeemedByDefault() throws SQLException {
        assertFalse(dao.hasRedeemed(1, "CODE1"));
    }

    @Test
    void recordThenRedeemedTrue() throws SQLException {
        dao.recordRedemption(1, "CODE1");
        assertTrue(dao.hasRedeemed(1, "CODE1"));
    }

    @Test
    void scopedPerUserAndCode() throws SQLException {
        dao.recordRedemption(1, "CODE1");
        assertFalse(dao.hasRedeemed(2, "CODE1"));
        assertFalse(dao.hasRedeemed(1, "CODE2"));
    }
}
