package vn.dreamtech.myzoo.server.farm;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;

import static org.junit.jupiter.api.Assertions.*;

class FarmServiceTest {
    TestSupport.FakeTime time;
    EconomyService economy;
    PlayerService players;
    FarmService farm;
    int playerId;

    @BeforeEach
    void setUp() {
        var db = TestSupport.newDb();
        time = new TestSupport.FakeTime();
        economy = new EconomyService(db, time);
        players = new PlayerService(db, economy, time);
        farm = new FarmService(db, economy, players, time);
        playerId = players.guestLogin(null).playerId();
    }

    @Test
    void plantSpendsSeedCostAndSetsReadyAt() {
        var result = farm.plant(playerId, 0, "wheat");
        assertEquals(1000 - 100, result.vangBalance());
        assertEquals(time.now + 60_000, result.readyAt());
        assertEquals("GROWING", farm.view(playerId).plots().get(0).state());
    }

    @Test
    void plantOnOccupiedPlotRejected() {
        farm.plant(playerId, 3, "wheat");
        assertEquals(409, assertThrows(ApiException.class, () -> farm.plant(playerId, 3, "carrot")).status());
    }

    @Test
    void plantInvalidPlotOrCropRejected() {
        assertEquals(400, assertThrows(ApiException.class, () -> farm.plant(playerId, -1, "wheat")).status());
        assertEquals(400, assertThrows(ApiException.class, () -> farm.plant(playerId, FarmService.PLOT_COUNT, "wheat")).status());
        assertEquals(404, assertThrows(ApiException.class, () -> farm.plant(playerId, 0, "khong-co")).status());
    }

    @Test
    void harvestBeforeReadyRejected() {
        farm.plant(playerId, 0, "wheat");
        time.advance(59_000);
        assertEquals(409, assertThrows(ApiException.class, () -> farm.harvest(playerId, 0)).status());
    }

    @Test
    void harvestWhenReadyYieldsCropAndXpAndClearsPlot() {
        farm.plant(playerId, 0, "wheat");
        time.advance(60_000);
        var result = farm.harvest(playerId, 0);
        assertTrue(result.yield() >= 2 && result.yield() <= 3);
        assertEquals(5, result.xp());
        assertEquals(result.yield(), TestSupport.qty(farm.storage(playerId), "wheat"));
        assertEquals("EMPTY", farm.view(playerId).plots().get(0).state());
        assertEquals(5, players.profile(playerId).farmXp());
    }

    @Test
    void harvestEmptyPlotRejected() {
        assertEquals(409, assertThrows(ApiException.class, () -> farm.harvest(playerId, 5)).status());
    }

    @Test
    void sellPaysPerUnitAndChecksStock() {
        farm.plant(playerId, 0, "wheat");
        time.advance(60_000);
        int harvested = farm.harvest(playerId, 0).yield();
        var result = farm.sell(playerId, "wheat", harvested);
        assertEquals(55L * harvested, result.vangEarned());
        assertEquals(0, TestSupport.qty(farm.storage(playerId), "wheat"));
        assertEquals(409, assertThrows(ApiException.class, () -> farm.sell(playerId, "wheat", 1)).status());
        assertEquals(400, assertThrows(ApiException.class, () -> farm.sell(playerId, "wheat", 0)).status());
    }

    @Test
    void plantGatedByFarmLevel() {
        assertEquals(403, assertThrows(ApiException.class, () -> farm.plant(playerId, 0, "bamboo")).status());
        players.addFarmXp(playerId, 2000);
        farm.plant(playerId, 0, "bamboo");
    }

    @Test
    void viewShowsReadyStateAfterGrowth() {
        farm.plant(playerId, 7, "grass");
        time.advance(45_000);
        assertEquals("READY", farm.view(playerId).plots().get(7).state());
    }
}
