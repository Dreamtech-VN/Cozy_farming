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
 * Bảng {@code guild_boss_contributions} — DDL:
 * <pre>
 * CREATE TABLE guild_boss_contributions (
 *   guild_id INT NOT NULL, user_id INT NOT NULL, cycle_started_at TIMESTAMP NOT NULL,
 *   total_damage INT NOT NULL DEFAULT 0, PRIMARY KEY (guild_id, user_id, cycle_started_at)
 * );
 * </pre>
 * Đóng góp sát thương của từng thành viên trong 1 chu kỳ trùm — hiển thị
 * "ai đóng góp nhiều nhất" cho guild, KHÔNG dùng để tính thưởng (thưởng
 * phát ngay lúc report, xem {@code GuildBossService}).
 */
public final class GuildBossContributionDao {
    private final DataSource dataSource;

    public GuildBossContributionDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public record Contribution(int guildId, int userId, long cycleStartedAt, int totalDamage) {
    }

    public void addDamage(int guildId, int userId, long cycleStartedAt, int damage) throws SQLException {
        String selectSql = "SELECT total_damage FROM guild_boss_contributions WHERE guild_id = ? AND user_id = ? AND cycle_started_at = ?";
        int current = 0;
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(selectSql)) {
            ps.setInt(1, guildId);
            ps.setInt(2, userId);
            ps.setTimestamp(3, new Timestamp(cycleStartedAt));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) current = rs.getInt("total_damage");
            }
        }
        String mergeSql = "MERGE INTO guild_boss_contributions (guild_id, user_id, cycle_started_at, total_damage) " +
                "KEY (guild_id, user_id, cycle_started_at) VALUES (?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(mergeSql)) {
            ps.setInt(1, guildId);
            ps.setInt(2, userId);
            ps.setTimestamp(3, new Timestamp(cycleStartedAt));
            ps.setInt(4, current + damage);
            ps.executeUpdate();
        }
    }

    public List<Contribution> listByCycle(int guildId, long cycleStartedAt) throws SQLException {
        String sql = "SELECT guild_id, user_id, cycle_started_at, total_damage FROM guild_boss_contributions " +
                "WHERE guild_id = ? AND cycle_started_at = ? ORDER BY total_damage DESC";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, guildId);
            ps.setTimestamp(2, new Timestamp(cycleStartedAt));
            try (ResultSet rs = ps.executeQuery()) {
                List<Contribution> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(new Contribution(rs.getInt("guild_id"), rs.getInt("user_id"),
                            rs.getTimestamp("cycle_started_at").getTime(), rs.getInt("total_damage")));
                }
                return list;
            }
        }
    }
}
