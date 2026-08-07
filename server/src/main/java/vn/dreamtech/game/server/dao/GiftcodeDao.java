package vn.dreamtech.game.server.dao;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import vn.dreamtech.game.server.item.RewardEntry;

import javax.sql.DataSource;
import java.lang.reflect.Type;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Bảng {@code giftcodes} — DDL:
 * <pre>
 * CREATE TABLE giftcodes (
 *   code VARCHAR(50) NOT NULL PRIMARY KEY, title VARCHAR(100) NOT NULL, rewards VARCHAR(2000) NOT NULL,
 *   max_uses INT, used_count INT NOT NULL DEFAULT 0, expires_at TIMESTAMP,
 *   active BOOLEAN NOT NULL DEFAULT TRUE, created_at TIMESTAMP NOT NULL
 * );
 * </pre>
 * {@code maxUses = null} nghĩa là KHÔNG giới hạn tổng lượt đổi (mỗi user
 * vẫn chỉ đổi được 1 lần — xem {@code GiftcodeRedemptionDao}).
 */
public final class GiftcodeDao {
    private static final Gson GSON = new Gson();
    private static final Type REWARD_LIST_TYPE = new TypeToken<List<RewardEntry>>() {
    }.getType();

    private final DataSource dataSource;

    public GiftcodeDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public record Giftcode(String code, String title, List<RewardEntry> rewards, Integer maxUses, int usedCount,
                            Long expiresAt, boolean active, long createdAt) {
    }

    public Giftcode create(String code, String title, List<RewardEntry> rewards, Integer maxUses, Long expiresAt) throws SQLException {
        long now = System.currentTimeMillis();
        String sql = "INSERT INTO giftcodes (code, title, rewards, max_uses, used_count, expires_at, active, created_at) " +
                "VALUES (?, ?, ?, ?, 0, ?, TRUE, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.setString(2, title);
            ps.setString(3, GSON.toJson(rewards));
            if (maxUses == null) ps.setNull(4, Types.INTEGER); else ps.setInt(4, maxUses);
            if (expiresAt == null) ps.setNull(5, Types.TIMESTAMP); else ps.setTimestamp(5, new Timestamp(expiresAt));
            ps.setTimestamp(6, new Timestamp(now));
            ps.executeUpdate();
        }
        return new Giftcode(code, title, rewards, maxUses, 0, expiresAt, true, now);
    }

    public void update(String code, String title, List<RewardEntry> rewards, Integer maxUses, Long expiresAt, boolean active) throws SQLException {
        String sql = "UPDATE giftcodes SET title = ?, rewards = ?, max_uses = ?, expires_at = ?, active = ? WHERE code = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, GSON.toJson(rewards));
            if (maxUses == null) ps.setNull(3, Types.INTEGER); else ps.setInt(3, maxUses);
            if (expiresAt == null) ps.setNull(4, Types.TIMESTAMP); else ps.setTimestamp(4, new Timestamp(expiresAt));
            ps.setBoolean(5, active);
            ps.setString(6, code);
            ps.executeUpdate();
        }
    }

    public void delete(String code) throws SQLException {
        String sql = "DELETE FROM giftcodes WHERE code = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.executeUpdate();
        }
    }

    public void incrementUsedCount(String code) throws SQLException {
        String sql = "UPDATE giftcodes SET used_count = used_count + 1 WHERE code = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.executeUpdate();
        }
    }

    public Optional<Giftcode> find(String code) throws SQLException {
        String sql = "SELECT * FROM giftcodes WHERE code = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    public List<Giftcode> findAll() throws SQLException {
        String sql = "SELECT * FROM giftcodes ORDER BY created_at DESC";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Giftcode> out = new ArrayList<>();
            while (rs.next()) out.add(map(rs));
            return out;
        }
    }

    private static Giftcode map(ResultSet rs) throws SQLException {
        int maxUses = rs.getInt("max_uses");
        Integer maxUsesBoxed = rs.wasNull() ? null : maxUses;
        Timestamp expiresAt = rs.getTimestamp("expires_at");
        List<RewardEntry> rewards = GSON.fromJson(rs.getString("rewards"), REWARD_LIST_TYPE);
        return new Giftcode(rs.getString("code"), rs.getString("title"), rewards, maxUsesBoxed,
                rs.getInt("used_count"), expiresAt == null ? null : expiresAt.getTime(), rs.getBoolean("active"),
                rs.getTimestamp("created_at").getTime());
    }
}
