package vn.dreamtech.cozyfarming.server.cooking;

import java.util.List;

/** Khớp {@code FoodDef} client ({@code src/data/foods.ts}). */
public record FoodDef(String id, int cookMin, int sell, int exp, List<FoodIngredient> material) {
}
