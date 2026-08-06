package vn.dreamtech.cozyfarming.server.cooking;

/** Khớp {@code material: [cropId, số lượng][]} trong {@code FoodDef} client — nguyên liệu lấy từ ngăn "produce" của kho nông trại. */
public record FoodIngredient(String cropId, int qty) {
}
