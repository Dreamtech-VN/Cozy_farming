package vn.dreamtech.cozyfarming.server.dao;

import vn.dreamtech.cozyfarming.server.model.Item;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/** DAO đầu tiên — bảng {@code items}, nền cho tủ đồ nhân vật (tóc/áo/quần/kính/đồ cầm tay). */
public final class ItemDao {
    private final DataSource dataSource;

    public ItemDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public Optional<Item> findById(int id) throws SQLException {
        String sql = "SELECT id, coin, gold, type, icon, name, sell, expired_day, zorder, gender, level, animation "
                + "FROM items WHERE id = ?";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    /** Lấy trang bị theo zorder (10/20/40/50/60/70) + giới tính (0=unisex, 1=nam, 2=nữ). */
    public List<Item> findByZorderAndGender(int zorder, int gender) throws SQLException {
        String sql = "SELECT id, coin, gold, type, icon, name, sell, expired_day, zorder, gender, level, animation "
                + "FROM items WHERE zorder = ? AND (gender = ? OR gender = 0) ORDER BY id";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, zorder);
            ps.setInt(2, gender);
            try (ResultSet rs = ps.executeQuery()) {
                List<Item> out = new ArrayList<>();
                while (rs.next()) out.add(map(rs));
                return out;
            }
        }
    }

    private static Item map(ResultSet rs) throws SQLException {
        return new Item(
                rs.getInt("id"),
                rs.getInt("coin"),
                rs.getInt("gold"),
                rs.getInt("type"),
                rs.getInt("icon"),
                rs.getString("name"),
                rs.getInt("sell"),
                rs.getInt("expired_day"),
                rs.getInt("zorder"),
                rs.getInt("gender"),
                rs.getInt("level"),
                rs.getString("animation")
        );
    }
}
