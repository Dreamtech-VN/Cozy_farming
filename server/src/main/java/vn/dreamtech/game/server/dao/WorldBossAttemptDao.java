package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;

/**
 * Bảng {@code world_boss_attempts} — DDL:
 * <pre>
 * CREATE TABLE world_boss_attempts (
 *   user_id INT NOT NULL PRIMARY KEY, cycle_started_at TIMESTAMP NOT NULL
 * );
 * </pre>
 * Cùng cơ chế "lưu mốc chu kỳ đã đánh" như {@code GuildBossAttemptDao}.
 */
public final class WorldBossAttemptDao {
    private final DataSource dataSource;

    public WorldBossAttemptDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public Optional<Long> findAttemptedCycle(int userId) throws SQLException {
        String sql = "SELECT cycle_started_at FROM world_boss_attempts WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();
                return Optional.of(rs.getTimestamp("cycle_started_at").getTime());
            }
        }
    }

    public void recordAttempt(int userId, long cycleStartedAt) throws SQLException {
        String sql = "MERGE INTO world_boss_attempts (user_id, cycle_started_at) KEY (user_id) VALUES (?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setTimestamp(2, new Timestamp(cycleStartedAt));
            ps.executeUpdate();
        }
    }
}
