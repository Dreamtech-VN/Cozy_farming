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
 *   message VARCHAR(1000) NOT NULL, created_at TIMESTAMP NOT NULL, resolved BOOLEAN NOT NULL DEFAULT FALSE
 * );
 * </pre>
 * "Support" trong cài đặt (Báo lỗi/Liên hệ) — người chơi xem lại được
 * ticket của chính mình; admin xem TOÀN BỘ + đánh dấu đã xử lý qua
 * {@code /api/admin/support/*} (trước đây phải xem trực tiếp DB, giờ có
 * màn quản trị thật).
 */
public final class SupportTicketDao {
    private final DataSource dataSource;

    public SupportTicketDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public SupportTicket create(int userId, String category, String message, long now) throws SQLException {
        String sql = "INSERT INTO support_tickets (user_id, category, message, created_at, resolved) VALUES (?, ?, ?, ?, FALSE)";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, category);
            ps.setString(3, message);
            ps.setTimestamp(4, new Timestamp(now));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                return new SupportTicket(keys.getLong(1), userId, category, message, now, false);
            }
        }
    }

    public List<SupportTicket> findByUser(int userId) throws SQLException {
        String sql = "SELECT id, user_id, category, message, created_at, resolved FROM support_tickets WHERE user_id = ? ORDER BY id DESC";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<SupportTicket> out = new ArrayList<>();
                while (rs.next()) out.add(map(rs));
                return out;
            }
        }
    }

    /** Admin xem toàn bộ ticket — {@code unresolvedOnly} lọc bớt ticket đã xử lý cho gọn. */
    public List<SupportTicket> findAll(boolean unresolvedOnly) throws SQLException {
        String sql = "SELECT id, user_id, category, message, created_at, resolved FROM support_tickets"
                + (unresolvedOnly ? " WHERE resolved = FALSE" : "") + " ORDER BY id DESC";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<SupportTicket> out = new ArrayList<>();
            while (rs.next()) out.add(map(rs));
            return out;
        }
    }

    public boolean resolve(long ticketId) throws SQLException {
        String sql = "UPDATE support_tickets SET resolved = TRUE WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, ticketId);
            return ps.executeUpdate() > 0;
        }
    }

    private static SupportTicket map(ResultSet rs) throws SQLException {
        return new SupportTicket(rs.getLong("id"), rs.getInt("user_id"), rs.getString("category"),
                rs.getString("message"), rs.getTimestamp("created_at").getTime(), rs.getBoolean("resolved"));
    }
}
