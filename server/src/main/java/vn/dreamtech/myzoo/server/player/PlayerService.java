package vn.dreamtech.myzoo.server.player;

import vn.dreamtech.myzoo.server.config.GameConfig;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.time.TimeSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Map;
import java.util.UUID;

public final class PlayerService {
    public static final long STARTER_VANG = 1000;

    private final DataSource dataSource;
    private final EconomyService economy;
    private final TimeSource time;

    public PlayerService(DataSource dataSource, EconomyService economy, TimeSource time) {
        this.dataSource = dataSource;
        this.economy = economy;
        this.time = time;
    }

    public record GuestLogin(int playerId, String guestToken, String sessionToken, boolean isNew, String name,
                             String serverId) {
    }

    public record Profile(int playerId, String name, String avatar, String serverId, boolean hasAccount,
                          int farmXp, int farmLevel, int zooXp, int zooLevel, Map<String, Long> wallets) {
    }

    public GuestLogin guestLogin(String guestToken) {
        try {
            if (guestToken != null && !guestToken.isBlank()) {
                try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                        "SELECT id, name, server_id FROM players WHERE guest_token = ?")) {
                    ps.setString(1, guestToken);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            int existingId = rs.getInt("id");
                            return new GuestLogin(existingId, guestToken, mintSession(existingId), false,
                                    rs.getString("name"), rs.getString("server_id"));
                        }
                    }
                }
            }
            String token = UUID.randomUUID().toString();
            int id;
            try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                    "INSERT INTO players (guest_token, created_at) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, token);
                ps.setTimestamp(2, new Timestamp(time.now()));
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    keys.next();
                    id = keys.getInt(1);
                }
            }
            economy.earn(id, EconomyService.VANG, STARTER_VANG, "STARTER", "player", String.valueOf(id));
            return new GuestLogin(id, token, mintSession(id), true, null, null);
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đăng nhập khách: " + e.getMessage());
        }
    }

    public int authenticate(String token) {
        if (token == null || token.isBlank()) throw new ApiException(401, "Thiếu token đăng nhập");
        try (Connection c = dataSource.getConnection()) {
            try (PreparedStatement ps = c.prepareStatement("SELECT player_id FROM sessions WHERE token = ?")) {
                ps.setString(1, token);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return rs.getInt("player_id");
                }
            }
            // Token thiết bị (đăng nhập khách) vẫn dùng được để tự vào lại.
            try (PreparedStatement ps = c.prepareStatement("SELECT id FROM players WHERE guest_token = ?")) {
                ps.setString(1, token);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return rs.getInt("id");
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi xác thực: " + e.getMessage());
        }
        throw new ApiException(401, "Phiên đăng nhập không hợp lệ");
    }

    public String mintSession(int playerId) {
        String token = UUID.randomUUID().toString();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO sessions (token, player_id, created_at) VALUES (?, ?, ?)")) {
            ps.setString(1, token);
            ps.setInt(2, playerId);
            ps.setTimestamp(3, new Timestamp(time.now()));
            ps.executeUpdate();
            return token;
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi tạo phiên: " + e.getMessage());
        }
    }

    public void logout(String token) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "DELETE FROM sessions WHERE token = ?")) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đăng xuất: " + e.getMessage());
        }
    }

    public void selectServer(int playerId, String serverId) {
        if (!GameConfig.isValidServer(serverId)) throw new ApiException(404, "Không có máy chủ này");
        if (!GameConfig.isJoinable(serverId)) throw new ApiException(409, "Máy chủ đang không nhận người chơi");
        requirePlayer(playerId);
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE players SET server_id = ? WHERE id = ?")) {
            ps.setString(1, serverId);
            ps.setInt(2, playerId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi chọn máy chủ: " + e.getMessage());
        }
    }

    // Tạo nhân vật (S07): đặt tên + ngoại hình trong một bước.
    public Profile createCharacter(int playerId, String name, String avatar) {
        requirePlayer(playerId);
        String trimmed = validateName(name);
        String look = avatar == null || avatar.isBlank() ? "farmer_1" : avatar.trim();
        if (look.length() > 40) throw new ApiException(400, "Ngoại hình không hợp lệ");
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE players SET name = ?, avatar = ? WHERE id = ?")) {
            ps.setString(1, trimmed);
            ps.setString(2, look);
            ps.setInt(3, playerId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(409, "Tên đã có người dùng");
        }
        return profile(playerId);
    }

    public static String validateName(String name) {
        String trimmed = name == null ? "" : name.trim();
        if (trimmed.length() < 2 || trimmed.length() > 20) {
            throw new ApiException(400, "Tên phải từ 2-20 ký tự");
        }
        if (!trimmed.matches("[\\p{L}0-9 _]+")) {
            throw new ApiException(400, "Tên chỉ gồm chữ, số, dấu cách và gạch dưới");
        }
        for (String bad : BANNED_NAME_PARTS) {
            if (trimmed.toLowerCase().contains(bad)) throw new ApiException(400, "Tên chứa từ không cho phép");
        }
        return trimmed;
    }

    private static final String[] BANNED_NAME_PARTS = {"admin", "gm ", "quantri", "moderator"};

    public void setName(int playerId, String name) {
        String trimmed = validateName(name);
        requirePlayer(playerId);
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE players SET name = ? WHERE id = ?")) {
            ps.setString(1, trimmed);
            ps.setInt(2, playerId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(409, "Tên đã có người dùng");
        }
    }

    public Profile profile(int playerId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT name, avatar, server_id, account_id, farm_xp, zoo_xp FROM players WHERE id = ?")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new ApiException(404, "Không tìm thấy người chơi");
                int farmXp = rs.getInt("farm_xp");
                int zooXp = rs.getInt("zoo_xp");
                rs.getInt("account_id");
                boolean hasAccount = !rs.wasNull();
                return new Profile(playerId, rs.getString("name"), rs.getString("avatar"), rs.getString("server_id"),
                        hasAccount,
                        farmXp, levelFor(farmXp), zooXp, levelFor(zooXp), economy.balances(playerId));
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc hồ sơ: " + e.getMessage());
        }
    }

    public void addFarmXp(int playerId, int xp) {
        addXp(playerId, "farm_xp", xp);
    }

    public void addZooXp(int playerId, int xp) {
        addXp(playerId, "zoo_xp", xp);
    }

    public void requirePlayer(int playerId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT 1 FROM players WHERE id = ?")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new ApiException(404, "Không tìm thấy người chơi");
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc người chơi: " + e.getMessage());
        }
    }

    public static int levelFor(int xp) {
        return 1 + (int) Math.floor(Math.sqrt(xp / 50.0));
    }

    private void addXp(int playerId, String column, int xp) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE players SET " + column + " = " + column + " + ? WHERE id = ?")) {
            ps.setInt(1, xp);
            ps.setInt(2, playerId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi cộng XP: " + e.getMessage());
        }
    }
}
