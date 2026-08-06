package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.model.Marriage;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;

/**
 * Bảng {@code marriages} — DDL:
 * <pre>
 * CREATE TABLE marriages (
 *   user_id_a INT NOT NULL, user_id_b INT NOT NULL, married_at TIMESTAMP NOT NULL,
 *   PRIMARY KEY (user_id_a, user_id_b)
 * );
 * </pre>
 * Chuẩn hoá {@code userIdA < userIdB} giống {@link FriendshipDao}. Ly hôn
 * (giai đoạn 10) xoá thẳng dòng này — không lưu lịch sử hôn nhân cũ.
 */
public final class MarriageDao {
    private final DataSource dataSource;

    public MarriageDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public boolean isMarried(int userId) throws SQLException {
        String sql = "SELECT 1 FROM marriages WHERE user_id_a = ? OR user_id_b = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public Optional<Integer> findSpouse(int userId) throws SQLException {
        String sql = "SELECT user_id_a, user_id_b FROM marriages WHERE user_id_a = ? OR user_id_b = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();
                int a = rs.getInt("user_id_a");
                int b = rs.getInt("user_id_b");
                return Optional.of(a == userId ? b : a);
            }
        }
    }

    public Marriage create(int userA, int userB, long now) throws SQLException {
        int a = Math.min(userA, userB);
        int b = Math.max(userA, userB);
        String sql = "INSERT INTO marriages (user_id_a, user_id_b, married_at) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, a);
            ps.setInt(2, b);
            ps.setTimestamp(3, new Timestamp(now));
            ps.executeUpdate();
        }
        return new Marriage(a, b, now);
    }

    /** Ly hôn — xoá dòng hôn nhân của {@code userId} (không quan tâm cột A/B). */
    public void deleteByUser(int userId) throws SQLException {
        String sql = "DELETE FROM marriages WHERE user_id_a = ? OR user_id_b = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }
}
