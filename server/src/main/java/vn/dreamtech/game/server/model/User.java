package vn.dreamtech.game.server.model;

/**
 * Tài khoản người chơi. Một dòng có thể chỉ có {@code guestToken} (khách
 * thuần), thêm {@code username}/{@code passwordHash} khi khách nâng cấp lên
 * tài khoản thường, và/hoặc thêm {@code googleId}/{@code appleId} khi liên
 * kết mạng xã hội — cùng 1 user id xuyên suốt dù đăng nhập bằng cách nào.
 */
public record User(int id, String username, String passwordHash, String guestToken,
                    String googleId, String appleId, String displayName) {
    public boolean isGuestOnly() {
        return username == null;
    }
}
