package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;

/**
 * Bảng {@code world_boss_cycle} — DDL:
 * <pre>
 * CREATE TABLE world_boss_cycle (
 *   id INT NOT NULL PRIMARY KEY, remaining_hp INT NOT NULL,
 *   cycle_started_at TIMESTAMP NOT NULL, cycle_ends_at TIMESTAMP NOT NULL
 * );
 * </pre>
 * CHỈ 1 dòng duy nhất ({@code id = 1}) — trùm thế giới dùng chung 1 HP cho
 * TOÀN SERVER, khác {@code guild_boss_cycles} có 1 dòng/guild. Không cron
 * reset, giống {@code GuildBossCycleDao} — tự phát hiện hết hạn lúc có
 * request tiếp theo.
 */
public final class WorldBossCycleDao {
    private static final int SINGLETON_ID = 1;
    private final DataSource dataSource;

    public WorldBossCycleDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public record Cycle(int remainingHp, long cycleStartedAt, long cycleEndsAt) {
    }

    public Optional<Cycle> find() throws SQLException {
        String sql = "SELECT remaining_hp, cycle_started_at, cycle_ends_at FROM world_boss_cycle WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, SINGLETON_ID);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();
                return Optional.of(new Cycle(
                        rs.getInt("remaining_hp"),
                        rs.getTimestamp("cycle_started_at").getTime(),
                        rs.getTimestamp("cycle_ends_at").getTime()
                ));
            }
        }
    }

    public void save(Cycle cycle) throws SQLException {
        String sql = "MERGE INTO world_boss_cycle (id, remaining_hp, cycle_started_at, cycle_ends_at) KEY (id) VALUES (?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, SINGLETON_ID);
            ps.setInt(2, cycle.remainingHp());
            ps.setTimestamp(3, new Timestamp(cycle.cycleStartedAt()));
            ps.setTimestamp(4, new Timestamp(cycle.cycleEndsAt()));
            ps.executeUpdate();
        }
    }
}
