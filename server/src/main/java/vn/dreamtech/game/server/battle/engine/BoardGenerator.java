package vn.dreamtech.game.server.battle.engine;

import java.util.Random;

/** Sinh bàn cờ ban đầu KHÔNG có sẵn hàng/cột 3 trùng màu (tránh ăn điểm miễn phí ngay lúc bắt đầu). */
public final class BoardGenerator {
    public static TileBoard generate(int rows, int cols, int colorCount, Random random) {
        TileBoard board = new TileBoard(rows, cols);
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                int color;
                do {
                    color = random.nextInt(colorCount);
                } while (createsImmediateRun(board, r, c, color));
                board.set(r, c, color);
            }
        }
        return board;
    }

    private static boolean createsImmediateRun(TileBoard board, int r, int c, int color) {
        if (c >= 2 && board.get(r, c - 1) == color && board.get(r, c - 2) == color) return true;
        return r >= 2 && board.get(r - 1, c) == color && board.get(r - 2, c) == color;
    }

    private BoardGenerator() {
    }
}
