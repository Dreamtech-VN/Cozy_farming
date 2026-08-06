package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.model.SupportTicket;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Bảng {@code support_tickets} — DDL:
 * <pre>
 * CREATE TABLE support_tickets (
 *   id BIGINT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, category VARCHAR(20) NOT NULL,
 *   message VARCHAR(1000) NOT NULL, created_at TIMESTAMP NOT NULL
 * );
 * </pre>
 * "Support" trong cài đặt (Báo lỗi/Liên hệ) — chỉ lưu lại để admin xem sau
 * (chưa có màn admin, xem trực tiếp DB), người chơi xem lại được ticket của
 * chính mình.
 */
public final class SupportTicketDao {
    private final DataSource dataSource;

    public SupportTicketDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public SupportTicket create(int userId, String category, String message, long now) throws SQLException {
        String sql = "INSERT INTO support_tickets (user_id, category, message, created_at) VALUES (?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, category);
            ps.setString(3, message);
            ps.setTimestamp(4, new Timestamp(now));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                return new SupportTicket(keys.getLong(1), userId, category, message, now);
            }
        }
    }

    public List<SupportTicket> findByUser(int userId) throws SQLException {
        String sql = "SELECT id, user_id, category, message, created_at FROM support_tickets WHERE user_id = ? ORDER BY id DESC";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<SupportTicket> out = new ArrayList<>();
                while (rs.next()) {
                    out.add(new SupportTicket(rs.getLong("id"), rs.getInt("user_id"), rs.getString("category"),
                            rs.getString("message"), rs.getTimestamp("created_at").getTime()));
                }
                return out;
            }
        }
    }
}
