package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Bảng {@code player_cosmetics} — DDL:
 * <pre>
 * CREATE TABLE player_cosmetics (
 *   user_id INT NOT NULL, item_id INT NOT NULL, unlocked_at TIMESTAMP NOT NULL,
 *   PRIMARY KEY (user_id, item_id)
 * );
 * </pre>
 * Sở hữu vật phẩm làm đẹp. Chưa có shop/thành tựu thật để mở khoá — {@code
 * unlock} hiện là hook test đứng thay cho hệ shop/thành tựu sau này, giống
 * {@code AddCurrencyHandler}.
 */
public final class PlayerCosmeticDao {
    private final DataSource dataSource;

    public PlayerCosmeticDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public void unlock(int userId, int itemId) throws SQLException {
        String sql = "MERGE INTO player_cosmetics (user_id, item_id, unlocked_at) KEY (user_id, item_id) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, itemId);
            ps.setTimestamp(3, Timestamp.from(java.time.Instant.now()));
            ps.executeUpdate();
        }
    }

    public boolean isOwned(int userId, int itemId) throws SQLException {
        String sql = "SELECT 1 FROM player_cosmetics WHERE user_id = ? AND item_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<Integer> listOwned(int userId) throws SQLException {
        String sql = "SELECT item_id FROM player_cosmetics WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Integer> ids = new ArrayList<>();
                while (rs.next()) ids.add(rs.getInt("item_id"));
                return ids;
            }
        }
    }
}
