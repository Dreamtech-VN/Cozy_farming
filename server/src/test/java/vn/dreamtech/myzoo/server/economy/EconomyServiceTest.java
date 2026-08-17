package vn.dreamtech.myzoo.server.economy;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.http.ApiException;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import static org.junit.jupiter.api.Assertions.*;

class EconomyServiceTest {
    DataSource db;
    EconomyService economy;

    @BeforeEach
    void setUp() {
        db = TestSupport.newDb();
        economy = new EconomyService(db, new TestSupport.FakeTime());
    }

    @Test
    void earnAndSpendUpdateBalance() {
        assertEquals(500, economy.earn(1, EconomyService.VANG, 500, "TEST", "t", "1"));
        assertEquals(300, economy.spend(1, EconomyService.VANG, 200, "TEST", "t", "2"));
        assertEquals(300, economy.balances(1).get(EconomyService.VANG));
        assertEquals(0, economy.balances(1).get(EconomyService.KIM_CUONG));
    }

    @Test
    void spendBeyondBalanceRejectedWith402() {
        economy.earn(1, EconomyService.VANG, 100, "TEST", "t", "1");
        ApiException e = assertThrows(ApiException.class,
                () -> economy.spend(1, EconomyService.VANG, 101, "TEST", "t", "2"));
        assertEquals(402, e.status());
        assertEquals(100, economy.balances(1).get(EconomyService.VANG));
    }

    @Test
    void everyChangeWritesLedgerRow() throws Exception {
        economy.earn(7, EconomyService.VANG, 500, "STARTER", "player", "7");
        economy.spend(7, EconomyService.VANG, 120, "SEED", "plot", "wheat");
        try (Connection c = db.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT amount, balance_after, reason FROM economy_ledger WHERE player_id = 7 ORDER BY id")) {
            try (ResultSet rs = ps.executeQuery()) {
                assertTrue(rs.next());
                assertEquals(500, rs.getLong("amount"));
                assertEquals(500, rs.getLong("balance_after"));
                assertEquals("STARTER", rs.getString("reason"));
                assertTrue(rs.next());
                assertEquals(-120, rs.getLong("amount"));
                assertEquals(380, rs.getLong("balance_after"));
                assertEquals("SEED", rs.getString("reason"));
                assertFalse(rs.next());
            }
        }
    }
}
