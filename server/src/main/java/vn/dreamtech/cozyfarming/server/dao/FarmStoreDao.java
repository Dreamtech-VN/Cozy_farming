package vn.dreamtech.cozyfarming.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Kho nông trại — bảng THÊM MỚI {@code farm_store}, khớp đúng
 * {@code FarmStore} client ({@code src/systems/farmstore.ts}): 4 ngăn riêng
 * hạt giống/nông sản/phân bón/cá, mỗi ngăn là map id -> số lượng. Server Lttt
 * gốc lưu trong file save nhị phân, không phải bảng SQL. DDL:
 * <pre>
 * CREATE TABLE farm_store (
 *   user_id INT NOT NULL, kind VARCHAR(10) NOT NULL, item_id VARCHAR(60) NOT NULL,
 *   qty INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, kind, item_id)
 * );
 * </pre>
 * {@code kind} chỉ nhận 4 giá trị: seeds/produce/fert/fish — khớp đúng
 * {@code StoreKind} client, KHÔNG dùng bảng phụ vì đây chỉ là 4 hằng cố định.
 */
public final class FarmStoreDao {
    private final DataSource dataSource;

    public FarmStoreDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public int countOf(int userId, String kind, String itemId) throws SQLException {
        String sql = "SELECT qty FROM farm_store WHERE user_id = ? AND kind = ? AND item_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, kind);
            ps.setString(3, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("qty") : 0;
            }
        }
    }

    /** Cộng {@code delta} (âm để trừ) — xóa hẳn dòng nếu về 0 hoặc âm, khớp {@code addTo()} client. */
    public void addTo(int userId, String kind, String itemId, int delta) throws SQLException {
        int next = countOf(userId, kind, itemId) + delta;
        try (Connection c = dataSource.getConnection()) {
            if (next <= 0) {
                try (PreparedStatement del = c.prepareStatement(
                        "DELETE FROM farm_store WHERE user_id = ? AND kind = ? AND item_id = ?")) {
                    del.setInt(1, userId);
                    del.setString(2, kind);
                    del.setString(3, itemId);
                    del.executeUpdate();
                }
                return;
            }
            try (PreparedStatement ps = c.prepareStatement(
                    "MERGE INTO farm_store (user_id, kind, item_id, qty) KEY (user_id, kind, item_id) VALUES (?, ?, ?, ?)")) {
                ps.setInt(1, userId);
                ps.setString(2, kind);
                ps.setString(3, itemId);
                ps.setInt(4, next);
                ps.executeUpdate();
            }
        }
    }

    /** Trừ {@code n}, thất bại (không trừ gì) nếu không đủ — khớp {@code takeFrom()} client. */
    public boolean takeFrom(int userId, String kind, String itemId, int n) throws SQLException {
        if (countOf(userId, kind, itemId) < n) return false;
        addTo(userId, kind, itemId, -n);
        return true;
    }

    public Map<String, Integer> listOf(int userId, String kind) throws SQLException {
        String sql = "SELECT item_id, qty FROM farm_store WHERE user_id = ? AND kind = ? AND qty > 0 ORDER BY item_id";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, kind);
            try (ResultSet rs = ps.executeQuery()) {
                Map<String, Integer> out = new LinkedHashMap<>();
                while (rs.next()) out.put(rs.getString("item_id"), rs.getInt("qty"));
                return out;
            }
        }
    }
}
