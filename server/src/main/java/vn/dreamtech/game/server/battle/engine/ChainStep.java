package vn.dreamtech.game.server.battle.engine;

import java.util.List;

/**
 * 1 tầng trong chuỗi phản ứng dây chuyền (chain) — {@code level} 1 = khớp
 * ngay sau swap, 2+ = khớp dây chuyền do rơi/tái tạo. {@code groupSizes} có
 * thể đếm 1 ô hình L/T ở 2 group cùng lúc (xem {@link MatchScanResult}) —
 * {@code uniqueTilesCleared} là số ô vật lý thật sự bị xoá, không trùng lặp.
 */
public record ChainStep(int level, List<Integer> groupSizes, int uniqueTilesCleared) {
    public boolean hasCritical(int criticalGroupSize) {
        return groupSizes.stream().anyMatch(size -> size >= criticalGroupSize);
    }
}
