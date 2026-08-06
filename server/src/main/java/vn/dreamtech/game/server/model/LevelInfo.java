package vn.dreamtech.game.server.model;

/** Bảng RIÊNG với {@code characters} (không đụng bảng cũ) — level/exp đổi liên tục theo trận đấu/nhiệm vụ, tách khỏi dữ liệu cosmetic ổn định. */
public record LevelInfo(int userId, int level, int exp) {
    public static LevelInfo defaultsFor(int userId) {
        return new LevelInfo(userId, 1, 0);
    }
}
