package vn.dreamtech.myzoo.server.farm;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.catalog.Catalog;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;

class LivestockServiceTest {
    DataSource db;
    TestSupport.FakeTime time;
    EconomyService economy;
    PlayerService players;
    FarmService farm;
    LivestockService barn;
    int an;

    static final Catalog.LivestockDef CHICKEN = Catalog.livestock("chicken").orElseThrow();

    @BeforeEach
    void setUp() {
        db = TestSupport.newDb();
        time = new TestSupport.FakeTime();
        economy = new EconomyService(db, time);
        players = new PlayerService(db, economy, time);
        farm = new FarmService(db, economy, players, time);
        barn = new LivestockService(db, economy, players, farm, time);
        an = players.guestLogin(null).playerId();
        players.createCharacter(an, "An", "farmer_1");
        economy.earn(an, EconomyService.VANG, 50_000, "TEST", null, null);
    }

    void stock(String foodId, int qty) {
        try (Connection c = db.getConnection()) {
            FarmService.addToInventory(c, "farm_inventory", an, foodId, qty);
        } catch (SQLException e) {
            fail("không nạp được kho: " + e.getMessage());
        }
    }

    // ---------- Mua ----------
    @Test
    void buyDeductsGoldAndAddsAnimal() {
        long before = economy.balances(an).get(EconomyService.VANG);
        var result = barn.buy(an, "chicken");
        assertEquals(before - CHICKEN.cost(), result.vangBalance());
        assertEquals(1, result.animals().size());
        assertEquals(LivestockService.HUNGRY, result.animals().get(0).state(), "mua về là đang đói");
    }

    @Test
    void buyRejectsUnknownSpeciesAndLevelGate() {
        assertEquals(404, assertThrows(ApiException.class, () -> barn.buy(an, "khung-long")).status());
        // Heo cần Nông trại cấp 5, người mới chỉ cấp 1.
        assertEquals(403, assertThrows(ApiException.class, () -> barn.buy(an, "pig")).status());
    }

    @Test
    void barnHasCapacity() {
        for (int i = 0; i < LivestockService.MAX_ANIMALS; i++) barn.buy(an, "chicken");
        assertEquals(409, assertThrows(ApiException.class, () -> barn.buy(an, "chicken")).status());
    }

    // ---------- Cho ăn ----------
    @Test
    void feedConsumesFoodAndStartsTimer() {
        barn.buy(an, "chicken");
        stock(CHICKEN.foodId(), 5);

        var result = barn.feedAll(an);
        assertEquals(1, result.fedCount());
        assertEquals(5 - CHICKEN.foodQty(), TestSupport.qty(result.storage(), CHICKEN.foodId()));

        var animal = result.animals().get(0);
        assertEquals(LivestockService.GROWING, animal.state());
        assertEquals(time.now() + CHICKEN.productSeconds() * 1000L, animal.readyAt());
    }

    @Test
    void feedRejectedWhenNothingHungryOrNoFood() {
        barn.buy(an, "chicken");
        assertEquals(409, assertThrows(ApiException.class, () -> barn.feedAll(an)).status(), "kho rỗng");

        stock(CHICKEN.foodId(), 5);
        barn.feedAll(an);
        assertEquals(409, assertThrows(ApiException.class, () -> barn.feedAll(an)).status(),
                "đang no thì không cho ăn lại");
    }

    @Test
    void feedAllSkipsAnimalsWhoseFoodIsMissing() {
        barn.buy(an, "chicken");
        players.addFarmXp(an, 10_000);   // lên cấp để mua được vịt
        barn.buy(an, "duck");
        stock(CHICKEN.foodId(), 5);      // chỉ có thức ăn của gà

        var result = barn.feedAll(an);
        assertEquals(1, result.fedCount(), "chỉ con nào đủ thức ăn mới được ăn");
        assertEquals(LivestockService.GROWING, result.animals().get(0).state());
        assertEquals(LivestockService.HUNGRY, result.animals().get(1).state());
    }

    // ---------- Thu sản phẩm ----------
    @Test
    void productReadyOnlyAfterTimeAndGoesToFarmStorage() {
        long id = barn.buy(an, "chicken").id();
        stock(CHICKEN.foodId(), 5);
        barn.feedAll(an);

        assertEquals(409, assertThrows(ApiException.class, () -> barn.collect(an, id)).status(), "chưa tới giờ");

        time.advance(CHICKEN.productSeconds() * 1000L);
        assertEquals(LivestockService.READY, barn.animals(an).get(0).state());

        var result = barn.collect(an, id);
        assertEquals(CHICKEN.productId(), result.productId());
        assertEquals(CHICKEN.productQty(), result.quantity());
        assertEquals(CHICKEN.productQty(), TestSupport.qty(result.storage(), CHICKEN.productId()));
        assertEquals(LivestockService.HUNGRY, result.animals().get(0).state(), "thu xong phải cho ăn lại");
    }

    @Test
    void cannotCollectTwice() {
        long id = barn.buy(an, "chicken").id();
        stock(CHICKEN.foodId(), 5);
        barn.feedAll(an);
        time.advance(CHICKEN.productSeconds() * 1000L);

        barn.collect(an, id);
        assertEquals(409, assertThrows(ApiException.class, () -> barn.collect(an, id)).status());
    }

    @Test
    void cannotCollectSomeoneElsesAnimal() {
        long id = barn.buy(an, "chicken").id();
        int binh = players.guestLogin(null).playerId();
        players.createCharacter(binh, "Bình", "farmer_2");
        assertEquals(404, assertThrows(ApiException.class, () -> barn.collect(binh, id)).status());
        assertEquals(404, assertThrows(ApiException.class, () -> barn.collect(an, 99999)).status());
    }

    // Sản phẩm chỉ tính khi tới hạn, không cần tiến trình nền nào chạy (spec §6.4).
    @Test
    void offlineTimePassesWithoutAnyBackgroundJob() {
        long id = barn.buy(an, "chicken").id();
        stock(CHICKEN.foodId(), 5);
        barn.feedAll(an);

        time.advance(7L * 24 * 60 * 60 * 1000);   // tắt game một tuần
        assertEquals(LivestockService.READY, barn.animals(an).get(0).state());
        assertEquals(CHICKEN.productQty(), barn.collect(an, id).quantity(),
                "nghỉ lâu cũng chỉ nhận đúng một lứa, không dồn vô hạn");
    }

    // ---------- Nối vào chế biến ----------
    @Test
    void livestockProductsFeedTheProcessingRecipes() {
        assertTrue(vn.dreamtech.myzoo.server.processing.ProcessingService.RECIPES.stream()
                        .anyMatch(r -> r.inputFoodId().equals("milk") && r.outputFoodId().equals("cheese")),
                "Sữa phải làm được Phô mai");
        assertTrue(vn.dreamtech.myzoo.server.processing.ProcessingService.RECIPES.stream()
                        .anyMatch(r -> r.inputFoodId().equals("egg") && r.outputFoodId().equals("cake")),
                "Trứng phải làm được Bánh kem");
        // Mọi sản phẩm chăn nuôi đều bán được, không có món nào kẹt trong kho.
        for (var def : Catalog.LIVESTOCK) {
            assertTrue(Catalog.sellPrice(def.productId()).orElse(0L) > 0,
                    def.productId() + " chưa có giá bán");
        }
    }
}
