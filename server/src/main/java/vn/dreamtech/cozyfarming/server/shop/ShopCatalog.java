package vn.dreamtech.cozyfarming.server.shop;

import java.util.Map;
import java.util.Optional;

/**
 * Vật phẩm túi đồ chung + sản phẩm vật nuôi — chép nguyên giá mua/bán từ
 * {@code src/data/items.ts} client. Hạt giống KHÔNG nằm ở đây — giá lấy
 * thẳng từ {@link vn.dreamtech.cozyfarming.server.farm.CropCatalog} (xem
 * {@link ShopService}) để khỏi chép 2 lần cùng 1 số liệu.
 * {@code buyPrice = -1}: vật phẩm không có field {@code buy} bên client
 * (chỉ thu được, không mua được — ví dụ trứng/sữa/thịt/len).
 */
public final class ShopCatalog {
    private static final Map<String, ShopItemDef> ITEMS = Map.ofEntries(
            Map.entry("fertilizer", new ShopItemDef("fertilizer", 15, 2)),
            Map.entry("feed", new ShopItemDef("feed", 10, 2)),
            Map.entry("animal_med", new ShopItemDef("animal_med", 25, 3)),
            Map.entry("gift_flower", new ShopItemDef("gift_flower", 50, 10)),
            Map.entry("gift_choco", new ShopItemDef("gift_choco", 100, 20)),
            Map.entry("gift_teddy", new ShopItemDef("gift_teddy", 300, 60)),
            Map.entry("lucky_ticket", new ShopItemDef("lucky_ticket", 2000, 0)),
            Map.entry("tool_basket", new ShopItemDef("tool_basket", 400, 0)),
            Map.entry("tool_axe", new ShopItemDef("tool_axe", 800, 0)),
            Map.entry("bait_rice", new ShopItemDef("bait_rice", 5, 1)),
            Map.entry("bait_worm", new ShopItemDef("bait_worm", 20, 4)),
            Map.entry("bait_ant_egg", new ShopItemDef("bait_ant_egg", 30, 6)),
            // food_cake/food_juice có field buy/sell bên items.ts nhưng KHÔNG bán lại được từ kho
            // (id bắt đầu "food_" luôn tra qua FoodCatalog, không qua ShopCatalog — xem ShopService),
            // sellPrice ở đây chỉ để tài liệu hoá số liệu gốc, không dùng khi bán.
            Map.entry("food_cake", new ShopItemDef("food_cake", 200, 40)),
            Map.entry("food_juice", new ShopItemDef("food_juice", 40, 8)),
            Map.entry("cheese", new ShopItemDef("cheese", 260, 120)),
            Map.entry("bread", new ShopItemDef("bread", 120, 55)),
            Map.entry("honey", new ShopItemDef("honey", 320, 150)),
            Map.entry("egg", new ShopItemDef("egg", -1, 25)),
            Map.entry("milk", new ShopItemDef("milk", -1, 60)),
            Map.entry("meat", new ShopItemDef("meat", -1, 90)),
            Map.entry("pork", new ShopItemDef("pork", -1, 45)),
            Map.entry("wool", new ShopItemDef("wool", -1, 70))
    );

    public static Optional<ShopItemDef> find(String id) {
        return Optional.ofNullable(ITEMS.get(id));
    }

    private ShopCatalog() {
    }
}
