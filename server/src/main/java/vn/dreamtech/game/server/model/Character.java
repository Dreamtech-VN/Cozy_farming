package vn.dreamtech.game.server.model;

/**
 * Nhân vật của user — 1 user 1 nhân vật. {@code gender} 0 = nam, 1 = nữ.
 * Trang phục chỉ 3 ô cơ bản (tóc/áo/quần) — chưa có bảng vật phẩm thật cho
 * game mới này, id trang phục tạm là số nguyên tự do, TODO ràng buộc theo
 * catalog thật khi có hệ vật phẩm.
 */
public record Character(int userId, String name, int gender, int hairId, int topId, int bottomId) {
}
