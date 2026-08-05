package vn.dreamtech.cozyfarming.server.dao;

import vn.dreamtech.cozyfarming.server.model.Animal;

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
 * Bảng THÊM MỚI {@code animals} (server Lttt gốc lưu vật nuôi trong file save
 * nhị phân riêng, không phải bảng SQL). DDL:
 * <pre>
 * CREATE TABLE animals (
 *   id VARCHAR(40) NOT NULL PRIMARY KEY, user_id INT NOT NULL, type VARCHAR(20) NOT NULL,
 *   bought_at TIMESTAMP NOT NULL, fed_at TIMESTAMP NOT NULL, collected_at TIMESTAMP NOT NULL,
 *   health DOUBLE DEFAULT 100, sick TINYINT DEFAULT 0, health_at TIMESTAMP
 * );
 * </pre>
 */
public final class AnimalDao {
    private final DataSource dataSource;

    public AnimalDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public List<Animal> findAllByUser(int userId) throws SQLException {
        String sql = "SELECT id, type, bought_at, fed_at, collected_at, health, sick, health_at "
                + "FROM animals WHERE user_id = ? ORDER BY bought_at";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Animal> out = new ArrayList<>();
                while (rs.next()) out.add(map(rs));
                return out;
            }
        }
    }

    public Optional<Animal> find(int userId, String id) throws SQLException {
        String sql = "SELECT id, type, bought_at, fed_at, collected_at, health, sick, health_at "
                + "FROM animals WHERE user_id = ? AND id = ?";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    public int countByUser(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM animals WHERE user_id = ?";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    public void upsert(int userId, Animal a) throws SQLException {
        String sql = "MERGE INTO animals (id, user_id, type, bought_at, fed_at, collected_at, health, "
                + "sick, health_at) KEY (id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, a.id());
            ps.setInt(2, userId);
            ps.setString(3, a.type());
            ps.setTimestamp(4, new Timestamp(a.boughtAt()));
            ps.setTimestamp(5, new Timestamp(a.fedAt()));
            ps.setTimestamp(6, new Timestamp(a.collectedAt()));
            ps.setDouble(7, a.health());
            ps.setInt(8, a.sick() ? 1 : 0);
            ps.setTimestamp(9, a.healthAt() == null ? null : new Timestamp(a.healthAt()));
            ps.executeUpdate();
        }
    }

    public void delete(int userId, String id) throws SQLException {
        String sql = "DELETE FROM animals WHERE user_id = ? AND id = ?";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, id);
            ps.executeUpdate();
        }
    }

    private static Animal map(ResultSet rs) throws SQLException {
        Timestamp healthAt = rs.getTimestamp("health_at");
        return new Animal(
                rs.getString("id"),
                rs.getString("type"),
                rs.getTimestamp("bought_at").getTime(),
                rs.getTimestamp("fed_at").getTime(),
                rs.getTimestamp("collected_at").getTime(),
                rs.getDouble("health"),
                rs.getInt("sick") != 0,
                healthAt == null ? null : healthAt.getTime()
        );
    }
}
