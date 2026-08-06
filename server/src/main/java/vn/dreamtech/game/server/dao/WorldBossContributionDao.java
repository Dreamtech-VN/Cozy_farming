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
 * Bảng {@code world_boss_contributions} — DDL:
 * <pre>
 * CREATE TABLE world_boss_contributions (
 *   user_id INT NOT NULL, cycle_started_at TIMESTAMP NOT NULL, total_damage INT NOT NULL DEFAULT 0,
 *   PRIMARY KEY (user_id, cycle_started_at)
 * );
 * </pre>
 * Không có {@code guild_id} (khác {@code guild_boss_contributions}) vì
 * trùm thế giới không thuộc guild nào — đóng góp TOÀN SERVER.
 */
public final class WorldBossContributionDao {
    private final DataSource dataSource;

    public WorldBossContributionDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public record Contribution(int userId, long cycleStartedAt, int totalDamage) {
    }

    public void addDamage(int userId, long cycleStartedAt, int damage) throws SQLException {
        String selectSql = "SELECT total_damage FROM world_boss_contributions WHERE user_id = ? AND cycle_started_at = ?";
        int current = 0;
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(selectSql)) {
            ps.setInt(1, userId);
            ps.setTimestamp(2, new Timestamp(cycleStartedAt));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) current = rs.getInt("total_damage");
            }
        }
        String mergeSql = "MERGE INTO world_boss_contributions (user_id, cycle_started_at, total_damage) " +
                "KEY (user_id, cycle_started_at) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(mergeSql)) {
            ps.setInt(1, userId);
            ps.setTimestamp(2, new Timestamp(cycleStartedAt));
            ps.setInt(3, current + damage);
            ps.executeUpdate();
        }
    }

    public List<Contribution> listByCycle(long cycleStartedAt) throws SQLException {
        String sql = "SELECT user_id, cycle_started_at, total_damage FROM world_boss_contributions " +
                "WHERE cycle_started_at = ? ORDER BY total_damage DESC";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(cycleStartedAt));
            try (ResultSet rs = ps.executeQuery()) {
                List<Contribution> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(new Contribution(rs.getInt("user_id"), rs.getTimestamp("cycle_started_at").getTime(), rs.getInt("total_damage")));
                }
                return list;
            }
        }
    }
}
