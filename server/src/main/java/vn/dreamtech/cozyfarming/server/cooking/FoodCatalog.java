package vn.dreamtech.cozyfarming.server.cooking;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/** 9 công thức chép nguyên từ {@code FOODS} trong {@code src/data/foods.ts} — không tự đổi số liệu. */
public final class FoodCatalog {
    private static final Map<String, FoodDef> FOODS = Map.ofEntries(
            Map.entry("salad", new FoodDef("salad", 8, 320, 12,
                    List.of(new FoodIngredient("cabbage", 2), new FoodIngredient("carrot", 2)))),
            Map.entry("soup_pumpkin", new FoodDef("soup_pumpkin", 12, 460, 16,
                    List.of(new FoodIngredient("pumpkin", 2), new FoodIngredient("potato", 1)))),
            Map.entry("juice_berry", new FoodDef("juice_berry", 10, 400, 14,
                    List.of(new FoodIngredient("strawberry", 3)))),
            Map.entry("corn_grill", new FoodDef("corn_grill", 6, 240, 9,
                    List.of(new FoodIngredient("corn", 2)))),
            Map.entry("tomato_sauce", new FoodDef("tomato_sauce", 9, 350, 12,
                    List.of(new FoodIngredient("tomato", 3)))),
            Map.entry("veggie_stew", new FoodDef("veggie_stew", 18, 720, 26,
                    List.of(new FoodIngredient("turnip", 2), new FoodIngredient("carrot", 2), new FoodIngredient("potato", 2)))),
            Map.entry("meat_grill", new FoodDef("meat_grill", 15, 560, 22,
                    List.of(new FoodIngredient("meat", 1), new FoodIngredient("corn", 1)))),
            Map.entry("meat_stew", new FoodDef("meat_stew", 22, 880, 32,
                    List.of(new FoodIngredient("meat", 2), new FoodIngredient("egg", 2), new FoodIngredient("carrot", 1)))),
            Map.entry("milk_cake", new FoodDef("milk_cake", 20, 700, 27,
                    List.of(new FoodIngredient("milk", 2), new FoodIngredient("egg", 2), new FoodIngredient("wheat", 2))))
    );

    public static Optional<FoodDef> find(String id) {
        return Optional.ofNullable(FOODS.get(id));
    }

    public static int sellPriceOf(String id) {
        return find(id).map(FoodDef::sell).orElse(0);
    }

    private FoodCatalog() {
    }
}
