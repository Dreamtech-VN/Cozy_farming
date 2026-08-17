package vn.dreamtech.myzoo.server.mail;

import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.farm.FarmService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;
import vn.dreamtech.myzoo.server.time.TimeSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

// Thư hệ thống + quà đính kèm. Quà chỉ nhận được 1 lần, khoá bằng UPDATE có điều kiện.
public final class MailService {
    public static final long DEFAULT_TTL_MS = 30L * 24 * 60 * 60 * 1000;

    private final DataSource dataSource;
    private final EconomyService economy;
    private final PlayerService players;
    private final TimeSource time;

    public MailService(DataSource dataSource, EconomyService economy, PlayerService players, TimeSource time) {
        this.dataSource = dataSource;
        this.economy = economy;
        this.players = players;
        this.time = time;
    }

    public record MailView(long id, String title, String body, long rewardVang, long rewardKc,
                           String rewardFoodId, int rewardFoodQty, boolean claimed, long createdAt, long expiresAt) {
    }

    public record ClaimResult(long mailId, long rewardVang, long rewardKc, String rewardFoodId, int rewardFoodQty,
                              long vangBalance, long kcBalance) {
    }

    public long send(int playerId, String title, String body,
                     long rewardVang, long rewardKc, String rewardFoodId, int rewardFoodQty) {
        long now = time.now();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO mails (player_id, title, body, reward_vang, reward_kc, reward_food_id, reward_food_qty, "
                        + "claimed, created_at, expires_at) VALUES (?, ?, ?, ?, ?, ?, ?, FALSE, ?, ?)",
                java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, playerId);
            ps.setString(2, title);
            ps.setString(3, body);
            ps.setLong(4, rewardVang);
            ps.setLong(5, rewardKc);
            ps.setString(6, rewardFoodId);
            ps.setInt(7, rewardFoodQty);
            ps.setTimestamp(8, new Timestamp(now));
            ps.setTimestamp(9, new Timestamp(now + DEFAULT_TTL_MS));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                return keys.getLong(1);
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi gửi thư: " + e.getMessage());
        }
    }

    public List<MailView> inbox(int playerId) {
        players.requirePlayer(playerId);
        List<MailView> out = new ArrayList<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT id, title, body, reward_vang, reward_kc, reward_food_id, reward_food_qty, claimed, "
                        + "created_at, expires_at FROM mails WHERE player_id = ? AND expires_at > ? ORDER BY id DESC")) {
            ps.setInt(1, playerId);
            ps.setTimestamp(2, new Timestamp(time.now()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(new MailView(rs.getLong("id"), rs.getString("title"), rs.getString("body"),
                            rs.getLong("reward_vang"), rs.getLong("reward_kc"),
                            rs.getString("reward_food_id"), rs.getInt("reward_food_qty"),
                            rs.getBoolean("claimed"),
                            rs.getTimestamp("created_at").getTime(), rs.getTimestamp("expires_at").getTime()));
                }
            }
            return out;
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc hộp thư: " + e.getMessage());
        }
    }

    public ClaimResult claim(int playerId, long mailId) {
        players.requirePlayer(playerId);
        MailView mail = find(playerId, mailId);
        if (mail == null) throw new ApiException(404, "Không tìm thấy thư");
        if (mail.expiresAt() <= time.now()) throw new ApiException(409, "Thư đã hết hạn");

        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE mails SET claimed = TRUE WHERE id = ? AND player_id = ? AND claimed = FALSE")) {
            ps.setLong(1, mailId);
            ps.setInt(2, playerId);
            if (ps.executeUpdate() == 0) throw new ApiException(409, "Thư này đã nhận rồi");
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi nhận thư: " + e.getMessage());
        }

        long vang = mail.rewardVang() > 0
                ? economy.earn(playerId, EconomyService.VANG, mail.rewardVang(), "MAIL", "mail", String.valueOf(mailId))
                : economy.balances(playerId).get(EconomyService.VANG);
        long kc = mail.rewardKc() > 0
                ? economy.earn(playerId, EconomyService.KIM_CUONG, mail.rewardKc(), "MAIL", "mail", String.valueOf(mailId))
                : economy.balances(playerId).get(EconomyService.KIM_CUONG);

        if (mail.rewardFoodId() != null && mail.rewardFoodQty() > 0) {
            try (Connection c = dataSource.getConnection()) {
                FarmService.addToInventory(c, "farm_inventory", playerId, mail.rewardFoodId(), mail.rewardFoodQty());
            } catch (SQLException e) {
                throw new ApiException(500, "Lỗi nhận vật phẩm: " + e.getMessage());
            }
        }
        return new ClaimResult(mailId, mail.rewardVang(), mail.rewardKc(),
                mail.rewardFoodId(), mail.rewardFoodQty(), vang, kc);
    }

    public int claimAll(int playerId) {
        int count = 0;
        for (MailView mail : inbox(playerId)) {
            if (mail.claimed()) continue;
            claim(playerId, mail.id());
            count++;
        }
        return count;
    }

    private MailView find(int playerId, long mailId) {
        for (MailView mail : inbox(playerId)) {
            if (mail.id() == mailId) return mail;
        }
        return null;
    }
}
