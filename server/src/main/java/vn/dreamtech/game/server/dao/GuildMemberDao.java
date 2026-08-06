package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.model.GuildMembership;
import vn.dreamtech.game.server.model.GuildRole;

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
 * Bảng {@code guild_members} — DDL:
 * <pre>
 * CREATE TABLE guild_members (
 *   user_id INT NOT NULL PRIMARY KEY, guild_id INT NOT NULL, role VARCHAR(10) NOT NULL, joined_at TIMESTAMP NOT NULL
 * );
 * </pre>
 * PK trên {@code user_id} — 1 user chỉ ở ĐÚNG 1 guild tại một thời điểm
 * (giống {@code characters}, 1 user 1 nhân vật).
 */
public final class GuildMemberDao {
    private final DataSource dataSource;

    public GuildMemberDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public void join(int userId, int guildId, GuildRole role) throws SQLException {
        String sql = "INSERT INTO guild_members (user_id, guild_id, role, joined_at) VALUES (?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, guildId);
            ps.setString(3, role.name());
            ps.setTimestamp(4, Timestamp.from(java.time.Instant.now()));
            ps.executeUpdate();
        }
    }

    public void leave(int userId) throws SQLException {
        String sql = "DELETE FROM guild_members WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    public void leaveGuild(int guildId) throws SQLException {
        String sql = "DELETE FROM guild_members WHERE guild_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, guildId);
            ps.executeUpdate();
        }
    }

    public Optional<GuildMembership> findByUserId(int userId) throws SQLException {
        String sql = "SELECT user_id, guild_id, role, joined_at FROM guild_members WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    public List<GuildMembership> listByGuild(int guildId) throws SQLException {
        String sql = "SELECT user_id, guild_id, role, joined_at FROM guild_members WHERE guild_id = ? ORDER BY joined_at";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, guildId);
            try (ResultSet rs = ps.executeQuery()) {
                List<GuildMembership> members = new ArrayList<>();
                while (rs.next()) members.add(map(rs));
                return members;
            }
        }
    }

    public int countMembers(int guildId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM guild_members WHERE guild_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, guildId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    public void updateRole(int userId, GuildRole role) throws SQLException {
        String sql = "UPDATE guild_members SET role = ? WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, role.name());
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    private static GuildMembership map(ResultSet rs) throws SQLException {
        return new GuildMembership(
                rs.getInt("user_id"),
                rs.getInt("guild_id"),
                GuildRole.valueOf(rs.getString("role")),
                rs.getTimestamp("joined_at").getTime()
        );
    }
}
