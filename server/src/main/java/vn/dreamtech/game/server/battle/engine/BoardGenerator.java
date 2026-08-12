package vn.dreamtech.game.server.battle.engine;

import java.util.Random;

/**
 * Sinh bàn cờ ban đầu KHÔNG có sẵn hàng/cột 3 trùng màu (tránh ăn điểm miễn
 * phí ngay lúc bắt đầu), đồng thời đảm bảo LUÔN có ít nhất 1 nước đi hợp lệ
 * (tránh bàn cờ kẹt/deadlock ngay từ đầu trận).
 */
public final class BoardGenerator {
    private static final int MAX_SHUFFLE_ATTEMPTS = 200;

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
        ensurePlayable(board, colorCount, random);
        return board;
    }

    /**
     * Nếu {@code board} không còn nước đi hợp lệ nào (deadlock), xáo lại tới
     * khi chơi được tiếp — dùng cả lúc vừa sinh bàn lẫn giữa trận sau khi
     * cascade làm board đổi hẳn tổ hợp màu.
     */
    public static void ensurePlayable(TileBoard board, int colorCount, Random random) {
        if (MatchFinder.hasAnyValidMove(board)) return;
        for (int attempt = 0; attempt < MAX_SHUFFLE_ATTEMPTS; attempt++) {
            board.shuffle(random);
            if (MatchFinder.find(board).isEmpty() && MatchFinder.hasAnyValidMove(board)) {
                return;
            }
        }
        // Cực hiếm xáo hoài không ra bàn hợp lệ -> sinh bàn mới hoàn toàn thay vì kẹt vô thời hạn.
        TileBoard fresh = generate(board.rows(), board.cols(), colorCount, random);
        for (int r = 0; r < board.rows(); r++) {
            for (int c = 0; c < board.cols(); c++) {
                board.set(r, c, fresh.get(r, c));
            }
        }
    }

    private static boolean createsImmediateRun(TileBoard board, int r, int c, int color) {
        if (c >= 2 && board.get(r, c - 1) == color && board.get(r, c - 2) == color) return true;
        return r >= 2 && board.get(r - 1, c) == color && board.get(r - 2, c) == color;
    }

    private BoardGenerator() {
    }
}
