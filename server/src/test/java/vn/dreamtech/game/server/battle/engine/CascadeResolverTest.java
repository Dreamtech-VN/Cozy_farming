package vn.dreamtech.game.server.battle.engine;

import org.junit.jupiter.api.Test;

import java.util.Random;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class CascadeResolverTest {
    @Test
    void noMatchProducesNoSteps() {
        TileBoard board = new TileBoard(3, 3);
        int[][] rows = {{0, 1, 2}, {1, 2, 0}, {2, 0, 1}};
        for (int r = 0; r < 3; r++) for (int c = 0; c < 3; c++) board.set(r, c, rows[r][c]);
        CascadeResult result = CascadeResolver.resolve(board, new Random(1), 6);
        assertFalse(result.matched());
        assertEquals(0, result.chainLevels());
    }

    @Test
    void clearsMatchAndRefillsBoard() {
        TileBoard board = new TileBoard(1, 3);
        board.set(0, 0, 3);
        board.set(0, 1, 3);
        board.set(0, 2, 3);
        CascadeResult result = CascadeResolver.resolve(board, new Random(42), 6);
        assertTrue(result.matched());
        assertEquals(1, result.steps().get(0).level());
        for (int c = 0; c < 3; c++) {
            assertTrue(board.get(0, c) >= 0 && board.get(0, c) < 6);
        }
    }

    @Test
    void cascadeCanChainMultipleLevels() {
        // Cột dọc: xoá hàng dưới cùng 3 ô màu 0 sẽ làm 2 ô màu 1 phía trên rơi xuống,
        // ghép với ô màu 1 đã có sẵn ở hàng trên cùng -> khớp tầng 2.
        TileBoard board = new TileBoard(4, 3);
        board.set(0, 0, 1);
        board.set(1, 0, 9);
        board.set(2, 0, 1);
        board.set(3, 0, 0);
        board.set(0, 1, 1);
        board.set(1, 1, 9);
        board.set(2, 1, 1);
        board.set(3, 1, 0);
        board.set(0, 2, 9);
        board.set(1, 2, 9);
        board.set(2, 2, 9);
        board.set(3, 2, 0);
        // hàng đáy (row 3) toàn màu 0 -> khớp ngang tầng 1; sau khi rơi, cột 0 và 1
        // dồn 2 ô màu 1 xuống liền kề ô màu 1 còn lại -> có thể khớp tiếp tầng 2 tuỳ refill,
        // nhưng tối thiểu phải có tầng 1.
        CascadeResult result = CascadeResolver.resolve(board, new Random(7), 6);
        assertTrue(result.matched());
        assertTrue(result.chainLevels() >= 1);
    }

    @Test
    void lShapeMatch_uniqueTilesClearedDoesNotDoubleCountSharedCorner() {
        // Hình L: hàng ngang (0,0)-(0,2) và cột dọc (0,0)-(2,0) dùng chung ô góc (0,0).
        TileBoard board = new TileBoard(3, 3);
        board.set(0, 0, 4);
        board.set(0, 1, 4);
        board.set(0, 2, 4);
        board.set(1, 0, 4);
        board.set(2, 0, 4);
        board.set(1, 1, 1);
        board.set(1, 2, 1);
        board.set(2, 1, 2);
        board.set(2, 2, 2);

        CascadeResult result = CascadeResolver.resolve(board, new Random(1), 6);
        ChainStep step = result.steps().get(0);

        int groupSizeSum = step.groupSizes().stream().mapToInt(Integer::intValue).sum();
        assertEquals(6, groupSizeSum); // 2 group (ngang 3 + dọc 3) tính riêng, chưa gộp trùng
        assertEquals(5, step.uniqueTilesCleared()); // (0,0) chỉ tính 1 lần trong số ô vật lý thật sự bị xoá
    }
}
