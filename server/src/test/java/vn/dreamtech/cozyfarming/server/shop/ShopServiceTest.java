package vn.dreamtech.cozyfarming.server.shop;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test định giá + định tuyến kho — khớp {@code storeSlotOf()}/{@code produceSell()} client. */
class ShopServiceTest {
    @Test
    void seedRoutesToSeedsSlotWithBareCropId() {
        var slot = ShopService.resolveSlot("seed_carrot");
        assertEquals("seeds", slot.kind());
        assertEquals("carrot", slot.key());
    }

    @Test
    void fertilizerRoutesToFertSlot() {
        var slot = ShopService.resolveSlot("fertilizer");
        assertEquals("fert", slot.kind());
        assertEquals("fertilizer", slot.key());
    }

    @Test
    void animalProductRoutesToProduceSlot() {
        var slot = ShopService.resolveSlot("egg");
        assertEquals("produce", slot.kind());
        assertEquals("egg", slot.key());
    }

    @Test
    void foodPrefixKeepsFullIdInProduceSlot() {
        var slot = ShopService.resolveSlot("food_cake");
        assertEquals("produce", slot.kind());
        assertEquals("food_cake", slot.key());
    }

    @Test
    void genericBagItemHasNullSlot() {
        assertNull(ShopService.resolveSlot("gift_flower"));
    }

    @Test
    void bareCropIdRoutesToProduceSlot() {
        // không có bên storeSlotOf client (UI kho đã biết sẵn kind từ tab) — API cần tự suy để bán được
        var slot = ShopService.resolveSlot("carrot");
        assertEquals("produce", slot.kind());
        assertEquals("carrot", slot.key());
    }

    @Test
    void fishProductIdRoutesToProduceSlotWithFullId() {
        var slot = ShopService.resolveSlot("fish_ca_ro");
        assertEquals("produce", slot.kind());
        assertEquals("fish_ca_ro", slot.key());
    }

    @Test
    void seedBuyPriceComesFromCropCatalog() {
        assertEquals(10, ShopService.buyPriceOf("seed_carrot").orElseThrow());
    }

    @Test
    void nonPurchasableItemHasEmptyBuyPrice() {
        assertTrue(ShopService.buyPriceOf("egg").isEmpty());
    }

    @Test
    void cropSellPriceComesFromCropCatalog() {
        assertEquals(18, ShopService.sellPriceOf("carrot"));
    }

    @Test
    void fishProductSellPriceIsDoubleFryPrice() {
        // cá rô giá giống 120 -> bán sản phẩm ao được 240
        assertEquals(240, ShopService.sellPriceOf("fish_ca_ro"));
    }

    @Test
    void cookedFoodSellPriceComesFromFoodCatalog() {
        assertEquals(320, ShopService.sellPriceOf("food_salad"));
    }

    @Test
    void boughtFoodCakeIsNotSellableFromKho() {
        // food_cake định tuyến qua FoodCatalog (không có 'cake') chứ không qua ShopCatalog -> 0,
        // khớp đúng quirk thật của client (mua để mở tiệc, không bán lại được)
        assertFalse(ShopService.sellPriceOf("food_cake") > 0);
    }
}
