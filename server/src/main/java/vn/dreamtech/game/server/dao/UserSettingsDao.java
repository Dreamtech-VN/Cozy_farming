package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.model.UserSettings;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Bảng {@code user_settings} — DDL:
 * <pre>
 * CREATE TABLE user_settings (
 *   user_id INT NOT NULL PRIMARY KEY, push_notifications TINYINT NOT NULL DEFAULT 1,
 *   friend_request_privacy VARCHAR(20) NOT NULL DEFAULT 'EVERYONE',
 *   message_privacy VARCHAR(20) NOT NULL DEFAULT 'EVERYONE', language VARCHAR(10) NOT NULL DEFAULT 'vi'
 * );
 * </pre>
 * Chưa có dòng thì trả về mặc định (khớp cách {@code WalletDao} đã làm ở dự
 * án trước) — không bắt buộc phải "khởi tạo" cài đặt trước khi dùng.
 */
public final class UserSettingsDao {
    private final DataSource dataSource;

    public UserSettingsDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public UserSettings find(int userId) throws SQLException {
        String sql = "SELECT push_notifications, friend_request_privacy, message_privacy, language FROM user_settings WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return UserSettings.defaultsFor(userId);
                return new UserSettings(userId, rs.getBoolean("push_notifications"),
                        rs.getString("friend_request_privacy"), rs.getString("message_privacy"), rs.getString("language"));
            }
        }
    }

    public void save(UserSettings settings) throws SQLException {
        String sql = "MERGE INTO user_settings (user_id, push_notifications, friend_request_privacy, message_privacy, language) "
                + "KEY (user_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, settings.userId());
            ps.setBoolean(2, settings.pushNotifications());
            ps.setString(3, settings.friendRequestPrivacy());
            ps.setString(4, settings.messagePrivacy());
            ps.setString(5, settings.language());
            ps.executeUpdate();
        }
    }
}
