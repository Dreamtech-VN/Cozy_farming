package vn.dreamtech.cozyfarming.server.dao;

import vn.dreamtech.cozyfarming.server.model.PondFish;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Bảng THÊM MỚI {@code pond_fish} (server Lttt gốc lưu ao cá trong file save
 * nhị phân, không phải bảng SQL — {@code FishFarm} kế thừa {@code AnimalDan}
 * nên cấu trúc lưu giống hệt vật nuôi trên cạn). DDL:
 * <pre>
 * CREATE TABLE pond_fish (
 *   id VARCHAR(40) NOT NULL PRIMARY KEY, user_id INT NOT NULL, type VARCHAR(20) NOT NULL,
 *   at TIMESTAMP NOT NULL, fed_at TIMESTAMP
 * );
 * </pre>
 */
public final class PondFishDao {
    private final DataSource dataSource;

    public PondFishDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public List<PondFish> findAllByUser(int userId) throws SQLException {
        String sql = "SELECT id, type, at, fed_at FROM pond_fish WHERE user_id = ? ORDER BY at";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<PondFish> out = new ArrayList<>();
                while (rs.next()) out.add(map(rs));
                return out;
            }
        }
    }

    public Optional<PondFish> find(int userId, String id) throws SQLException {
        String sql = "SELECT id, type, at, fed_at FROM pond_fish WHERE user_id = ? AND id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    public int countByUser(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM pond_fish WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    public void upsert(int userId, PondFish f) throws SQLException {
        String sql = "MERGE INTO pond_fish (id, user_id, type, at, fed_at) KEY (id) VALUES (?, ?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, f.id());
            ps.setInt(2, userId);
            ps.setString(3, f.type());
            ps.setTimestamp(4, new Timestamp(f.at()));
            ps.setTimestamp(5, f.fedAt() == null ? null : new Timestamp(f.fedAt()));
            ps.executeUpdate();
        }
    }

    public void delete(int userId, String id) throws SQLException {
        String sql = "DELETE FROM pond_fish WHERE user_id = ? AND id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, id);
            ps.executeUpdate();
        }
    }

    private static PondFish map(ResultSet rs) throws SQLException {
        Timestamp fedAt = rs.getTimestamp("fed_at");
        return new PondFish(
                rs.getString("id"),
                rs.getString("type"),
                rs.getTimestamp("at").getTime(),
                fedAt == null ? null : fedAt.getTime()
        );
    }
}
