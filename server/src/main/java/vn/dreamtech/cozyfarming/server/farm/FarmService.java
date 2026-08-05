package vn.dreamtech.cozyfarming.server.farm;

import vn.dreamtech.cozyfarming.server.model.FarmPlot;

/**
 * Công thức lớn/khô — chép ĐÚNG {@code growth()}/{@code healthOf()} trong
 * `farming.ts` phía client (đã đồng bộ Lttt thật ở phiên trước): chưa tưới
 * thì cây chỉ lớn tối đa 30%, mỗi giờ bỏ khô mất 8 điểm sức khỏe. KHÔNG áp
 * dụng phần thưởng công cụ (bình tưới/cuốc cấp cao) — hệ công cụ chưa có ở
 * server, để giai đoạn sau khi tủ đồ/công cụ được đưa lên server.
 */
public final class FarmService {
    private static final long HOUR_MS = 3_600_000L;

    public static double growth(FarmPlot p) {
        if (!"planted".equals(p.state()) || p.cropId() == null || p.plantedAt() == null) return 0;
        CropDef c = CropCatalog.find(p.cropId()).orElse(null);
        if (c == null) return 0;
        double totalMs = c.growMin() * 60_000.0;
        if (p.fertilized()) totalMs *= 0.7;
        double t = (System.currentTimeMillis() - p.plantedAt()) / totalMs;
        return p.watered() ? Math.min(t, 1.0) : Math.min(t, 0.3);
    }

    public static int healthOf(FarmPlot p) {
        if (!"planted".equals(p.state()) || p.plantedAt() == null) return 100;
        if (p.watered()) return p.health();
        long since = p.wateredAt() != null ? p.wateredAt() : p.plantedAt();
        double hoursDry = (System.currentTimeMillis() - since) / (double) HOUR_MS;
        return (int) Math.max(10, Math.round(p.health() - hoursDry * 8));
    }

    public static boolean isRipe(FarmPlot p) {
        return "planted".equals(p.state()) && growth(p) >= 1.0;
    }

    private FarmService() {
    }
}
