package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;

/**
 * Bảng {@code guild_wars} — DDL:
 * <pre>
 * CREATE TABLE guild_wars (
 *   id VARCHAR(36) NOT NULL PRIMARY KEY, guild_a INT NOT NULL, guild_b INT NOT NULL,
 *   score_a INT NOT NULL DEFAULT 0, score_b INT NOT NULL DEFAULT 0, status VARCHAR(10) NOT NULL,
 *   started_at TIMESTAMP NOT NULL, ends_at TIMESTAMP NOT NULL, winner_guild_id INT
 * );
 * </pre>
 */
public final class GuildWarDao {
    private final DataSource dataSource;

    public GuildWarDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public record War(String id, int guildA, int guildB, int scoreA, int scoreB, String status,
                       long startedAt, long endsAt, Integer winnerGuildId) {
    }

    public void create(War war) throws SQLException {
        String sql = "INSERT INTO guild_wars (id, guild_a, guild_b, score_a, score_b, status, started_at, ends_at, winner_guild_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            bind(ps, war);
            ps.executeUpdate();
        }
    }

    public void save(War war) throws SQLException {
        String sql = "MERGE INTO guild_wars (id, guild_a, guild_b, score_a, score_b, status, started_at, ends_at, winner_guild_id) " +
                "KEY (id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            bind(ps, war);
            ps.executeUpdate();
        }
    }

    private void bind(PreparedStatement ps, War war) throws SQLException {
        ps.setString(1, war.id());
        ps.setInt(2, war.guildA());
        ps.setInt(3, war.guildB());
        ps.setInt(4, war.scoreA());
        ps.setInt(5, war.scoreB());
        ps.setString(6, war.status());
        ps.setTimestamp(7, new Timestamp(war.startedAt()));
        ps.setTimestamp(8, new Timestamp(war.endsAt()));
        if (war.winnerGuildId() == null) {
            ps.setNull(9, java.sql.Types.INTEGER);
        } else {
            ps.setInt(9, war.winnerGuildId());
        }
    }

    public Optional<War> find(String id) throws SQLException {
        String sql = "SELECT * FROM guild_wars WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    /** Chiến tranh ONGOING gần nhất mà guild này đang tham gia (là guildA hoặc guildB). */
    public Optional<War> findActiveByGuild(int guildId) throws SQLException {
        String sql = "SELECT * FROM guild_wars WHERE (guild_a = ? OR guild_b = ?) AND status = 'ONGOING' ORDER BY started_at DESC LIMIT 1";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, guildId);
            ps.setInt(2, guildId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    /** Chiến tranh gần nhất (bất kể trạng thái) mà guild này tham gia — dùng để hiện kết quả sau khi đã kết thúc. */
    public Optional<War> findLatestByGuild(int guildId) throws SQLException {
        String sql = "SELECT * FROM guild_wars WHERE (guild_a = ? OR guild_b = ?) ORDER BY started_at DESC LIMIT 1";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, guildId);
            ps.setInt(2, guildId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    private static War map(ResultSet rs) throws SQLException {
        int winner = rs.getInt("winner_guild_id");
        Integer winnerGuildId = rs.wasNull() ? null : winner;
        return new War(
                rs.getString("id"), rs.getInt("guild_a"), rs.getInt("guild_b"),
                rs.getInt("score_a"), rs.getInt("score_b"), rs.getString("status"),
                rs.getTimestamp("started_at").getTime(), rs.getTimestamp("ends_at").getTime(), winnerGuildId
        );
    }
}
