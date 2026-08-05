package vn.dreamtech.cozyfarming.server.dao;

import vn.dreamtech.cozyfarming.server.model.PasswordReset;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.Optional;

/**
 * Bảng THÊM MỚI {@code password_resets} — không có trong schema thật gốc
 * (bảng `users` gốc không có cột mã khôi phục). Thêm bảng riêng thay vì sửa
 * bảng `users` thật để không đụng dữ liệu gốc. Cùng cơ chế "mã khôi phục"
 * client offline đã dùng (`login.ts`), nhưng giờ server sinh + kiểm tra
 * thật, có hạn dùng (15 phút) thay vì chỉ hiện 1 lần trên máy.
 *
 * DDL tương ứng (chạy 1 lần khi deploy):
 * <pre>
 * CREATE TABLE password_resets (
 *   user_id INT NOT NULL PRIMARY KEY,
 *   code_hash VARCHAR(255) NOT NULL,
 *   expires_at TIMESTAMP NOT NULL
 * );
 * </pre>
 */
public final class PasswordResetDao {
    private final DataSource dataSource;

    public PasswordResetDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    /** Ghi đè yêu cầu cũ nếu có (mỗi user chỉ có 1 yêu cầu khôi phục đang hiệu lực). */
    public void upsert(int userId, String codeHash, Instant expiresAt) throws SQLException {
        String sql = "MERGE INTO password_resets (user_id, code_hash, expires_at) KEY (user_id) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, codeHash);
            ps.setTimestamp(3, Timestamp.from(expiresAt));
            ps.executeUpdate();
        }
    }

    public Optional<PasswordReset> find(int userId) throws SQLException {
        String sql = "SELECT user_id, code_hash, expires_at FROM password_resets WHERE user_id = ?";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();
                return Optional.of(new PasswordReset(
                        rs.getInt("user_id"), rs.getString("code_hash"), rs.getTimestamp("expires_at").toInstant()));
            }
        }
    }

    public void delete(int userId) throws SQLException {
        String sql = "DELETE FROM password_resets WHERE user_id = ?";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }
}
