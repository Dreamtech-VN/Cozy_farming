package vn.dreamtech.cozyfarming.server.fishing;

import org.junit.jupiter.api.Test;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test thống kê thuật toán quay trọng số thật (khớp {@code Fish.getRandomFishID()}). */
class FishingServiceTest {
    @Test
    void everyOutcomeIsAKnownFishOrMiss() {
        for (int i = 0; i < 2000; i++) {
            var caught = FishingService.rollCatch();
            if (caught.isPresent()) {
                assertTrue(FishCatalog.FISHES.stream().anyMatch(f -> f.itemId() == caught.get().itemId()));
            }
        }
    }

    @Test
    void sharkIsMuchRarerThanCommonFish() {
        Map<Integer, Integer> counts = new HashMap<>();
        int misses = 0;
        for (int i = 0; i < 5000; i++) {
            var caught = FishingService.rollCatch();
            if (caught.isEmpty()) { misses++; continue; }
            counts.merge(caught.get().itemId(), 1, Integer::sum);
        }
        int sharkCount = counts.getOrDefault(FishCatalog.SHARK_FISH_ID, 0);
        int commonCount = counts.getOrDefault(454, 0);
        // trọng số cá mập 1 so với 80 của cá thường -> phải hiếm hơn NHIỀU trên 5000 lượt
        assertTrue(sharkCount < commonCount);
        // trượt chiếm gần một nửa (400/881) -> phải xảy ra thường xuyên
        assertTrue(misses > 0);
    }
}
