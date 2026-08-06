package vn.dreamtech.game.server.battle.engine;

import org.junit.jupiter.api.RepeatedTest;

import java.util.Random;

import static org.junit.jupiter.api.Assertions.assertTrue;

class BoardGeneratorTest {
    @RepeatedTest(20)
    void generatedBoardHasNoPreexistingMatches() {
        TileBoard board = BoardGenerator.generate(8, 8, 6, new Random());
        assertTrue(MatchFinder.find(board).isEmpty());
    }
}
