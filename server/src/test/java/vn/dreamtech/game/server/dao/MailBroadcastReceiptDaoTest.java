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

class MailBroadcastReceiptDaoTest {
    private MailBroadcastReceiptDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:mail_broadcast_receipt_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE mail_broadcast_receipts (user_id INT NOT NULL, template_id VARCHAR(36) NOT NULL, PRIMARY KEY (user_id, template_id))");
        }
        this.dao = new MailBroadcastReceiptDao(dataSource);
    }

    @Test
    void notReceivedByDefault() throws SQLException {
        assertFalse(dao.hasReceived(1, "t1"));
    }

    @Test
    void markThenReceivedTrue() throws SQLException {
        dao.markReceived(1, "t1");
        assertTrue(dao.hasReceived(1, "t1"));
    }

    @Test
    void scopedPerUserAndTemplate() throws SQLException {
        dao.markReceived(1, "t1");
        assertFalse(dao.hasReceived(2, "t1"));
        assertFalse(dao.hasReceived(1, "t2"));
    }
}
