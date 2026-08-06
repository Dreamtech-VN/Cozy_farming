package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.model.PasswordReset;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.Optional;

/**
 * Bảng {@code password_resets} — DDL:
 * <pre>
 * CREATE TABLE password_resets (
 *   user_id INT NOT NULL PRIMARY KEY, code_hash VARCHAR(255) NOT NULL, expires_at TIMESTAMP NOT NULL
 * );
 * </pre>
 */
public final class PasswordResetDao {
    private final DataSource dataSource;

    public PasswordResetDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public void upsert(PasswordReset reset) throws SQLException {
        String sql = "MERGE INTO password_resets (user_id, code_hash, expires_at) KEY (user_id) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, reset.userId());
            ps.setString(2, reset.codeHash());
            ps.setTimestamp(3, Timestamp.from(reset.expiresAt()));
            ps.executeUpdate();
        }
    }

    public Optional<PasswordReset> find(int userId) throws SQLException {
        String sql = "SELECT user_id, code_hash, expires_at FROM password_resets WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();
                return Optional.of(new PasswordReset(rs.getInt("user_id"), rs.getString("code_hash"),
                        rs.getTimestamp("expires_at").toInstant()));
            }
        }
    }

    public void delete(int userId) throws SQLException {
        String sql = "DELETE FROM password_resets WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }
}
