package vn.dreamtech.cozyfarming.server.cooking;

import org.junit.jupiter.api.Test;
import vn.dreamtech.cozyfarming.server.model.CookingState;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test công thức chép từ {@code cookRemain()} trong {@code src/systems/cooking.ts}. */
class CookingServiceTest {
    private static final FoodDef CORN_GRILL = FoodCatalog.find("corn_grill").orElseThrow();

    @Test
    void notDoneRightAfterStart() {
        CookingState s = new CookingState(1, "corn_grill", System.currentTimeMillis());
        assertFalse(CookingService.isDone(s, CORN_GRILL));
    }

    @Test
    void doneAfterCookMinElapsed() {
        long startedLongAgo = System.currentTimeMillis() - (CORN_GRILL.cookMin() * 60_000L + 1000);
        CookingState s = new CookingState(1, "corn_grill", startedLongAgo);
        assertTrue(CookingService.isDone(s, CORN_GRILL));
    }
}
