package vn.dreamtech.cozyfarming.server.cooking;

import vn.dreamtech.cozyfarming.server.model.CookingState;

/** Chép ĐÚNG công thức trong {@code src/systems/cooking.ts} — {@code cookRemain()}. */
public final class CookingService {
    /** Giây còn lại; 0 = xong. */
    public static long remainSeconds(CookingState state, FoodDef def) {
        long doneAt = state.startedAt() + def.cookMin() * 60_000L;
        return Math.max(0, Math.ceilDiv(doneAt - System.currentTimeMillis(), 1000L));
    }

    public static boolean isDone(CookingState state, FoodDef def) {
        return remainSeconds(state, def) <= 0;
    }

    private CookingService() {
    }
}
