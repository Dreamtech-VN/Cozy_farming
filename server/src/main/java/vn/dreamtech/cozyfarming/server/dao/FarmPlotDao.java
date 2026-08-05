package vn.dreamtech.cozyfarming.server.dao;

import vn.dreamtech.cozyfarming.server.model.FarmPlot;

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
 * Bảng THÊM MỚI {@code farm_plots} (không có trong schema thật gốc — server
 * gốc Lttt lưu đất theo cơ chế khác trong file save nhị phân, không có bảng
 * SQL riêng cho từng ô). DDL:
 * <pre>
 * CREATE TABLE farm_plots (
 *   user_id INT NOT NULL, idx INT NOT NULL, state VARCHAR(10) NOT NULL,
 *   crop_id VARCHAR(30), planted_at TIMESTAMP, watered TINYINT DEFAULT 0,
 *   watered_at TIMESTAMP, fertilized TINYINT DEFAULT 0, health INT DEFAULT 100,
 *   PRIMARY KEY (user_id, idx)
 * );
 * </pre>
 */
public final class FarmPlotDao {
    private final DataSource dataSource;

    public FarmPlotDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public List<FarmPlot> findAll(int userId) throws SQLException {
        String sql = "SELECT idx, state, crop_id, planted_at, watered, watered_at, fertilized, health "
                + "FROM farm_plots WHERE user_id = ? ORDER BY idx";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<FarmPlot> out = new ArrayList<>();
                while (rs.next()) out.add(map(rs));
                return out;
            }
        }
    }

    public Optional<FarmPlot> find(int userId, int index) throws SQLException {
        String sql = "SELECT idx, state, crop_id, planted_at, watered, watered_at, fertilized, health "
                + "FROM farm_plots WHERE user_id = ? AND idx = ?";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, index);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    public void upsert(int userId, FarmPlot plot) throws SQLException {
        String sql = "MERGE INTO farm_plots (user_id, idx, state, crop_id, planted_at, watered, "
                + "watered_at, fertilized, health) KEY (user_id, idx) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, plot.index());
            ps.setString(3, plot.state());
            ps.setString(4, plot.cropId());
            ps.setTimestamp(5, plot.plantedAt() == null ? null : new Timestamp(plot.plantedAt()));
            ps.setInt(6, plot.watered() ? 1 : 0);
            ps.setTimestamp(7, plot.wateredAt() == null ? null : new Timestamp(plot.wateredAt()));
            ps.setInt(8, plot.fertilized() ? 1 : 0);
            ps.setInt(9, plot.health());
            ps.executeUpdate();
        }
    }

    private static FarmPlot map(ResultSet rs) throws SQLException {
        Timestamp planted = rs.getTimestamp("planted_at");
        Timestamp watered = rs.getTimestamp("watered_at");
        return new FarmPlot(
                rs.getInt("idx"),
                rs.getString("state"),
                rs.getString("crop_id"),
                planted == null ? null : planted.getTime(),
                rs.getInt("watered") != 0,
                watered == null ? null : watered.getTime(),
                rs.getInt("fertilized") != 0,
                rs.getInt("health")
        );
    }
}
