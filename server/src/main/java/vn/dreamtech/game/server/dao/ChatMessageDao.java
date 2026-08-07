package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.model.ChatMessage;

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
 * Bảng {@code chat_messages} — DDL:
 * <pre>
 * CREATE TABLE chat_messages (
 *   id BIGINT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, sender_name VARCHAR(20) NOT NULL,
 *   text VARCHAR(500) NOT NULL, created_at TIMESTAMP NOT NULL
 * );
 * </pre>
 * Chat sảnh chung (1 kênh duy nhất) — client poll bằng {@code id} tăng dần
 * (khớp cơ chế REST polling đã dùng cho sảnh ở giai đoạn 4), không dùng mốc
 * thời gian để tránh lệch giờ máy.
 */
public final class ChatMessageDao {
    private final DataSource dataSource;

    public ChatMessageDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public ChatMessage send(int userId, String senderName, String text, long now) throws SQLException {
        String sql = "INSERT INTO chat_messages (user_id, sender_name, text, created_at) VALUES (?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, senderName);
            ps.setString(3, text);
            ps.setTimestamp(4, new Timestamp(now));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                return new ChatMessage(keys.getLong(1), userId, senderName, text, now);
            }
        }
    }

    /** Admin xoá 1 tin nhắn (kiểm duyệt nội dung vi phạm) — trả về false nếu tin không tồn tại. */
    public boolean delete(long messageId) throws SQLException {
        String sql = "DELETE FROM chat_messages WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, messageId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Tin nhắn có id > {@code sinceId}, cũ nhất trước, tối đa {@code limit} tin. */
    public List<ChatMessage> findSince(long sinceId, int limit) throws SQLException {
        String sql = "SELECT id, user_id, sender_name, text, created_at FROM chat_messages WHERE id > ? ORDER BY id ASC LIMIT ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, sinceId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                List<ChatMessage> out = new ArrayList<>();
                while (rs.next()) {
                    out.add(new ChatMessage(rs.getLong("id"), rs.getInt("user_id"), rs.getString("sender_name"),
                            rs.getString("text"), rs.getTimestamp("created_at").getTime()));
                }
                return out;
            }
        }
    }
}
