package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

/**
 * Bảng {@code divorce_cooldowns} — DDL:
 * <pre>
 * CREATE TABLE divorce_cooldowns (
 *   user_id INT NOT NULL PRIMARY KEY, cooldown_until TIMESTAMP NOT NULL
 * );
 * </pre>
 * Sau khi ly hôn, CẢ HAI người (không chỉ người chủ động ly hôn) đều bị áp
 * thời gian chờ trước khi cưới lại — chặn vòng lặp cưới/ly hôn liên tục để
 * spam nhận thưởng (nếu sau này có thưởng khi cưới).
 */
public final class DivorceCooldownDao {
    private final DataSource dataSource;

    public DivorceCooldownDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public void setCooldown(int userId, long cooldownUntil) throws SQLException {
        String sql = "MERGE INTO divorce_cooldowns (user_id, cooldown_until) KEY (user_id) VALUES (?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setTimestamp(2, new Timestamp(cooldownUntil));
            ps.executeUpdate();
        }
    }

    public boolean isInCooldown(int userId, long now) throws SQLException {
        String sql = "SELECT 1 FROM divorce_cooldowns WHERE user_id = ? AND cooldown_until > ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setTimestamp(2, new Timestamp(now));
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}
