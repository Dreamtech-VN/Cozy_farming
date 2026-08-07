package vn.dreamtech.game.server.dao;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import vn.dreamtech.game.server.item.RewardEntry;

import javax.sql.DataSource;
import java.lang.reflect.Type;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Bảng {@code mails} — DDL:
 * <pre>
 * CREATE TABLE mails (
 *   id VARCHAR(36) NOT NULL PRIMARY KEY, user_id INT NOT NULL, title VARCHAR(100) NOT NULL,
 *   body VARCHAR(1000), rewards VARCHAR(2000) NOT NULL, source VARCHAR(20) NOT NULL,
 *   created_at TIMESTAMP NOT NULL, expires_at TIMESTAMP, read_at TIMESTAMP, claimed_at TIMESTAMP
 * );
 * </pre>
 * Hộp thư CÁ NHÂN từng user — mail quảng bá (admin gửi toàn server) được
 * "vật chất hoá" thành 1 dòng riêng cho từng user ở lần đầu họ mở hộp thư
 * (xem {@code MailService#list}, giống cách chu kỳ Guild Boss tự resolve
 * lazy, KHÔNG dùng cron). {@code rewards} lưu JSON (Gson) danh sách
 * {@link RewardEntry} — chỉ thật sự cấp phát khi user bấm nhận
 * ({@code MailService#claim} gọi {@code RewardGrantService}).
 */
public final class MailDao {
    private static final Gson GSON = new Gson();
    private static final Type REWARD_LIST_TYPE = new TypeToken<List<RewardEntry>>() {
    }.getType();

    private final DataSource dataSource;

    public MailDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public record Mail(String id, int userId, String title, String body, List<RewardEntry> rewards, String source,
                        long createdAt, Long expiresAt, Long readAt, Long claimedAt) {
    }

    public Mail create(int userId, String title, String body, List<RewardEntry> rewards, String source,
                        long createdAt, Long expiresAt) throws SQLException {
        String id = UUID.randomUUID().toString();
        String sql = "INSERT INTO mails (id, user_id, title, body, rewards, source, created_at, expires_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, id);
            ps.setInt(2, userId);
            ps.setString(3, title);
            ps.setString(4, body);
            ps.setString(5, GSON.toJson(rewards));
            ps.setString(6, source);
            ps.setTimestamp(7, new Timestamp(createdAt));
            if (expiresAt == null) ps.setNull(8, Types.TIMESTAMP); else ps.setTimestamp(8, new Timestamp(expiresAt));
            ps.executeUpdate();
        }
        return new Mail(id, userId, title, body, rewards, source, createdAt, expiresAt, null, null);
    }

    public Optional<Mail> find(String id) throws SQLException {
        String sql = "SELECT * FROM mails WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    public List<Mail> listByUser(int userId) throws SQLException {
        String sql = "SELECT * FROM mails WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Mail> out = new ArrayList<>();
                while (rs.next()) out.add(map(rs));
                return out;
            }
        }
    }

    public void markRead(String id, long readAt) throws SQLException {
        String sql = "UPDATE mails SET read_at = ? WHERE id = ? AND read_at IS NULL";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(readAt));
            ps.setString(2, id);
            ps.executeUpdate();
        }
    }

    public void markClaimed(String id, long claimedAt) throws SQLException {
        String sql = "UPDATE mails SET claimed_at = ? WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(claimedAt));
            ps.setString(2, id);
            ps.executeUpdate();
        }
    }

    private static Mail map(ResultSet rs) throws SQLException {
        Timestamp expiresAt = rs.getTimestamp("expires_at");
        Timestamp readAt = rs.getTimestamp("read_at");
        Timestamp claimedAt = rs.getTimestamp("claimed_at");
        List<RewardEntry> rewards = GSON.fromJson(rs.getString("rewards"), REWARD_LIST_TYPE);
        return new Mail(rs.getString("id"), rs.getInt("user_id"), rs.getString("title"), rs.getString("body"),
                rewards, rs.getString("source"), rs.getTimestamp("created_at").getTime(),
                expiresAt == null ? null : expiresAt.getTime(),
                readAt == null ? null : readAt.getTime(),
                claimedAt == null ? null : claimedAt.getTime());
    }
}
