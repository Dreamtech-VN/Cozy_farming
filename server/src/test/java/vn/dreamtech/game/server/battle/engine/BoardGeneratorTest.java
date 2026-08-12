package vn.dreamtech.game.server.battle.engine;

import org.junit.jupiter.api.RepeatedTest;
import org.junit.jupiter.api.Test;

import java.util.Random;

import static org.junit.jupiter.api.Assertions.assertTrue;

class BoardGeneratorTest {
    @RepeatedTest(20)
    void generatedBoardHasNoPreexistingMatches() {
        TileBoard board = BoardGenerator.generate(8, 8, 6, new Random());
        assertTrue(MatchFinder.find(board).isEmpty());
    }

    @RepeatedTest(20)
    void generatedBoardAlwaysHasAtLeastOneValidMove() {
        TileBoard board = BoardGenerator.generate(8, 8, 6, new Random());
        assertTrue(MatchFinder.hasAnyValidMove(board));
    }

    @Test
    void ensurePlayableReshufflesADeadlockedBoardUntilPlayable() {
        TileBoard board = new TileBoard(4, 4);
        int[][] rows = {
                {0, 2, 1, 0},
                {2, 1, 0, 2},
                {1, 0, 2, 1},
                {0, 2, 1, 0},
        };
        for (int r = 0; r < 4; r++) for (int c = 0; c < 4; c++) board.set(r, c, rows[r][c]);
        assertTrue(MatchFinder.find(board).isEmpty());
        assertTrue(!MatchFinder.hasAnyValidMove(board), "fixture phải là bàn kẹt trước khi ensurePlayable");

        BoardGenerator.ensurePlayable(board, 3, new Random(1));

        assertTrue(MatchFinder.find(board).isEmpty());
        assertTrue(MatchFinder.hasAnyValidMove(board));
    }

    @Test
    void ensurePlayableIsNoopWhenBoardAlreadyPlayable() {
        TileBoard board = BoardGenerator.generate(8, 8, 6, new Random(42));
        int[][] before = board.toArray();

        BoardGenerator.ensurePlayable(board, 6, new Random(42));

        int[][] after = board.toArray();
        for (int r = 0; r < 8; r++) {
            for (int c = 0; c < 8; c++) {
                assertTrue(before[r][c] == after[r][c]);
            }
        }
    }
}
