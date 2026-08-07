package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.model.Character;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;

/**
 * Bảng {@code characters} — DDL:
 * <pre>
 * CREATE TABLE characters (
 *   user_id INT NOT NULL PRIMARY KEY, name VARCHAR(20) NOT NULL UNIQUE, gender TINYINT NOT NULL,
 *   hair_id INT NOT NULL, top_id INT NOT NULL, bottom_id INT NOT NULL, created_at TIMESTAMP NOT NULL
 * );
 * </pre>
 * 1 user chỉ 1 nhân vật (PK trên {@code user_id}).
 */
public final class CharacterDao {
    private final DataSource dataSource;

    public CharacterDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public Optional<Character> findByUserId(int userId) throws SQLException {
        String sql = "SELECT user_id, name, gender, hair_id, top_id, bottom_id FROM characters WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    public boolean nameTaken(String name) throws SQLException {
        String sql = "SELECT 1 FROM characters WHERE name = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void create(Character ch) throws SQLException {
        String sql = "INSERT INTO characters (user_id, name, gender, hair_id, top_id, bottom_id, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, ch.userId());
            ps.setString(2, ch.name());
            ps.setInt(3, ch.gender());
            ps.setInt(4, ch.hairId());
            ps.setInt(5, ch.topId());
            ps.setInt(6, ch.bottomId());
            ps.setTimestamp(7, Timestamp.from(java.time.Instant.now()));
            ps.executeUpdate();
        }
    }

    /** Admin đổi tên nhân vật (kiểm duyệt tên vi phạm) — trả về false nếu user không tồn tại/chưa tạo nhân vật. */
    public boolean rename(int userId, String newName) throws SQLException {
        String sql = "UPDATE characters SET name = ? WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, newName);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public void updateOutfit(int userId, int hairId, int topId, int bottomId) throws SQLException {
        String sql = "UPDATE characters SET hair_id = ?, top_id = ?, bottom_id = ? WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, hairId);
            ps.setInt(2, topId);
            ps.setInt(3, bottomId);
            ps.setInt(4, userId);
            ps.executeUpdate();
        }
    }

    private static Character map(ResultSet rs) throws SQLException {
        return new Character(
                rs.getInt("user_id"),
                rs.getString("name"),
                rs.getInt("gender"),
                rs.getInt("hair_id"),
                rs.getInt("top_id"),
                rs.getInt("bottom_id")
        );
    }
}
