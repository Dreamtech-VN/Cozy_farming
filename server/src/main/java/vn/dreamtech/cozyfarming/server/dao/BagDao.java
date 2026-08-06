package vn.dreamtech.cozyfarming.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Túi đồ — bảng THÊM MỚI {@code bag_items}, khớp {@code S.inventory} client
 * ({@code src/core/save.ts}'s {@code addItem}/{@code itemCount}/{@code
 * removeItem}): đồ dùng/quà/nguyên liệu KHÔNG thuộc kho nông trại (hạt
 * giống/nông sản/phân bón/cá đã có {@link FarmStoreDao} riêng — client tự
 * định tuyến qua {@code storeSlotOf()}, ở đây các handler gọi thẳng DAO đúng
 * theo ngữ cảnh, không cần định tuyến lại). DDL:
 * <pre>
 * CREATE TABLE bag_items (
 *   user_id INT NOT NULL, item_id VARCHAR(60) NOT NULL, qty INT NOT NULL DEFAULT 0,
 *   PRIMARY KEY (user_id, item_id)
 * );
 * </pre>
 */
public final class BagDao {
    private final DataSource dataSource;

    public BagDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public int countOf(int userId, String itemId) throws SQLException {
        String sql = "SELECT qty FROM bag_items WHERE user_id = ? AND item_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("qty") : 0;
            }
        }
    }

    public void addTo(int userId, String itemId, int delta) throws SQLException {
        int next = countOf(userId, itemId) + delta;
        try (Connection c = dataSource.getConnection()) {
            if (next <= 0) {
                try (PreparedStatement del = c.prepareStatement(
                        "DELETE FROM bag_items WHERE user_id = ? AND item_id = ?")) {
                    del.setInt(1, userId);
                    del.setString(2, itemId);
                    del.executeUpdate();
                }
                return;
            }
            try (PreparedStatement ps = c.prepareStatement(
                    "MERGE INTO bag_items (user_id, item_id, qty) KEY (user_id, item_id) VALUES (?, ?, ?)")) {
                ps.setInt(1, userId);
                ps.setString(2, itemId);
                ps.setInt(3, next);
                ps.executeUpdate();
            }
        }
    }

    public boolean takeFrom(int userId, String itemId, int n) throws SQLException {
        if (countOf(userId, itemId) < n) return false;
        addTo(userId, itemId, -n);
        return true;
    }

    public Map<String, Integer> listAll(int userId) throws SQLException {
        String sql = "SELECT item_id, qty FROM bag_items WHERE user_id = ? AND qty > 0 ORDER BY item_id";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                Map<String, Integer> out = new LinkedHashMap<>();
                while (rs.next()) out.put(rs.getString("item_id"), rs.getInt("qty"));
                return out;
            }
        }
    }
}
