package vn.dreamtech.cozyfarming.server.model;

/** Khớp {@code S.cooking} client — mỗi user chỉ nấu 1 món/lượt. */
public record CookingState(int userId, String foodId, long startedAt) {
}
