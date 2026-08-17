package vn.dreamtech.myzoo.server.processing;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.catalog.Catalog;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.farm.FarmService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;

import javax.sql.DataSource;
import java.sql.Connection;

import static org.junit.jupiter.api.Assertions.*;

class ProcessingServiceTest {
    DataSource db;
    TestSupport.FakeTime time;
    EconomyService economy;
    PlayerService players;
    FarmService farm;
    ProcessingService processing;
    int playerId;

    @BeforeEach
    void setUp() {
        db = TestSupport.newDb();
        time = new TestSupport.FakeTime();
        economy = new EconomyService(db, time);
        players = new PlayerService(db, economy, time);
        farm = new FarmService(db, economy, players, time);
        processing = new ProcessingService(db, players, farm, time);
        playerId = players.guestLogin(null).playerId();
        players.addFarmXp(playerId, 2000);   // mở khoá mọi công thức
        addWheat(12);
    }

    void addWheat(int delta) {
        try (Connection c = db.getConnection()) {
            FarmService.addToInventory(c, "farm_inventory", playerId, "wheat", delta);
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }

    @Test
    void startConsumesInputAndFinishesAfterTime() {
        var recipe = ProcessingService.recipe("flour").orElseThrow();
        var start = processing.start(playerId, "flour");
        assertEquals(12 - recipe.inputQty(), TestSupport.qty(start.storage(), "wheat"));
        assertFalse(processing.view(playerId).slots().get(0).ready());

        assertEquals(409, assertThrows(ApiException.class,
                () -> processing.collect(playerId, start.slotId())).status());

        time.advance(recipe.seconds() * 1000L);
        assertTrue(processing.view(playerId).slots().get(0).ready());

        var collected = processing.collect(playerId, start.slotId());
        assertEquals("flour", collected.outputFoodId());
        assertEquals(1, TestSupport.qty(collected.storage(), "flour"));
        assertTrue(processing.view(playerId).slots().isEmpty());
    }

    @Test
    void collectTwiceRejected() {
        var start = processing.start(playerId, "flour");
        time.advance(200_000);
        processing.collect(playerId, start.slotId());
        assertEquals(404, assertThrows(ApiException.class,
                () -> processing.collect(playerId, start.slotId())).status());
    }

    @Test
    void notEnoughInputRejectedAndNothingStarted() {
        addWheat(-11);   // còn 1, công thức cần 3
        assertEquals(409, assertThrows(ApiException.class, () -> processing.start(playerId, "flour")).status());
        assertTrue(processing.view(playerId).slots().isEmpty());
        assertEquals(1, TestSupport.qty(farm.storage(playerId), "wheat"), "thất bại không được nuốt nguyên liệu");
    }

    @Test
    void slotLimitEnforced() {
        addWheat(20);
        for (int i = 0; i < ProcessingService.MAX_SLOTS; i++) processing.start(playerId, "flour");
        assertEquals(409, assertThrows(ApiException.class, () -> processing.start(playerId, "flour")).status());
    }

    @Test
    void recipeGatedByFarmLevel() {
        int fresh = players.guestLogin(null).playerId();
        assertEquals(403, assertThrows(ApiException.class, () -> processing.start(fresh, "berry_jam")).status());
        assertEquals(404, assertThrows(ApiException.class, () -> processing.start(playerId, "khong-co")).status());
    }

    @Test
    void productSellsHigherThanItsInputs() {
        for (var recipe : ProcessingService.RECIPES) {
            long inputValue = Catalog.sellPrice(recipe.inputFoodId()).orElseThrow() * recipe.inputQty();
            long outputValue = Catalog.sellPrice(recipe.outputFoodId()).orElseThrow() * recipe.outputQty();
            assertTrue(outputValue > inputValue, recipe.id() + ": thành phẩm phải đáng giá hơn nguyên liệu");
        }
    }

    @Test
    void productCanBeSold() {
        var start = processing.start(playerId, "flour");
        time.advance(200_000);
        processing.collect(playerId, start.slotId());
        long before = economy.balances(playerId).get(EconomyService.VANG);
        var sold = farm.sell(playerId, "flour", 1);
        assertEquals(220, sold.vangEarned());
        assertEquals(before + 220, sold.vangBalance());
    }
}
