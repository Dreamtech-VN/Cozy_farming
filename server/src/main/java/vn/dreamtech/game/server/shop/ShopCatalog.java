package vn.dreamtech.game.server.shop;

import vn.dreamtech.game.server.character.CosmeticCatalog;
import vn.dreamtech.game.server.model.CosmeticDef;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Giá bán (vàng) cho từng cosmetic — item "default" giá 0 (nhận miễn phí
 * qua shop luôn cho tiện, không cần luồng riêng). Mọi item trong
 * {@link CosmeticCatalog} đều phải có giá ở đây (có test bảo đảm).
 */
public final class ShopCatalog {
    private static final Map<Integer, Long> PRICE_GOLD = Map.ofEntries(
            Map.entry(1, 0L),     // eyes_default
            Map.entry(2, 150L),   // eyes_round
            Map.entry(3, 150L),   // eyes_sharp
            Map.entry(10, 0L),    // avatar_default
            Map.entry(11, 150L),  // avatar_smile
            Map.entry(20, 200L),  // frame_bronze
            Map.entry(21, 500L),  // frame_gold
            Map.entry(30, 100L),  // title_newbie
            Map.entry(31, 300L),  // title_veteran
            Map.entry(40, 150L),  // emote_wave
            Map.entry(41, 150L),  // emote_laugh
            Map.entry(50, 200L),  // hat_straw
            Map.entry(51, 800L),  // hat_crown
            Map.entry(60, 150L),  // shirt_casual
            Map.entry(70, 150L),  // pants_casual
            Map.entry(80, 150L),  // shoes_sneaker
            Map.entry(90, 500L),  // pet_cat
            Map.entry(91, 500L),  // pet_dog
            Map.entry(100, 0L)    // skin_default
    );

    public static List<ShopItemView> all() {
        return CosmeticCatalog.all().stream()
                .map(d -> new ShopItemView(d.id(), d.type().name(), d.name(), priceOf(d)))
                .toList();
    }

    public static Optional<ShopItemView> find(int itemId) {
        return CosmeticCatalog.find(itemId)
                .map(d -> new ShopItemView(d.id(), d.type().name(), d.name(), priceOf(d)));
    }

    private static long priceOf(CosmeticDef def) {
        Long price = PRICE_GOLD.get(def.id());
        if (price == null) {
            throw new IllegalStateException("Cosmetic id " + def.id() + " chưa có giá trong ShopCatalog");
        }
        return price;
    }

    private ShopCatalog() {
    }
}
