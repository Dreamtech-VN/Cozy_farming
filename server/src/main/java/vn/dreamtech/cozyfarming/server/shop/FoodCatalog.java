package vn.dreamtech.cozyfarming.server.shop;

import java.util.Map;
import java.util.Optional;

/**
 * Món nấu ở nhà bếp — CHỈ giá bán, chép từ {@code FOODS} trong
 * {@code src/data/foods.ts}, để {@link ShopService} định giá đúng khi bán
 * vật phẩm kho có id {@code food_<tên món>}. Hệ nấu ăn đầy đủ (nguyên liệu,
 * thời gian nấu, action nấu/lấy món) CHƯA lên server — TODO giai đoạn "nhà
 * bếp" sau, bảng này giữ sẵn để tránh 2 nguồn số liệu lệch nhau khi làm.
 */
public final class FoodCatalog {
    private static final Map<String, Integer> SELL_PRICE = Map.ofEntries(
            Map.entry("salad", 320),
            Map.entry("soup_pumpkin", 460),
            Map.entry("juice_berry", 400),
            Map.entry("corn_grill", 240),
            Map.entry("tomato_sauce", 350),
            Map.entry("veggie_stew", 720),
            Map.entry("meat_grill", 560),
            Map.entry("meat_stew", 880),
            Map.entry("milk_cake", 700)
    );

    public static Optional<Integer> sellPriceOf(String id) {
        return Optional.ofNullable(SELL_PRICE.get(id));
    }

    private FoodCatalog() {
    }
}
