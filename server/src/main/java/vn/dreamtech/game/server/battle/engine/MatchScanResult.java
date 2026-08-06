package vn.dreamtech.game.server.battle.engine;

import java.util.List;
import java.util.Set;

/**
 * Kết quả quét khớp trên 1 bàn cờ: {@code cleared} là tập ô sẽ bị xoá (đã
 * gộp trùng), {@code groupSizes} là độ dài từng hàng/cột thẳng nối tiếp
 * cùng màu (>=3) — dùng để tính thưởng sát thương, KHÔNG dùng để xoá ô
 * (1 ô hình chữ L/T có thể xuất hiện trong 2 group cùng lúc, đã cố ý đơn
 * giản hoá thay vì gộp thành shape).
 */
public record MatchScanResult(Set<Position> cleared, List<Integer> groupSizes) {
    public boolean isEmpty() {
        return cleared.isEmpty();
    }
}
