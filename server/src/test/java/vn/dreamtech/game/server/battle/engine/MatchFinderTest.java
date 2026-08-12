package vn.dreamtech.game.server.battle.engine;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class MatchFinderTest {
    @Test
    void noMatchOnCleanBoard() {
        TileBoard board = new TileBoard(3, 3);
        int[][] rows = {{0, 1, 2}, {1, 2, 0}, {2, 0, 1}};
        for (int r = 0; r < 3; r++) for (int c = 0; c < 3; c++) board.set(r, c, rows[r][c]);
        assertTrue(MatchFinder.find(board).isEmpty());
    }

    @Test
    void horizontalRunOfThreeDetected() {
        TileBoard board = new TileBoard(3, 3);
        board.set(0, 0, 5);
        board.set(0, 1, 5);
        board.set(0, 2, 5);
        board.set(1, 0, 1);
        board.set(1, 1, 2);
        board.set(1, 2, 3);
        board.set(2, 0, 4);
        board.set(2, 1, 1);
        board.set(2, 2, 2);
        var result = MatchFinder.find(board);
        assertEquals(3, result.cleared().size());
        assertEquals(1, result.groupSizes().size());
        assertEquals(3, result.groupSizes().get(0));
    }

    @Test
    void verticalRunOfFourDetected() {
        TileBoard board = new TileBoard(4, 1);
        for (int r = 0; r < 4; r++) board.set(r, 0, 2);
        var result = MatchFinder.find(board);
        assertEquals(4, result.cleared().size());
        assertEquals(4, result.groupSizes().get(0));
    }

    @Test
    void hasAnyValidMoveFalseOnGenuinelyDeadlockedBoard() {
        // Bàn kẹt thật (tìm bằng brute-force, xác nhận không có match sẵn và không swap nào ra match).
        TileBoard board = new TileBoard(4, 4);
        int[][] rows = {
                {0, 2, 1, 0},
                {2, 1, 0, 2},
                {1, 0, 2, 1},
                {0, 2, 1, 0},
        };
        for (int r = 0; r < 4; r++) for (int c = 0; c < 4; c++) board.set(r, c, rows[r][c]);

        assertTrue(MatchFinder.find(board).isEmpty());
        assertFalse(MatchFinder.hasAnyValidMove(board));
    }

    @Test
    void hasAnyValidMoveTrueWhenASwapWouldMatch() {
        TileBoard board = new TileBoard(1, 4);
        board.set(0, 0, 5);
        board.set(0, 1, 5);
        board.set(0, 2, 1);
        board.set(0, 3, 5); // đổi (0,2)<->(0,3) -> 5 5 5 1, ra khớp ngang
        assertTrue(MatchFinder.hasAnyValidMove(board));
    }

    @Test
    void hasAnyValidMoveDoesNotMutateBoard() {
        TileBoard board = new TileBoard(1, 4);
        board.set(0, 0, 5);
        board.set(0, 1, 5);
        board.set(0, 2, 1);
        board.set(0, 3, 5);
        MatchFinder.hasAnyValidMove(board);
        assertEquals(5, board.get(0, 0));
        assertEquals(5, board.get(0, 1));
        assertEquals(1, board.get(0, 2));
        assertEquals(5, board.get(0, 3));
    }
}
