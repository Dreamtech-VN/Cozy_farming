package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Bảng {@code mail_broadcast_receipts} — DDL:
 * <pre>
 * CREATE TABLE mail_broadcast_receipts (
 *   user_id INT NOT NULL, template_id VARCHAR(36) NOT NULL, PRIMARY KEY (user_id, template_id)
 * );
 * </pre>
 * Đánh dấu user đã được "vật chất hoá" 1 mail quảng bá (xem
 * {@code MailTemplateDao}) — tránh tạo trùng mail mỗi lần user mở hộp thư.
 */
public final class MailBroadcastReceiptDao {
    private final DataSource dataSource;

    public MailBroadcastReceiptDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public boolean hasReceived(int userId, String templateId) throws SQLException {
        String sql = "SELECT 1 FROM mail_broadcast_receipts WHERE user_id = ? AND template_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, templateId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void markReceived(int userId, String templateId) throws SQLException {
        String sql = "MERGE INTO mail_broadcast_receipts (user_id, template_id) KEY (user_id, template_id) VALUES (?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, templateId);
            ps.executeUpdate();
        }
    }
}
