package vn.dreamtech.cozyfarming.server.fishpond;

import vn.dreamtech.cozyfarming.server.model.PondFish;

/**
 * Chép ĐÚNG công thức trong {@code src/systems/fishfarm.ts} — cá đói (chưa
 * từng cho ăn, hoặc quá 4 giờ kể từ lần ăn gần nhất, ngưỡng giống hệt
 * {@code livestock.ts}), và CHỈ "lớn xong" (isGrown) khi vừa đủ thời gian
 * VỪA không đói — cá đói dù đủ tuổi vẫn không vớt được, phải cho ăn tiếp.
 */
public final class FishPondService {
    public static final int POND_CAP = 6;
    private static final long HUNGRY_AFTER_MS = 4 * 3_600_000L;

    public static long grownAt(PondFish f, FryDef def) {
        return f.at() + def.growMin() * 60_000L;
    }

    public static boolean isHungry(PondFish f) {
        return f.fedAt() == null || System.currentTimeMillis() - f.fedAt() > HUNGRY_AFTER_MS;
    }

    public static boolean isGrown(PondFish f, FryDef def) {
        return System.currentTimeMillis() >= grownAt(f, def) && !isHungry(f);
    }

    public static int remainMin(PondFish f, FryDef def) {
        long ms = grownAt(f, def) - System.currentTimeMillis();
        return (int) Math.max(0, Math.ceil(ms / 60_000.0));
    }

    private FishPondService() {
    }
}
