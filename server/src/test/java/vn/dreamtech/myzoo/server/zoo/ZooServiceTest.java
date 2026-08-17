package vn.dreamtech.myzoo.server.zoo;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.farm.FarmService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;

import static org.junit.jupiter.api.Assertions.*;

class ZooServiceTest {
    TestSupport.FakeTime time;
    EconomyService economy;
    PlayerService players;
    FarmService farm;
    ZooService zoo;
    int playerId;

    @BeforeEach
    void setUp() {
        var db = TestSupport.newDb();
        time = new TestSupport.FakeTime();
        economy = new EconomyService(db, time);
        players = new PlayerService(db, economy, time);
        farm = new FarmService(db, economy, players, time);
        zoo = new ZooService(db, economy, farm, players, time);
        playerId = players.guestLogin(null).playerId();
        economy.earn(playerId, EconomyService.VANG, 10_000, "TEST", "t", "0");
        players.addZooXp(playerId, 2000);
        players.addFarmXp(playerId, 2000);
    }

    int buildRabbitHabitat() {
        int habitatId = zoo.buyHabitat(playerId, "meadow").id();
        zoo.buyAnimal(playerId, habitatId, "rabbit");
        return habitatId;
    }

    @Test
    void buyHabitatAndAnimalChargeVang() {
        long before = economy.balances(playerId).get(EconomyService.VANG);
        int habitatId = zoo.buyHabitat(playerId, "meadow").id();
        var afterAnimal = zoo.buyAnimal(playerId, habitatId, "rabbit");
        assertEquals(before - 400 - 500, afterAnimal.vangBalance());
        assertEquals(1, zoo.view(playerId).habitats().get(0).animals().size());
    }

    @Test
    void habitatCapacityEnforced() {
        int habitatId = zoo.buyHabitat(playerId, "grove").id();
        zoo.buyAnimal(playerId, habitatId, "panda");
        economy.earn(playerId, EconomyService.VANG, 20_000, "TEST", "t", "1");
        zoo.buyAnimal(playerId, habitatId, "panda");
        assertEquals(409, assertThrows(ApiException.class,
                () -> zoo.buyAnimal(playerId, habitatId, "panda")).status());
    }

    @Test
    void deliverMovesFoodFromFarmToWarehouse() {
        farm.plant(playerId, 0, "carrot");
        time.advance(90_000);
        int harvested = farm.harvest(playerId, 0).yield();
        var result = zoo.deliver(playerId, "carrot", harvested);
        assertEquals(harvested, result.warehouse().get("carrot"));
        assertNull(result.farmStorage().get("carrot"));
        assertEquals(409, assertThrows(ApiException.class,
                () -> zoo.deliver(playerId, "carrot", harvested + 1)).status());
    }

    @Test
    void feedConsumesDietFoodAndMarksFed() {
        int habitatId = buildRabbitHabitat();
        time.advance(ZooService.FED_WINDOW_MS);
        farm.plant(playerId, 0, "carrot");
        time.advance(90_000);
        farm.harvest(playerId, 0);
        zoo.deliver(playerId, "carrot", 1);
        var result = zoo.feed(playerId, habitatId);
        assertEquals(1, result.animalsFed());
        assertTrue(zoo.view(playerId).habitats().get(0).animals().get(0).fed());
        assertEquals(409, assertThrows(ApiException.class, () -> zoo.feed(playerId, habitatId)).status());
    }

    @Test
    void purchasesGatedByZooLevel() {
        int fresh = players.guestLogin(null).playerId();
        economy.earn(fresh, EconomyService.VANG, 50_000, "TEST", "t", "2");
        assertEquals(403, assertThrows(ApiException.class, () -> zoo.buyHabitat(fresh, "grove")).status());
        int habitatId = zoo.buyHabitat(fresh, "meadow").id();
        assertEquals(403, assertThrows(ApiException.class, () -> zoo.buyAnimal(fresh, habitatId, "panda")).status());
        zoo.buyAnimal(fresh, habitatId, "rabbit");
    }

    @Test
    void openRequiresAnimal() {
        zoo.buyHabitat(playerId, "meadow");
        assertEquals(409, assertThrows(ApiException.class, () -> zoo.open(playerId)).status());
    }

    @Test
    void collectPaysAppealTimesRatePerHourWhileFed() {
        buildRabbitHabitat();
        zoo.open(playerId);
        time.advance(2 * 60 * 60 * 1000L);
        var result = zoo.collect(playerId);
        assertEquals(100, result.vangEarned());
        assertEquals(5, result.zooXp());
    }

    @Test
    void unfedAnimalEarnsNothing() {
        buildRabbitHabitat();
        zoo.open(playerId);
        time.advance(3 * ZooService.FED_WINDOW_MS);
        var result = zoo.collect(playerId);
        assertEquals(0, result.vangEarned());
    }

    @Test
    void accrualCappedAtEightHours() {
        int habitatId = buildRabbitHabitat();
        zoo.open(playerId);
        time.advance(12 * 60 * 60 * 1000L);
        farm.plant(playerId, 0, "carrot");
        time.advance(90_000);
        farm.harvest(playerId, 0);
        zoo.deliver(playerId, "carrot", 1);
        zoo.feed(playerId, habitatId);
        var result = zoo.collect(playerId);
        assertEquals(5 * 10 * 8, result.vangEarned());
    }

    @Test
    void collectWhenClosedRejected() {
        assertEquals(409, assertThrows(ApiException.class, () -> zoo.collect(playerId)).status());
    }

    @Test
    void closeCollectsThenCloses() {
        buildRabbitHabitat();
        zoo.open(playerId);
        time.advance(60 * 60 * 1000L);
        var result = zoo.close(playerId);
        assertEquals(50, result.vangEarned());
        assertFalse(zoo.view(playerId).isOpen());
    }
}
