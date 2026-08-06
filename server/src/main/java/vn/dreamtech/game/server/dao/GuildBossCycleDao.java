package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;

/**
 * Bảng {@code guild_boss_cycles} — DDL:
 * <pre>
 * CREATE TABLE guild_boss_cycles (
 *   guild_id INT NOT NULL PRIMARY KEY, remaining_hp INT NOT NULL,
 *   cycle_started_at TIMESTAMP NOT NULL, cycle_ends_at TIMESTAMP NOT NULL
 * );
 * </pre>
 * Không có cron reset — {@code GuildBossService} tự phát hiện chu kỳ đã hết
 * hạn (now > cycle_ends_at) và tạo chu kỳ mới NGAY khi có request tiếp theo
 * (lazy reset), khớp cách server này chưa có background job nào.
 */
public final class GuildBossCycleDao {
    private final DataSource dataSource;

    public GuildBossCycleDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public record Cycle(int guildId, int remainingHp, long cycleStartedAt, long cycleEndsAt) {
    }

    public Optional<Cycle> find(int guildId) throws SQLException {
        String sql = "SELECT guild_id, remaining_hp, cycle_started_at, cycle_ends_at FROM guild_boss_cycles WHERE guild_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, guildId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();
                return Optional.of(new Cycle(
                        rs.getInt("guild_id"),
                        rs.getInt("remaining_hp"),
                        rs.getTimestamp("cycle_started_at").getTime(),
                        rs.getTimestamp("cycle_ends_at").getTime()
                ));
            }
        }
    }

    public void save(Cycle cycle) throws SQLException {
        String sql = "MERGE INTO guild_boss_cycles (guild_id, remaining_hp, cycle_started_at, cycle_ends_at) KEY (guild_id) VALUES (?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, cycle.guildId());
            ps.setInt(2, cycle.remainingHp());
            ps.setTimestamp(3, new Timestamp(cycle.cycleStartedAt()));
            ps.setTimestamp(4, new Timestamp(cycle.cycleEndsAt()));
            ps.executeUpdate();
        }
    }
}
