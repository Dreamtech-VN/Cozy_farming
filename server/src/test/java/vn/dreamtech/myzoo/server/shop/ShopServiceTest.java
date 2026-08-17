package vn.dreamtech.myzoo.server.shop;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.farm.FarmService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;

import static org.junit.jupiter.api.Assertions.*;

class ShopServiceTest {
    TestSupport.FakeTime time;
    EconomyService economy;
    PlayerService players;
    FarmService farm;
    ShopService shop;
    int playerId;

    @BeforeEach
    void setUp() {
        var db = TestSupport.newDb();
        time = new TestSupport.FakeTime();
        economy = new EconomyService(db, time);
        players = new PlayerService(db, economy, time);
        farm = new FarmService(db, economy, players, time);
        shop = new ShopService(db, economy, players, farm, time);
        playerId = players.guestLogin(null).playerId();
    }

    long vang() { return economy.balances(playerId).get(EconomyService.VANG); }
    long kc() { return economy.balances(playerId).get(EconomyService.KIM_CUONG); }

    @Test
    void buyWithVangAddsToInventory() {
        var result = shop.purchase(playerId, "food_carrot_10", 1);
        assertEquals(700, result.spent());
        assertEquals(300, result.vangBalance());
        assertEquals(1, result.inventory().size());
        assertEquals(1, shop.quantityOf(playerId, "food_carrot_10"));
    }

    @Test
    void buyWithoutEnoughMoneyRejected() {
        assertEquals(402, assertThrows(ApiException.class,
                () -> shop.purchase(playerId, "food_bamboo_5", 1)).status());   // giá 1400 > 1000
        assertEquals(1000, vang());
        assertTrue(shop.inventory(playerId).isEmpty());
    }

    @Test
    void kcItemSpendsOnlyKcNeverVang() {
        shop.topup(playerId, "kc_small");
        long vangBefore = vang();

        shop.purchase(playerId, "grow_boost", 1);
        assertEquals(vangBefore, vang(), "mua bằng KC không được trừ Vàng");
        assertEquals(80, kc());
    }

    @Test
    void everyShopItemHasExactlyOneCurrency() {
        for (var item : ShopCatalog.ITEMS) {
            assertTrue("VANG".equals(item.currency()) || "KC".equals(item.currency()),
                    item.id() + " phải dùng đúng 1 loại tiền");
            assertTrue(item.price() > 0);
        }
    }

    @Test
    void topupAddsKcAndWritesLedger() {
        var result = shop.topup(playerId, "kc_medium");
        assertEquals(550, result.kcAdded());
        assertEquals(550, kc());
        assertEquals(1000, vang(), "nạp KC không đụng tới Vàng");
        assertEquals(404, assertThrows(ApiException.class, () -> shop.topup(playerId, "khong-co")).status());
    }

    @Test
    void useFoodItemFillsFarmStorage() {
        shop.purchase(playerId, "food_carrot_10", 1);
        var result = shop.use(playerId, "food_carrot_10", null);
        assertEquals(10, TestSupport.qty(result.farmStorage(), "carrot"));
        assertEquals(0, shop.quantityOf(playerId, "food_carrot_10"));
        assertEquals(409, assertThrows(ApiException.class,
                () -> shop.use(playerId, "food_carrot_10", null)).status());
    }

    @Test
    void growBoostFinishesPlotImmediately() {
        shop.topup(playerId, "kc_small");
        shop.purchase(playerId, "grow_boost", 1);
        farm.plant(playerId, 0, "wheat");
        assertEquals("GROWING", farm.view(playerId).plots().get(0).state());

        shop.use(playerId, "grow_boost", 0);
        assertEquals("READY", farm.view(playerId).plots().get(0).state());
        assertTrue(farm.harvest(playerId, 0).yield() > 0);
    }

    @Test
    void failedUseRefundsItem() {
        shop.topup(playerId, "kc_small");
        shop.purchase(playerId, "grow_boost", 1);
        // Ô đất trống → dùng thất bại, vật phẩm phải được trả lại
        assertEquals(409, assertThrows(ApiException.class, () -> shop.use(playerId, "grow_boost", 5)).status());
        assertEquals(1, shop.quantityOf(playerId, "grow_boost"));

        assertEquals(400, assertThrows(ApiException.class, () -> shop.use(playerId, "grow_boost", null)).status());
        assertEquals(1, shop.quantityOf(playerId, "grow_boost"));
    }

    @Test
    void invalidPurchaseRejected() {
        assertEquals(404, assertThrows(ApiException.class, () -> shop.purchase(playerId, "khong-co", 1)).status());
        assertEquals(400, assertThrows(ApiException.class, () -> shop.purchase(playerId, "food_carrot_10", 0)).status());
        assertEquals(400, assertThrows(ApiException.class, () -> shop.purchase(playerId, "food_carrot_10", 100)).status());
    }
}
