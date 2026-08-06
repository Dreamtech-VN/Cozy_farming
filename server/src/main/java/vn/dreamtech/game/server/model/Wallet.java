package vn.dreamtech.game.server.model;

/** Ví vàng/kim cương — game mới chưa có shop/economy đầy đủ, ví này CHỈ để phục vụ chi phí kết hôn trước mắt. */
public record Wallet(int userId, long gold, long diamond) {
    public static Wallet defaultsFor(int userId) {
        return new Wallet(userId, 0, 0);
    }
}
