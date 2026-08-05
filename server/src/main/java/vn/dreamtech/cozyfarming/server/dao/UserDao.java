package vn.dreamtech.cozyfarming.server.dao;

import vn.dreamtech.cozyfarming.server.model.User;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.Optional;

public final class UserDao {
    private final DataSource dataSource;

    public UserDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public Optional<User> findByUsername(String username) throws SQLException {
        String sql = "SELECT id, username, password, active, phone, gmail, vnd, tongnap, login_lock "
                + "FROM users WHERE username = ?";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    /** Tạo tài khoản mới, trả về id vừa tạo. Ném SQLException nếu username trùng (unique constraint). */
    public int create(String username, String passwordHash, String gmail) throws SQLException {
        String sql = "INSERT INTO users (username, password, role, active, phone, gmail, vnd, tongnap, "
                + "timeCreate, login_lock) VALUES (?, ?, -1, 1, '0', ?, 0, 0, ?, 0)";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, username);
            ps.setString(2, passwordHash);
            ps.setString(3, gmail == null ? "" : gmail);
            ps.setObject(4, LocalDate.now());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    public void updatePassword(int userId, String newPasswordHash) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    private static User map(ResultSet rs) throws SQLException {
        return new User(
                rs.getInt("id"),
                rs.getString("username"),
                rs.getString("password"),
                rs.getInt("active"),
                rs.getString("phone"),
                rs.getString("gmail"),
                rs.getInt("vnd"),
                rs.getInt("tongnap"),
                rs.getInt("login_lock") != 0
        );
    }
}
