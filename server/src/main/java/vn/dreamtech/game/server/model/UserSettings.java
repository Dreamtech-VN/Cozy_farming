package vn.dreamtech.game.server.model;

/**
 * Cài đặt phần "Notifications" + "Privacy & Social" — 2 mục duy nhất trong
 * 10 mục cài đặt cần đồng bộ qua server (còn lại như graphics/audio/
 * controls/language là cấu hình thuần client, lưu local, không cần server).
 * {@code friendRequestPrivacy}/{@code messagePrivacy}: "EVERYONE" | "NOBODY".
 */
public record UserSettings(int userId, boolean pushNotifications,
                            String friendRequestPrivacy, String messagePrivacy, String language) {
    public static UserSettings defaultsFor(int userId) {
        return new UserSettings(userId, true, "EVERYONE", "EVERYONE", "vi");
    }
}
