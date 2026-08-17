package vn.dreamtech.myzoo.server.player;

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

    public record GuestLogin(int playerId, String guestToken, boolean isNew, String name) {
    }

    public record Profile(int playerId, String name, int farmXp, int farmLevel, int zooXp, int zooLevel,
                           Map<String, Long> wallets) {
    }

    public GuestLogin guestLogin(String guestToken) {
        try {
            if (guestToken != null && !guestToken.isBlank()) {
                try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                        "SELECT id, name FROM players WHERE guest_token = ?")) {
                    ps.setString(1, guestToken);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            return new GuestLogin(rs.getInt("id"), guestToken, false, rs.getString("name"));
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
            return new GuestLogin(id, token, true, null);
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đăng nhập khách: " + e.getMessage());
        }
    }

    public int authenticate(String guestToken) {
        if (guestToken == null || guestToken.isBlank()) {
            throw new ApiException(401, "Thiếu guest token");
        }
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT id FROM players WHERE guest_token = ?")) {
            ps.setString(1, guestToken);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new ApiException(401, "Guest token không hợp lệ");
                return rs.getInt("id");
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi xác thực: " + e.getMessage());
        }
    }

    public void setName(int playerId, String name) {
        String trimmed = name == null ? "" : name.trim();
        if (trimmed.length() < 2 || trimmed.length() > 20) {
            throw new ApiException(400, "Tên phải từ 2-20 ký tự");
        }
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
                "SELECT name, farm_xp, zoo_xp FROM players WHERE id = ?")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new ApiException(404, "Không tìm thấy người chơi");
                int farmXp = rs.getInt("farm_xp");
                int zooXp = rs.getInt("zoo_xp");
                return new Profile(playerId, rs.getString("name"),
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
