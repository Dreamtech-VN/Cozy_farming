package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.battle.challenge.ChallengeType;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;

/**
 * Bảng {@code challenge_attempts} — DDL:
 * <pre>
 * CREATE TABLE challenge_attempts (
 *   user_id INT NOT NULL, challenge_type VARCHAR(10) NOT NULL, last_completed_at TIMESTAMP NOT NULL,
 *   PRIMARY KEY (user_id, challenge_type)
 * );
 * </pre>
 * Chỉ ghi nhận khi THẮNG (xem {@code BattleService}), dùng tính cooldown
 * trước khi cho làm lại Daily/Weekly Challenge.
 */
public final class ChallengeAttemptDao {
    private final DataSource dataSource;

    public ChallengeAttemptDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public Optional<Long> findLastCompletedAt(int userId, ChallengeType type) throws SQLException {
        String sql = "SELECT last_completed_at FROM challenge_attempts WHERE user_id = ? AND challenge_type = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, type.name());
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();
                return Optional.of(rs.getTimestamp("last_completed_at").getTime());
            }
        }
    }

    public void recordCompletion(int userId, ChallengeType type, long whenMillis) throws SQLException {
        String sql = "MERGE INTO challenge_attempts (user_id, challenge_type, last_completed_at) KEY (user_id, challenge_type) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, type.name());
            ps.setTimestamp(3, new Timestamp(whenMillis));
            ps.executeUpdate();
        }
    }
}
