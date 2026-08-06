package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

/**
 * Bảng {@code guild_war_attempts} — DDL:
 * <pre>
 * CREATE TABLE guild_war_attempts (
 *   user_id INT NOT NULL, war_id VARCHAR(36) NOT NULL, attempted_at TIMESTAMP NOT NULL,
 *   PRIMARY KEY (user_id, war_id)
 * );
 * </pre>
 * Mỗi thành viên chỉ đánh được 1 lần cho MỖI cuộc chiến (không theo chu kỳ
 * như Guild Boss, vì Guild War có thời điểm bắt đầu/kết thúc riêng biệt).
 */
public final class GuildWarAttemptDao {
    private final DataSource dataSource;

    public GuildWarAttemptDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public boolean hasAttempted(int userId, String warId) throws SQLException {
        String sql = "SELECT 1 FROM guild_war_attempts WHERE user_id = ? AND war_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, warId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void recordAttempt(int userId, String warId) throws SQLException {
        String sql = "MERGE INTO guild_war_attempts (user_id, war_id, attempted_at) KEY (user_id, war_id) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, warId);
            ps.setTimestamp(3, Timestamp.from(java.time.Instant.now()));
            ps.executeUpdate();
        }
    }
}
