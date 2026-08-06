package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;

/**
 * Bảng {@code guild_boss_attempts} — DDL:
 * <pre>
 * CREATE TABLE guild_boss_attempts (
 *   user_id INT NOT NULL PRIMARY KEY, cycle_started_at TIMESTAMP NOT NULL
 * );
 * </pre>
 * Lưu MỐC CHU KỲ (không phải cooldown tuyệt đối) mà user đã đánh — so
 * khớp với {@code cycle_started_at} hiện tại của guild để biết còn lượt
 * hay không, tự động "reset" theo chu kỳ mới mà không cần dọn dữ liệu.
 */
public final class GuildBossAttemptDao {
    private final DataSource dataSource;

    public GuildBossAttemptDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public Optional<Long> findAttemptedCycle(int userId) throws SQLException {
        String sql = "SELECT cycle_started_at FROM guild_boss_attempts WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();
                return Optional.of(rs.getTimestamp("cycle_started_at").getTime());
            }
        }
    }

    public void recordAttempt(int userId, long cycleStartedAt) throws SQLException {
        String sql = "MERGE INTO guild_boss_attempts (user_id, cycle_started_at) KEY (user_id) VALUES (?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setTimestamp(2, new Timestamp(cycleStartedAt));
            ps.executeUpdate();
        }
    }
}
