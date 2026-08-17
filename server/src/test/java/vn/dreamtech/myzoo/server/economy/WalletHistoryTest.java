package vn.dreamtech.myzoo.server.economy;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

class WalletHistoryTest {
    TestSupport.FakeTime time;
    EconomyService economy;

    @BeforeEach
    void setUp() {
        time = new TestSupport.FakeTime();
        economy = new EconomyService(TestSupport.newDb(), time);
    }

    @Test
    void recordsBothEarnAndSpendNewestFirst() {
        economy.earn(1, EconomyService.VANG, 500, "HARVEST", "crop", "wheat");
        time.advance(1000);
        economy.spend(1, EconomyService.VANG, 200, "BUY_SEED", "crop", "corn");

        var entries = economy.history(1, null, 30);
        assertEquals(2, entries.size());
        assertEquals(-200, entries.get(0).amount(), "tin mới nhất đứng đầu");
        assertEquals("BUY_SEED", entries.get(0).reason());
        assertEquals(300, entries.get(0).balanceAfter());
        assertEquals(500, entries.get(1).amount());
    }

    @Test
    void separatesPlayersAndCurrencies() {
        economy.earn(1, EconomyService.VANG, 100, "A", null, null);
        economy.earn(1, EconomyService.KIM_CUONG, 5, "B", null, null);
        economy.earn(2, EconomyService.VANG, 999, "C", null, null);

        var mine = economy.history(1, null, 30);
        assertEquals(2, mine.size(), "không lẫn giao dịch của người khác");
        assertTrue(mine.stream().anyMatch(e -> e.currency().equals(EconomyService.KIM_CUONG)));
        assertEquals(1, economy.history(2, null, 30).size());
    }

    @Test
    void cursorPagingCoversEveryRowExactlyOnce() {
        for (int i = 0; i < 25; i++) economy.earn(1, EconomyService.VANG, 10, "R" + i, null, null);

        List<Long> seen = new ArrayList<>();
        Long cursor = null;
        for (int page = 0; page < 10; page++) {
            var chunk = economy.history(1, cursor, 7);
            if (chunk.isEmpty()) break;
            chunk.forEach(e -> seen.add(e.id()));
            cursor = chunk.get(chunk.size() - 1).id();
            if (chunk.size() < 7) break;
        }

        assertEquals(25, seen.size(), "không sót dòng nào");
        Set<Long> unique = new HashSet<>(seen);
        assertEquals(25, unique.size(), "không lặp dòng nào");
    }

    @Test
    void newRowsDoNotShiftLaterPages() {
        for (int i = 0; i < 10; i++) economy.earn(1, EconomyService.VANG, 10, "cu" + i, null, null);
        var firstPage = economy.history(1, null, 5);

        // Có giao dịch mới chen vào giữa hai lần tải trang — cursor theo id nên trang sau vẫn đúng.
        economy.earn(1, EconomyService.VANG, 10, "moi", null, null);

        var secondPage = economy.history(1, firstPage.get(firstPage.size() - 1).id(), 5);
        assertEquals(5, secondPage.size());
        assertTrue(secondPage.stream().noneMatch(e -> e.reason().equals("moi")));
        assertTrue(secondPage.stream().noneMatch(e -> firstPage.stream().anyMatch(f -> f.id() == e.id())));
    }

    @Test
    void limitIsClamped() {
        assertEquals(30, EconomyService.pageSize(0));
        assertEquals(30, EconomyService.pageSize(-5));
        assertEquals(30, EconomyService.pageSize(1000));
        assertEquals(7, EconomyService.pageSize(7));
    }

    @Test
    void failedSpendLeavesNoLedgerRow() {
        economy.earn(1, EconomyService.VANG, 50, "SEED", null, null);
        assertThrows(vn.dreamtech.myzoo.server.http.ApiException.class,
                () -> economy.spend(1, EconomyService.VANG, 999, "TOO_MUCH", null, null));
        var entries = economy.history(1, null, 30);
        assertEquals(1, entries.size(), "giao dịch hỏng không được ghi sổ");
    }
}
