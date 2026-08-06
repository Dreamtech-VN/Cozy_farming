package vn.dreamtech.game.server.level;

import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.model.LevelInfo;

import static org.junit.jupiter.api.Assertions.assertEquals;

class LevelServiceTest {
    @Test
    void expBelowThresholdDoesNotLevelUp() {
        var result = LevelService.addExp(LevelInfo.defaultsFor(1), 50);
        assertEquals(1, result.level());
        assertEquals(50, result.exp());
    }

    @Test
    void exactThresholdLevelsUpWithZeroRemainder() {
        var result = LevelService.addExp(LevelInfo.defaultsFor(1), 100);
        assertEquals(2, result.level());
        assertEquals(0, result.exp());
    }

    @Test
    void overflowCarriesToNextLevel() {
        var result = LevelService.addExp(LevelInfo.defaultsFor(1), 150);
        assertEquals(2, result.level());
        assertEquals(50, result.exp());
    }

    @Test
    void multipleLevelUpsInOneAdd() {
        // level 1 cần 100, level 2 cần 200 -> 350 exp lên tới level 3 dư 50
        var result = LevelService.addExp(LevelInfo.defaultsFor(1), 350);
        assertEquals(3, result.level());
        assertEquals(50, result.exp());
    }
}
