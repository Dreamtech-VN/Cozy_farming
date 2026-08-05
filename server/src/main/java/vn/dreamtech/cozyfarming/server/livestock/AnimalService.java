package vn.dreamtech.cozyfarming.server.livestock;

import vn.dreamtech.cozyfarming.server.model.Animal;

/**
 * Chép ĐÚNG công thức trong `src/systems/livestock.ts` (đã đồng bộ Lttt thật
 * ở phiên trước — giai đoạn lớn theo `FarmScr.cs:3639-3646`, sức khoẻ/bệnh là
 * ƯỚC LƯỢNG vì không trích được công thức thật của server gốc, xem comment
 * trong file client). Copy nguyên hằng số, không tự đổi.
 */
public final class AnimalService {
    private static final double HEALTH_DECAY_PER_HOUR = 2;
    private static final double HEALTH_REGEN_PER_HOUR = 3;
    private static final long HUNGRY_AFTER_MS = 4 * 3_600_000L;

    public static boolean isHungry(Animal a) {
        return System.currentTimeMillis() - a.fedAt() > HUNGRY_AFTER_MS;
    }

    /** period 0/1/2 — tuổi(phút) / (maturityMin/2), tối đa 2 (đã lớn, cho sản phẩm được). */
    public static int growthPeriod(Animal a, AnimalDef def) {
        double ageMin = (System.currentTimeMillis() - a.boughtAt()) / 60_000.0;
        double step = def.maturityMin() / 2.0;
        if (step <= 0) return 2;
        return (int) Math.min(2, Math.floor(ageMin / step));
    }

    /** Sức khoẻ hiện tại, tính lại theo giờ trôi qua kể từ lần cập nhật gần nhất — KHÔNG ghi DB (caller tự lưu nếu cần). */
    public static double currentHealth(Animal a) {
        long last = a.healthAt() != null ? a.healthAt() : a.boughtAt();
        double hrs = (System.currentTimeMillis() - last) / 3_600_000.0;
        if (hrs < 0.05) return a.health();
        if (isHungry(a) || a.health() < 50) {
            return Math.max(0, a.health() - HEALTH_DECAY_PER_HOUR * hrs);
        } else if (a.health() < 100) {
            return Math.min(100, a.health() + HEALTH_REGEN_PER_HOUR * hrs);
        }
        return a.health();
    }

    public static boolean hasProduct(Animal a, AnimalDef def) {
        if (isHungry(a)) return false;
        if (growthPeriod(a, def) < 2) return false;
        long since = Math.max(a.fedAt(), a.collectedAt());
        boolean readyByTime = System.currentTimeMillis() - since > def.produceMin() * 60_000L;
        boolean withinFeedWindow = a.collectedAt() < a.fedAt() + 24 * 3_600_000L;
        return readyByTime && withinFeedWindow;
    }

    private AnimalService() {
    }
}
