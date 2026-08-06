package vn.dreamtech.game.server.battle.engine;

import java.util.List;

/** 1 tầng trong chuỗi phản ứng dây chuyền (chain) — {@code level} 1 = khớp ngay sau swap, 2+ = khớp dây chuyền do rơi/tái tạo. */
public record ChainStep(int level, List<Integer> groupSizes) {
    public int tilesCleared() {
        return groupSizes.stream().mapToInt(Integer::intValue).sum();
    }

    public boolean hasCritical(int criticalGroupSize) {
        return groupSizes.stream().anyMatch(size -> size >= criticalGroupSize);
    }
}
