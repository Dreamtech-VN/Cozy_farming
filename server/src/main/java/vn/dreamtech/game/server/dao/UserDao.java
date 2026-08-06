package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.model.User;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;

/**
 * Bảng {@code users} — DDL:
 * <pre>
 * CREATE TABLE users (
 *   id INT AUTO_INCREMENT PRIMARY KEY,
 *   username VARCHAR(50) UNIQUE,
 *   password_hash VARCHAR(255),
 *   guest_token VARCHAR(64) UNIQUE,
 *   google_id VARCHAR(128) UNIQUE,
 *   apple_id VARCHAR(128) UNIQUE,
 *   display_name VARCHAR(50),
 *   created_at TIMESTAMP NOT NULL
 * );
 * </pre>
 * Tất cả cột định danh (username/guest_token/google_id/apple_id) đều NULL
 * được vì 1 user có thể chỉ có 1 trong số đó lúc mới tạo, rồi liên kết thêm
 * dần — UNIQUE trên NULL không xung đột (MySQL/H2 đều cho nhiều NULL).
 */
public final class UserDao {
    private final DataSource dataSource;

    public UserDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    private static final String SELECT_COLUMNS =
            "id, username, password_hash, guest_token, google_id, apple_id, display_name";

    public Optional<User> findById(int id) throws SQLException {
        return findOneBy("id", id);
    }

    public Optional<User> findByUsername(String username) throws SQLException {
        return findOneBy("username", username);
    }

    public Optional<User> findByGuestToken(String guestToken) throws SQLException {
        return findOneBy("guest_token", guestToken);
    }

    public Optional<User> findByGoogleId(String googleId) throws SQLException {
        return findOneBy("google_id", googleId);
    }

    public Optional<User> findByAppleId(String appleId) throws SQLException {
        return findOneBy("apple_id", appleId);
    }

    private Optional<User> findOneBy(String column, Object value) throws SQLException {
        String sql = "SELECT " + SELECT_COLUMNS + " FROM users WHERE " + column + " = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setObject(1, value);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    public User createGuest(String guestToken) throws SQLException {
        String sql = "INSERT INTO users (guest_token, created_at) VALUES (?, ?)";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, guestToken);
            ps.setTimestamp(2, Timestamp.from(java.time.Instant.now()));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                int id = keys.getInt(1);
                return new User(id, null, null, guestToken, null, null, null);
            }
        }
    }

    public User createReal(String username, String passwordHash, String displayName) throws SQLException {
        String sql = "INSERT INTO users (username, password_hash, display_name, created_at) VALUES (?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, username);
            ps.setString(2, passwordHash);
            ps.setString(3, displayName);
            ps.setTimestamp(4, Timestamp.from(java.time.Instant.now()));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                int id = keys.getInt(1);
                return new User(id, username, passwordHash, null, null, null, displayName);
            }
        }
    }

    /** Khách nâng cấp lên tài khoản thường — gắn username/password vào ĐÚNG user id đó, giữ nguyên tiến trình chơi. */
    public void upgradeGuestToReal(int userId, String username, String passwordHash, String displayName) throws SQLException {
        String sql = "UPDATE users SET username = ?, password_hash = ?, display_name = ? WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, passwordHash);
            ps.setString(3, displayName);
            ps.setInt(4, userId);
            ps.executeUpdate();
        }
    }

    public void linkGoogle(int userId, String googleId) throws SQLException {
        linkColumn(userId, "google_id", googleId);
    }

    public void linkApple(int userId, String appleId) throws SQLException {
        linkColumn(userId, "apple_id", appleId);
    }

    private void linkColumn(int userId, String column, String value) throws SQLException {
        String sql = "UPDATE users SET " + column + " = ? WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, value);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public void updatePassword(int userId, String newHash) throws SQLException {
        String sql = "UPDATE users SET password_hash = ? WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public void delete(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    private static User map(ResultSet rs) throws SQLException {
        return new User(
                rs.getInt("id"),
                rs.getString("username"),
                rs.getString("password_hash"),
                rs.getString("guest_token"),
                rs.getString("google_id"),
                rs.getString("apple_id"),
                rs.getString("display_name")
        );
    }
}
