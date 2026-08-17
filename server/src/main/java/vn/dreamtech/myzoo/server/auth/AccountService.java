package vn.dreamtech.myzoo.server.auth;

import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;
import vn.dreamtech.myzoo.server.time.TimeSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

public final class AccountService {
    private final DataSource dataSource;
    private final PlayerService players;
    private final TimeSource time;

    public AccountService(DataSource dataSource, PlayerService players, TimeSource time) {
        this.dataSource = dataSource;
        this.players = players;
        this.time = time;
    }

    public record AuthResult(int accountId, int playerId, String username, String sessionToken, String name,
                             String serverId, boolean needsCharacter) {
    }

    // Đăng ký (S03). Có guestToken => nâng cấp tài khoản khách, giữ nguyên tiến độ (S05 account link).
    public AuthResult register(String username, String password, String guestToken) {
        String user = validateUsername(username);
        validatePassword(password);

        int playerId;
        if (guestToken != null && !guestToken.isBlank()) {
            playerId = players.authenticate(guestToken);
            if (accountIdOf(playerId) != null) throw new ApiException(409, "Tài khoản này đã đăng ký rồi");
        } else {
            playerId = players.guestLogin(null).playerId();
        }

        String salt = PasswordHash.newSalt();
        int accountId;
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO accounts (username, password_hash, password_salt, created_at) VALUES (?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user);
            ps.setString(2, PasswordHash.hash(password, salt));
            ps.setString(3, salt);
            ps.setTimestamp(4, new Timestamp(time.now()));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                accountId = keys.getInt(1);
            }
        } catch (SQLException e) {
            throw new ApiException(409, "Tên đăng nhập đã tồn tại");
        }
        bindAccount(playerId, accountId);
        return result(accountId, playerId, user);
    }

    public AuthResult login(String username, String password) {
        String user = username == null ? "" : username.trim().toLowerCase();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT id, password_hash, password_salt, banned FROM accounts WHERE username = ?")) {
            ps.setString(1, user);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next() || !PasswordHash.matches(password == null ? "" : password,
                        rs.getString("password_salt"), rs.getString("password_hash"))) {
                    throw new ApiException(401, "Sai tên đăng nhập hoặc mật khẩu");
                }
                if (rs.getBoolean("banned")) throw new ApiException(403, "Tài khoản đã bị khoá");
                int accountId = rs.getInt("id");
                Integer playerId = playerIdOf(accountId);
                if (playerId == null) throw new ApiException(500, "Tài khoản chưa gắn nhân vật");
                return result(accountId, playerId, user);
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đăng nhập: " + e.getMessage());
        }
    }

    // Đổi mật khẩu — thay cho quên mật khẩu (S04) khi chưa có email/OTP.
    public void changePassword(int playerId, String oldPassword, String newPassword) {
        Integer accountId = accountIdOf(playerId);
        if (accountId == null) throw new ApiException(409, "Chưa đăng ký tài khoản");
        validatePassword(newPassword);
        try (Connection c = dataSource.getConnection()) {
            String salt;
            try (PreparedStatement ps = c.prepareStatement(
                    "SELECT password_hash, password_salt FROM accounts WHERE id = ?")) {
                ps.setInt(1, accountId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next() || !PasswordHash.matches(oldPassword == null ? "" : oldPassword,
                            rs.getString("password_salt"), rs.getString("password_hash"))) {
                        throw new ApiException(401, "Mật khẩu cũ không đúng");
                    }
                }
            }
            salt = PasswordHash.newSalt();
            try (PreparedStatement upd = c.prepareStatement(
                    "UPDATE accounts SET password_hash = ?, password_salt = ? WHERE id = ?")) {
                upd.setString(1, PasswordHash.hash(newPassword, salt));
                upd.setString(2, salt);
                upd.setInt(3, accountId);
                upd.executeUpdate();
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đổi mật khẩu: " + e.getMessage());
        }
    }

    private AuthResult result(int accountId, int playerId, String username) {
        var profile = players.profile(playerId);
        return new AuthResult(accountId, playerId, username, players.mintSession(playerId),
                profile.name(), profile.serverId(), profile.name() == null);
    }

    private void bindAccount(int playerId, int accountId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE players SET account_id = ? WHERE id = ?")) {
            ps.setInt(1, accountId);
            ps.setInt(2, playerId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi gắn tài khoản: " + e.getMessage());
        }
    }

    private Integer accountIdOf(int playerId) {
        return lookup("SELECT account_id FROM players WHERE id = ?", playerId, "account_id");
    }

    private Integer playerIdOf(int accountId) {
        return lookup("SELECT id FROM players WHERE account_id = ?", accountId, "id");
    }

    private Integer lookup(String sql, int key, String column) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                int value = rs.getInt(column);
                return rs.wasNull() ? null : value;
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc tài khoản: " + e.getMessage());
        }
    }

    static String validateUsername(String username) {
        String user = username == null ? "" : username.trim().toLowerCase();
        if (!user.matches("[a-z0-9_]{4,32}")) {
            throw new ApiException(400, "Tên đăng nhập 4-32 ký tự, chỉ gồm chữ thường, số và gạch dưới");
        }
        return user;
    }

    static void validatePassword(String password) {
        if (password == null || password.length() < 6 || password.length() > 64) {
            throw new ApiException(400, "Mật khẩu phải từ 6-64 ký tự");
        }
    }
}
