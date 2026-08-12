package vn.dreamtech.game.server.battle.engine;

import org.junit.jupiter.api.Test;

import java.util.Arrays;
import java.util.Random;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;

class TileBoardTest {
    @Test
    void shufflePreservesTileCounts() {
        TileBoard board = new TileBoard(4, 4);
        int value = 0;
        for (int r = 0; r < 4; r++) {
            for (int c = 0; c < 4; c++) {
                board.set(r, c, value % 4);
                value++;
            }
        }

        int[] before = flatten(board);
        board.shuffle(new Random(7));
        int[] after = flatten(board);

        Arrays.sort(before);
        Arrays.sort(after);
        assertArrayEquals(before, after);
    }

    @Test
    void shuffleChangesArrangement() {
        TileBoard board = new TileBoard(4, 4);
        int value = 0;
        for (int r = 0; r < 4; r++) {
            for (int c = 0; c < 4; c++) {
                board.set(r, c, value % 4);
                value++;
            }
        }

        int[] before = flatten(board);
        board.shuffle(new Random(7));
        int[] after = flatten(board);

        assertFalse(Arrays.equals(before, after));
    }

    private static int[] flatten(TileBoard board) {
        int[] out = new int[board.rows() * board.cols()];
        int i = 0;
        for (int r = 0; r < board.rows(); r++) {
            for (int c = 0; c < board.cols(); c++) {
                out[i++] = board.get(r, c);
            }
        }
        return out;
    }
}
