package vn.dreamtech.cozyfarming.server.dao;

import vn.dreamtech.cozyfarming.server.model.CookingState;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;

/**
 * Bảng THÊM MỚI {@code cooking_state} — mỗi user tối đa 1 dòng (khớp
 * {@code S.cooking} client: bếp chỉ nấu 1 món/lượt). DDL:
 * <pre>
 * CREATE TABLE cooking_state (
 *   user_id INT NOT NULL PRIMARY KEY, food_id VARCHAR(30) NOT NULL, started_at TIMESTAMP NOT NULL
 * );
 * </pre>
 */
public final class CookingStateDao {
    private final DataSource dataSource;

    public CookingStateDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public Optional<CookingState> find(int userId) throws SQLException {
        String sql = "SELECT food_id, started_at FROM cooking_state WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();
                return Optional.of(new CookingState(userId, rs.getString("food_id"), rs.getTimestamp("started_at").getTime()));
            }
        }
    }

    public void start(int userId, String foodId, long startedAt) throws SQLException {
        String sql = "MERGE INTO cooking_state (user_id, food_id, started_at) KEY (user_id) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, foodId);
            ps.setTimestamp(3, new Timestamp(startedAt));
            ps.executeUpdate();
        }
    }

    public void clear(int userId) throws SQLException {
        String sql = "DELETE FROM cooking_state WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }
}
