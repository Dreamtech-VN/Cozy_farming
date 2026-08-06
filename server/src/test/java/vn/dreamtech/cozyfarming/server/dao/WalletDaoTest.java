package vn.dreamtech.cozyfarming.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.cozyfarming.server.model.Wallet;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test DAO ví bằng H2 nhúng — bảng {@code wallets} là bảng MỚI, không có trong avatar_2x.sql gốc. */
class WalletDaoTest {
    private WalletDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:wallets_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, coins BIGINT NOT NULL DEFAULT 500, gems BIGINT NOT NULL DEFAULT 0)");
        }
        this.dao = new WalletDao(dataSource);
    }

    @Test
    void findCreatesWalletWithStartingCoinsWhenMissing() throws SQLException {
        Wallet w = dao.find(1);
        assertEquals(1, w.userId());
        assertEquals(500, w.coins());
        assertEquals(0, w.gems());
    }

    @Test
    void spendCoinsDeductsWhenEnough() throws SQLException {
        assertTrue(dao.spendCoins(1, 300));
        assertEquals(200, dao.find(1).coins());
    }

    @Test
    void spendCoinsRejectsWhenNotEnough() throws SQLException {
        assertFalse(dao.spendCoins(1, 9999));
        assertEquals(500, dao.find(1).coins());
    }

    @Test
    void addCoinsCredits() throws SQLException {
        dao.addCoins(1, 100);
        assertEquals(600, dao.find(1).coins());
    }
}
