package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;

/**
 * Bảng {@code banned_users} — DDL:
 * <pre>
 * CREATE TABLE banned_users (
 *   user_id INT NOT NULL PRIMARY KEY, reason VARCHAR(255), banned_at TIMESTAMP NOT NULL
 * );
 * </pre>
 * Tách riêng khỏi {@code users} thay vì thêm cột {@code banned} — tránh
 * phải sửa {@code User} record (dùng ở RẤT nhiều nơi: đăng ký/đăng nhập/
 * liên kết mạng xã hội/nâng cấp khách...) chỉ để thêm 1 cờ quản trị. Có
 * dòng trong bảng này = đang bị cấm; xoá dòng = gỡ cấm.
 */
public final class BannedUserDao {
    private final DataSource dataSource;

    public BannedUserDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public record Ban(int userId, String reason, long bannedAt) {
    }

    public void ban(int userId, String reason) throws SQLException {
        String sql = "MERGE INTO banned_users (user_id, reason, banned_at) KEY (user_id) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, reason);
            ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            ps.executeUpdate();
        }
    }

    public void unban(int userId) throws SQLException {
        String sql = "DELETE FROM banned_users WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    public boolean isBanned(int userId) throws SQLException {
        String sql = "SELECT 1 FROM banned_users WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public Optional<Ban> find(int userId) throws SQLException {
        String sql = "SELECT user_id, reason, banned_at FROM banned_users WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();
                return Optional.of(new Ban(rs.getInt("user_id"), rs.getString("reason"), rs.getTimestamp("banned_at").getTime()));
            }
        }
    }
}
