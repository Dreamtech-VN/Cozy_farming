package vn.dreamtech.cozyfarming.server.shop;

import vn.dreamtech.cozyfarming.server.farm.CropCatalog;

import java.util.Optional;
import java.util.Set;

/**
 * Định giá + định tuyến kho, chép ĐÚNG {@code storeSlotOf()}
 * ({@code src/core/save.ts}) và {@code produceSell()} ({@code src/ui/panels.ts}).
 * KHÔNG được tự đổi thứ tự ưu tiên các nhánh dưới — thứ tự y hệt client.
 */
public final class ShopService {
    // khớp PRODUCE_IDS trong save.ts — sản phẩm vật nuôi cất chung ngăn "produce"
    private static final Set<String> PRODUCE_IDS = Set.of("egg", "milk", "meat", "pork", "wool", "honey", "cheese", "bread");

    public record StoreSlot(String kind, String key) {
    }

    /**
     * null nghĩa là túi đồ (bag_items). 5 nhánh đầu khớp ĐÚNG
     * {@code storeSlotOf()} client. 2 nhánh cuối (crop bare id, {@code
     * fish_}) KHÔNG có bên client — client biết sẵn "kind" từ tab kho đang mở
     * (xem {@code sellOf()} trong panel kho, gọi thẳng {@code takeFrom(kind, id, 1)}
     * chứ không qua {@code storeSlotOf}) nên không cần tự suy luận. API ở
     * đây chỉ nhận 1 itemId nên phải tự suy thêm 2 nhánh này để bán được
     * nông sản/cá ao — không đổi luật chơi, chỉ bù cho việc thiếu ngữ cảnh
     * "đang ở tab nào" mà request HTTP không có.
     */
    public static StoreSlot resolveSlot(String itemId) {
        if (itemId.startsWith("seed_")) return new StoreSlot("seeds", itemId.substring(5));
        if (itemId.startsWith("crop_")) return new StoreSlot("produce", itemId.substring(5));
        if (itemId.startsWith("food_")) return new StoreSlot("produce", itemId);
        if (itemId.equals("fertilizer")) return new StoreSlot("fert", "fertilizer");
        if (PRODUCE_IDS.contains(itemId)) return new StoreSlot("produce", itemId);
        if (itemId.startsWith("fish_")) return new StoreSlot("produce", itemId);
        if (CropCatalog.find(itemId).isPresent()) return new StoreSlot("produce", itemId);
        return null;
    }

    /** Giá mua, rỗng nếu không mua được (khớp thiếu field {@code buy} bên client). */
    public static Optional<Integer> buyPriceOf(String itemId) {
        if (itemId.startsWith("seed_")) {
            return CropCatalog.find(itemId.substring(5)).map(c -> c.seedPrice());
        }
        return ShopCatalog.find(itemId)
                .filter(def -> def.buyPrice() >= 0)
                .map(ShopItemDef::buyPrice);
    }

    /** Giá bán, khớp {@code produceSell()} — 0 nếu không bán được. */
    public static int sellPriceOf(String itemId) {
        if (itemId.startsWith("food_")) {
            return FoodCatalog.sellPriceOf(itemId.substring(5)).orElse(0);
        }
        if (itemId.startsWith("fish_")) {
            return vn.dreamtech.cozyfarming.server.fishpond.FryCatalog.find(itemId.substring(5))
                    .map(f -> f.price() * 2).orElse(0);
        }
        Optional<Integer> cropSell = CropCatalog.find(itemId).map(c -> c.sellPrice());
        if (cropSell.isPresent()) return cropSell.get();
        return ShopCatalog.find(itemId).map(ShopItemDef::sellPrice).orElse(0);
    }

    private ShopService() {
    }
}
