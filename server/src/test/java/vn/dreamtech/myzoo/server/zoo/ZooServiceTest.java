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
        assertEquals(harvested, TestSupport.qty(result.warehouse(), "carrot"));
        assertEquals(0, TestSupport.qty(result.farmStorage(), "carrot"));
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
    void decorAddsAppealOnlyWhenHabitatHasFedAnimal() {
        int habitatId = zoo.buyHabitat(playerId, "meadow").id();
        zoo.buyDecor(playerId, habitatId, "rock");           // +3 hấp dẫn
        assertEquals(0, zoo.view(playerId).totalAppeal(), "chuồng rỗng thì trang trí chưa tính");

        zoo.buyAnimal(playerId, habitatId, "rabbit");        // thỏ 5 hấp dẫn, mua xong là đã no
        assertEquals(5 + 3, zoo.view(playerId).totalAppeal());
        assertEquals(3, zoo.view(playerId).habitats().get(0).decorAppeal());

        time.advance(ZooService.FED_WINDOW_MS + 1000);       // thú đói -> mất cả bonus trang trí
        assertEquals(0, zoo.view(playerId).totalAppeal());
    }

    @Test
    void decorCannotBeBoughtTwiceAndIsLevelGated() {
        int habitatId = zoo.buyHabitat(playerId, "meadow").id();
        zoo.buyDecor(playerId, habitatId, "rock");
        assertEquals(409, assertThrows(ApiException.class,
                () -> zoo.buyDecor(playerId, habitatId, "rock")).status());
        assertEquals(404, assertThrows(ApiException.class,
                () -> zoo.buyDecor(playerId, habitatId, "khong-co")).status());

        int fresh = players.guestLogin(null).playerId();
        economy.earn(fresh, EconomyService.VANG, 50_000, "TEST", "t", "9");
        int freshHabitat = zoo.buyHabitat(fresh, "meadow").id();
        assertEquals(403, assertThrows(ApiException.class,
                () -> zoo.buyDecor(fresh, freshHabitat, "fountain")).status());
    }

    @Test
    void openRequiresAnimal() {
        zoo.buyHabitat(playerId, "meadow");
        assertEquals(409, assertThrows(ApiException.class, () -> zoo.open(playerId)).status());
    }

    // Doanh thu = (khách × chi tiêu theo hạng − phí vận hành) × số giờ, xem ZooEconomy.
    @Test
    void collectPaysNetProfitPerHourWhileFed() {
        buildRabbitHabitat();
        zoo.open(playerId);
        long netPerHour = zoo.report(playerId).netPerHour();
        assertTrue(netPerHour > 0, "sở thú 1 con thỏ được chăm vẫn phải có lãi");

        time.advance(2 * 60 * 60 * 1000L);
        var result = zoo.collect(playerId);
        assertEquals(netPerHour * 2, result.vangEarned());
        assertEquals(result.vangEarned() / 20, result.zooXp());
    }

    @Test
    void reportExplainsWhereTheMoneyComesFrom() {
        buildRabbitHabitat();
        var report = zoo.report(playerId);
        assertTrue(report.capacity() > 0);
        assertTrue(report.rating() > 0 && report.rating() <= 100);
        assertTrue(report.stars() >= 1.0 && report.stars() <= 5.0);
        assertEquals(report.grossPerHour() - report.maintenancePerHour(), report.netPerHour());
    }

    @Test
    void ratingDropsWhenAnimalsGoHungry() {
        buildRabbitHabitat();
        int fedRating = zoo.report(playerId).rating();
        time.advance(3 * ZooService.FED_WINDOW_MS);
        assertTrue(zoo.report(playerId).rating() < fedRating, "bỏ đói thì hạng tụt");
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
        long netPerHour = zoo.report(playerId).netPerHour();
        var result = zoo.collect(playerId);
        assertEquals(netPerHour * 8, result.vangEarned(), "dồn tối đa 8 giờ");
    }

    @Test
    void collectWhenClosedRejected() {
        assertEquals(409, assertThrows(ApiException.class, () -> zoo.collect(playerId)).status());
    }

    @Test
    void closeCollectsThenCloses() {
        buildRabbitHabitat();
        zoo.open(playerId);
        long netPerHour = zoo.report(playerId).netPerHour();
        time.advance(60 * 60 * 1000L);
        var result = zoo.close(playerId);
        assertEquals(netPerHour, result.vangEarned());
        assertFalse(zoo.view(playerId).isOpen());
    }

    // ---------- Chợ thức ăn khẩn cấp (spec §29.23) ----------
    @Test
    void emergencyFoodIsDeliberatelyMoreExpensiveThanFarming() {
        for (var item : zoo.market()) {
            long farmPrice = vn.dreamtech.myzoo.server.catalog.Catalog.sellPrice(item.foodId()).orElseThrow();
            assertTrue(item.price() > farmPrice,
                    item.foodId() + " phải đắt hơn tự trồng, không thì nông trại mất ý nghĩa");
        }
        assertFalse(zoo.market().isEmpty());
    }

    @Test
    void marketOnlySellsWhatAnimalsActuallyEat() {
        for (var item : zoo.market()) {
            assertTrue(vn.dreamtech.myzoo.server.catalog.Catalog.SPECIES.stream()
                            .anyMatch(s -> s.diet().contains(item.foodId())),
                    item.foodId() + " không con thú nào ăn, bán làm gì");
        }
        assertTrue(zoo.market().stream().noneMatch(m -> m.foodId().equals("flour")), "không bán thành phẩm");
    }

    @Test
    void buyingEmergencyFoodFillsZooWarehouse() {
        long before = economy.balances(playerId).get(EconomyService.VANG);
        var result = zoo.buyEmergencyFood(playerId, "carrot", 5);

        assertEquals(ZooService.emergencyPrice("carrot") * 5, result.spent());
        assertEquals(before - result.spent(), result.vangBalance());
        assertEquals(5, TestSupport.qty(result.warehouse(), "carrot"));
    }

    @Test
    void emergencyMarketRejectsBadInput() {
        assertEquals(404, assertThrows(ApiException.class,
                () -> zoo.buyEmergencyFood(playerId, "flour", 1)).status(), "không bán thành phẩm");
        assertEquals(404, assertThrows(ApiException.class,
                () -> zoo.buyEmergencyFood(playerId, "khong-co", 1)).status());
        assertEquals(400, assertThrows(ApiException.class,
                () -> zoo.buyEmergencyFood(playerId, "carrot", 0)).status());
        assertEquals(400, assertThrows(ApiException.class,
                () -> zoo.buyEmergencyFood(playerId, "carrot", ZooService.EMERGENCY_MAX_QUANTITY + 1)).status());
    }

    @Test
    void cannotBuyEmergencyFoodWithoutGold() {
        long balance = economy.balances(playerId).get(EconomyService.VANG);
        economy.spend(playerId, EconomyService.VANG, balance, "TEST", null, null);
        assertEquals(402, assertThrows(ApiException.class,
                () -> zoo.buyEmergencyFood(playerId, "carrot", 1)).status());
    }
}
