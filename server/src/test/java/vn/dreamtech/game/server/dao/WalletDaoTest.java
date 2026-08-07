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

class WalletDaoTest {
    private WalletDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:wallet_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, gold BIGINT NOT NULL DEFAULT 0, diamond BIGINT NOT NULL DEFAULT 0)");
        }
        this.dao = new WalletDao(dataSource);
    }

    @Test
    void defaultsToZeroWhenNeverSaved() throws SQLException {
        var w = dao.find(1);
        assertEquals(0, w.gold());
        assertEquals(0, w.diamond());
    }

    @Test
    void addGoldThenSpendGold() throws SQLException {
        dao.addGold(1, 1000);
        assertTrue(dao.spendGold(1, 400));
        assertEquals(600, dao.find(1).gold());
    }

    @Test
    void spendGoldFailsWhenNotEnough() throws SQLException {
        dao.addGold(1, 100);
        assertFalse(dao.spendGold(1, 500));
        assertEquals(100, dao.find(1).gold());
    }

    @Test
    void diamondIndependentFromGold() throws SQLException {
        dao.addGold(1, 100);
        dao.addDiamond(1, 50);
        var w = dao.find(1);
        assertEquals(100, w.gold());
        assertEquals(50, w.diamond());
    }

    @Test
    void adjustGoldAppliesPositiveDelta() throws SQLException {
        var w = dao.adjustGold(1, 500);
        assertEquals(500, w.gold());
    }

    @Test
    void adjustGoldNegativeDeltaClampsAtZero() throws SQLException {
        dao.addGold(1, 100);
        var w = dao.adjustGold(1, -500);
        assertEquals(0, w.gold());
    }

    @Test
    void adjustDiamondNegativeDeltaClampsAtZero() throws SQLException {
        dao.addDiamond(1, 20);
        var w = dao.adjustDiamond(1, -100);
        assertEquals(0, w.diamond());
    }

    @Test
    void adjustGoldDoesNotTouchDiamond() throws SQLException {
        dao.addDiamond(1, 30);
        dao.adjustGold(1, 100);
        assertEquals(30, dao.find(1).diamond());
    }
}
