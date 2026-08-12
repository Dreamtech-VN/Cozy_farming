package vn.dreamtech.game.server.battle.engine;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/** Dò các hàng/cột có 3 ô liên tiếp cùng màu trở lên. */
public final class MatchFinder {
    private static final int MIN_RUN = 3;

    public static MatchScanResult find(TileBoard board) {
        Set<Position> cleared = new LinkedHashSet<>();
        List<Integer> groupSizes = new ArrayList<>();

        for (int r = 0; r < board.rows(); r++) {
            int runStart = 0;
            for (int c = 1; c <= board.cols(); c++) {
                boolean sameAsPrev = c < board.cols() && board.get(r, c) == board.get(r, c - 1);
                if (!sameAsPrev) {
                    int runLen = c - runStart;
                    if (runLen >= MIN_RUN) {
                        groupSizes.add(runLen);
                        for (int cc = runStart; cc < c; cc++) cleared.add(new Position(r, cc));
                    }
                    runStart = c;
                }
            }
        }

        for (int c = 0; c < board.cols(); c++) {
            int runStart = 0;
            for (int r = 1; r <= board.rows(); r++) {
                boolean sameAsPrev = r < board.rows() && board.get(r, c) == board.get(r - 1, c);
                if (!sameAsPrev) {
                    int runLen = r - runStart;
                    if (runLen >= MIN_RUN) {
                        groupSizes.add(runLen);
                        for (int rr = runStart; rr < r; rr++) cleared.add(new Position(rr, c));
                    }
                    runStart = r;
                }
            }
        }

        return new MatchScanResult(cleared, groupSizes);
    }

    /** Có ít nhất 1 cặp ô liền kề đổi chỗ cho nhau là ra khớp không — dùng để phát hiện bàn cờ bị kẹt (deadlock). */
    public static boolean hasAnyValidMove(TileBoard board) {
        for (int r = 0; r < board.rows(); r++) {
            for (int c = 0; c < board.cols(); c++) {
                if (c + 1 < board.cols() && wouldMatchAfterSwap(board, r, c, r, c + 1)) return true;
                if (r + 1 < board.rows() && wouldMatchAfterSwap(board, r, c, r + 1, c)) return true;
            }
        }
        return false;
    }

    private static boolean wouldMatchAfterSwap(TileBoard board, int r1, int c1, int r2, int c2) {
        board.swapCells(r1, c1, r2, c2);
        boolean matches = !find(board).isEmpty();
        board.swapCells(r1, c1, r2, c2);
        return matches;
    }

    private MatchFinder() {
    }
}
