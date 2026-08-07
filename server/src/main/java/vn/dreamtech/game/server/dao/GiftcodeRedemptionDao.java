package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

/**
 * Bảng {@code giftcode_redemptions} — DDL:
 * <pre>
 * CREATE TABLE giftcode_redemptions (
 *   user_id INT NOT NULL, code VARCHAR(50) NOT NULL, redeemed_at TIMESTAMP NOT NULL,
 *   PRIMARY KEY (user_id, code)
 * );
 * </pre>
 * Mỗi user chỉ đổi được 1 code MỘT LẦN (không phụ thuộc {@code max_uses}
 * tổng của {@code GiftcodeDao} — 2 giới hạn độc lập nhau).
 */
public final class GiftcodeRedemptionDao {
    private final DataSource dataSource;

    public GiftcodeRedemptionDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public boolean hasRedeemed(int userId, String code) throws SQLException {
        String sql = "SELECT 1 FROM giftcode_redemptions WHERE user_id = ? AND code = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, code);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void recordRedemption(int userId, String code) throws SQLException {
        String sql = "INSERT INTO giftcode_redemptions (user_id, code, redeemed_at) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, code);
            ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            ps.executeUpdate();
        }
    }
}
