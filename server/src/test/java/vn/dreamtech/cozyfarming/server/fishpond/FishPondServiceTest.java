package vn.dreamtech.cozyfarming.server.fishpond;

import org.junit.jupiter.api.Test;
import vn.dreamtech.cozyfarming.server.model.PondFish;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test công thức chép từ {@code src/systems/fishfarm.ts} — trọng tâm: đủ tuổi nhưng ĐÓI vẫn KHÔNG được coi là "lớn". */
class FishPondServiceTest {
    private static final FryDef CA_RO = FryCatalog.find("ca_ro").orElseThrow();

    @Test
    void hungryWhenNeverFed() {
        PondFish f = new PondFish("f1", "ca_ro", System.currentTimeMillis(), null);
        assertTrue(FishPondService.isHungry(f));
    }

    @Test
    void hungryAfterFourHoursSinceLastFeed() {
        long fiveHoursAgo = System.currentTimeMillis() - 5 * 3_600_000L;
        PondFish f = new PondFish("f1", "ca_ro", System.currentTimeMillis(), fiveHoursAgo);
        assertTrue(FishPondService.isHungry(f));
    }

    @Test
    void notHungryRightAfterFeed() {
        PondFish f = new PondFish("f1", "ca_ro", System.currentTimeMillis(), System.currentTimeMillis());
        assertFalse(FishPondService.isHungry(f));
    }

    @Test
    void oldEnoughButHungryIsNotGrown() {
        long stockedLongAgo = System.currentTimeMillis() - CA_RO.growMin() * 60_000L - 60_000L;
        // đủ tuổi lâu rồi nhưng chưa từng cho ăn -> vẫn đói -> KHÔNG được vớt
        PondFish f = new PondFish("f1", "ca_ro", stockedLongAgo, null);
        assertFalse(FishPondService.isGrown(f, CA_RO));
    }

    @Test
    void oldEnoughAndFedIsGrown() {
        long stockedLongAgo = System.currentTimeMillis() - CA_RO.growMin() * 60_000L - 60_000L;
        PondFish f = new PondFish("f1", "ca_ro", stockedLongAgo, System.currentTimeMillis());
        assertTrue(FishPondService.isGrown(f, CA_RO));
    }

    @Test
    void tooYoungIsNotGrownEvenIfFed() {
        PondFish f = new PondFish("f1", "ca_ro", System.currentTimeMillis(), System.currentTimeMillis());
        assertFalse(FishPondService.isGrown(f, CA_RO));
    }
}
