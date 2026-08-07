package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.item.ItemCategory;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Bảng {@code items} — DDL:
 * <pre>
 * CREATE TABLE items (
 *   id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL, category VARCHAR(20) NOT NULL,
 *   ref_id INT, description VARCHAR(500)
 * );
 * </pre>
 * "Kho item" admin quản lý — mọi phần thưởng (giftcode/thư/sự kiện) đều trỏ
 * vào đây qua {@code itemId} thay vì định nghĩa lại phần thưởng ở từng nơi.
 * {@code category} quyết định cách cấp phát khi claim (xem
 * {@code RewardGrantService}): GOLD/DIAMOND/EXP cấp thẳng vào ví/exp,
 * COSMETIC cấp qua {@code refId} (id trong {@code CosmeticCatalog} có sẵn),
 * MATERIAL cấp vào kho đồ chung {@code player_items} (chưa có công dụng cụ
 * thể — dành cho vật phẩm dùng sau này, vd. chế tạo/nhiệm vụ).
 */
public final class ItemDao {
    private final DataSource dataSource;

    public ItemDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public record Item(int id, String name, ItemCategory category, Integer refId, String description) {
    }

    public Item create(String name, ItemCategory category, Integer refId, String description) throws SQLException {
        String sql = "INSERT INTO items (name, category, ref_id, description) VALUES (?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.setString(2, category.name());
            if (refId == null) ps.setNull(3, Types.INTEGER); else ps.setInt(3, refId);
            ps.setString(4, description);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                return new Item(keys.getInt(1), name, category, refId, description);
            }
        }
    }

    public void update(int id, String name, ItemCategory category, Integer refId, String description) throws SQLException {
        String sql = "UPDATE items SET name = ?, category = ?, ref_id = ?, description = ? WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, category.name());
            if (refId == null) ps.setNull(3, Types.INTEGER); else ps.setInt(3, refId);
            ps.setString(4, description);
            ps.setInt(5, id);
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM items WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public Optional<Item> find(int id) throws SQLException {
        String sql = "SELECT id, name, category, ref_id, description FROM items WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    public List<Item> findAll() throws SQLException {
        String sql = "SELECT id, name, category, ref_id, description FROM items ORDER BY id";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Item> out = new ArrayList<>();
            while (rs.next()) out.add(map(rs));
            return out;
        }
    }

    private static Item map(ResultSet rs) throws SQLException {
        int refId = rs.getInt("ref_id");
        Integer refIdBoxed = rs.wasNull() ? null : refId;
        return new Item(rs.getInt("id"), rs.getString("name"), ItemCategory.valueOf(rs.getString("category")),
                refIdBoxed, rs.getString("description"));
    }
}
