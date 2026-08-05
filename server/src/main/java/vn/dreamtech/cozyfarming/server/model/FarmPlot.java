package vn.dreamtech.cozyfarming.server.model;

/**
 * Khớp {@code Plot} phía client (`src/core/types.ts`). {@code state}:
 * locked | empty | tilled | planted. Field mốc thời gian lưu dạng epoch-ms
 * (giống client) để tính lớn/khô cùng công thức {@code growth()}/{@code
 * healthOf()} trong `farming.ts`.
 */
public record FarmPlot(
        int index,
        String state,
        String cropId,
        Long plantedAt,
        boolean watered,
        Long wateredAt,
        boolean fertilized,
        int health
) {
    public static FarmPlot empty(int index) {
        return new FarmPlot(index, "empty", null, null, false, null, false, 100);
    }
}
