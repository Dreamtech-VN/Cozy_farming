package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.model.Guild;

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
 * Bảng {@code guilds} — DDL:
 * <pre>
 * CREATE TABLE guilds (
 *   id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(30) NOT NULL UNIQUE, tag VARCHAR(6) NOT NULL UNIQUE,
 *   description VARCHAR(200), leader_user_id INT NOT NULL, created_at TIMESTAMP NOT NULL
 * );
 * </pre>
 */
public final class GuildDao {
    private final DataSource dataSource;

    public GuildDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public Guild create(String name, String tag, String description, int leaderUserId) throws SQLException {
        String sql = "INSERT INTO guilds (name, tag, description, leader_user_id, created_at) VALUES (?, ?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.setString(2, tag);
            ps.setString(3, description);
            ps.setInt(4, leaderUserId);
            long now = System.currentTimeMillis();
            ps.setTimestamp(5, new Timestamp(now));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                int id = keys.getInt(1);
                return new Guild(id, name, tag, description, leaderUserId, now);
            }
        }
    }

    public Optional<Guild> findById(int id) throws SQLException {
        String sql = "SELECT id, name, tag, description, leader_user_id, created_at FROM guilds WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    public boolean nameTaken(String name) throws SQLException {
        return existsBy("name", name);
    }

    public boolean tagTaken(String tag) throws SQLException {
        return existsBy("tag", tag);
    }

    private boolean existsBy(String column, String value) throws SQLException {
        String sql = "SELECT 1 FROM guilds WHERE " + column + " = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, value);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void updateLeader(int guildId, int newLeaderUserId) throws SQLException {
        String sql = "UPDATE guilds SET leader_user_id = ? WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, newLeaderUserId);
            ps.setInt(2, guildId);
            ps.executeUpdate();
        }
    }

    public void delete(int guildId) throws SQLException {
        String sql = "DELETE FROM guilds WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, guildId);
            ps.executeUpdate();
        }
    }

    public List<Guild> listAll() throws SQLException {
        String sql = "SELECT id, name, tag, description, leader_user_id, created_at FROM guilds ORDER BY id";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Guild> guilds = new ArrayList<>();
            while (rs.next()) guilds.add(map(rs));
            return guilds;
        }
    }

    private static Guild map(ResultSet rs) throws SQLException {
        return new Guild(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("tag"),
                rs.getString("description"),
                rs.getInt("leader_user_id"),
                rs.getTimestamp("created_at").getTime()
        );
    }
}
