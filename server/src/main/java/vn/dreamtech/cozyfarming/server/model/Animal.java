package vn.dreamtech.cozyfarming.server.model;

/** Khớp {@code Animal} trong `src/core/types.ts` (đã đồng bộ giai đoạn lớn + sức khoẻ/bệnh với Lttt thật). */
public record Animal(
        String id,
        String type,
        long boughtAt,
        long fedAt,
        long collectedAt,
        double health,
        boolean sick,
        Long healthAt
) {
}
