package vn.dreamtech.game.server.battle.engine;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * Xử lý lặp: dò khớp -> xoá -> rơi -> lấp đầy -> dò lại, cho tới khi không
 * còn khớp nào (mỗi vòng lặp là 1 tầng "chain"). Sửa {@code board} tại chỗ.
 */
public final class CascadeResolver {
    private static final int MAX_CHAIN_LEVELS = 30; // chặn an toàn, tránh vòng lặp vô hạn về lý thuyết

    public static CascadeResult resolve(TileBoard board, Random random, int colorCount) {
        List<ChainStep> steps = new ArrayList<>();
        int level = 1;
        while (level <= MAX_CHAIN_LEVELS) {
            MatchScanResult found = MatchFinder.find(board);
            if (found.isEmpty()) break;
            steps.add(new ChainStep(level, found.groupSizes()));
            for (Position p : found.cleared()) {
                board.set(p.row(), p.col(), TileBoard.EMPTY);
            }
            board.applyGravity();
            board.refill(random, colorCount);
            level++;
        }
        return new CascadeResult(steps);
    }

    private CascadeResolver() {
    }
}
