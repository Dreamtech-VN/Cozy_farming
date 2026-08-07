package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Bảng {@code player_items} — DDL:
 * <pre>
 * CREATE TABLE player_items (
 *   user_id INT NOT NULL, item_id INT NOT NULL, quantity INT NOT NULL DEFAULT 0,
 *   PRIMARY KEY (user_id, item_id)
 * );
 * </pre>
 * Kho đồ chung cho item loại {@code MATERIAL} (xem {@code ItemDao}) — chỉ
 * đếm số lượng, chưa có công dụng cụ thể (dành cho chế tạo/nhiệm vụ sau
 * này).
 */
public final class PlayerItemDao {
    private final DataSource dataSource;

    public PlayerItemDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public record OwnedItem(int itemId, int quantity) {
    }

    public void addQuantity(int userId, int itemId, int amount) throws SQLException {
        int current = findQuantity(userId, itemId);
        String sql = "MERGE INTO player_items (user_id, item_id, quantity) KEY (user_id, item_id) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, itemId);
            ps.setInt(3, current + amount);
            ps.executeUpdate();
        }
    }

    public int findQuantity(int userId, int itemId) throws SQLException {
        String sql = "SELECT quantity FROM player_items WHERE user_id = ? AND item_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("quantity") : 0;
            }
        }
    }

    public List<OwnedItem> listOwned(int userId) throws SQLException {
        String sql = "SELECT item_id, quantity FROM player_items WHERE user_id = ? AND quantity > 0 ORDER BY item_id";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<OwnedItem> out = new ArrayList<>();
                while (rs.next()) out.add(new OwnedItem(rs.getInt("item_id"), rs.getInt("quantity")));
                return out;
            }
        }
    }
}
