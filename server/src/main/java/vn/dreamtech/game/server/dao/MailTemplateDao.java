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
import java.util.UUID;

/**
 * Bảng {@code mail_templates} — DDL:
 * <pre>
 * CREATE TABLE mail_templates (
 *   id VARCHAR(36) NOT NULL PRIMARY KEY, title VARCHAR(100) NOT NULL, body VARCHAR(1000),
 *   rewards VARCHAR(2000) NOT NULL, created_at TIMESTAMP NOT NULL, expires_at TIMESTAMP,
 *   active BOOLEAN NOT NULL DEFAULT TRUE
 * );
 * </pre>
 * Mail admin gửi cho TOÀN SERVER — không tạo 1 dòng {@code mails} cho từng
 * user ngay lúc gửi (không biết hết ai sẽ chơi sau này), mà "vật chất hoá"
 * lazy cho từng user khi họ mở hộp thư lần đầu sau khi template được tạo
 * (xem {@code MailBroadcastReceiptDao} để biết ai đã nhận).
 */
public final class MailTemplateDao {
    private static final Gson GSON = new Gson();
    private static final Type REWARD_LIST_TYPE = new TypeToken<List<RewardEntry>>() {
    }.getType();

    private final DataSource dataSource;

    public MailTemplateDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public record Template(String id, String title, String body, List<RewardEntry> rewards, long createdAt,
                            Long expiresAt, boolean active) {
    }

    public Template create(String title, String body, List<RewardEntry> rewards, long createdAt, Long expiresAt) throws SQLException {
        String id = UUID.randomUUID().toString();
        String sql = "INSERT INTO mail_templates (id, title, body, rewards, created_at, expires_at, active) " +
                "VALUES (?, ?, ?, ?, ?, ?, TRUE)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, id);
            ps.setString(2, title);
            ps.setString(3, body);
            ps.setString(4, GSON.toJson(rewards));
            ps.setTimestamp(5, new Timestamp(createdAt));
            if (expiresAt == null) ps.setNull(6, Types.TIMESTAMP); else ps.setTimestamp(6, new Timestamp(expiresAt));
            ps.executeUpdate();
        }
        return new Template(id, title, body, rewards, createdAt, expiresAt, true);
    }

    /** Template còn hiệu lực — active và (chưa có hạn hoặc chưa hết hạn). */
    public List<Template> findActive(long now) throws SQLException {
        String sql = "SELECT * FROM mail_templates WHERE active = TRUE AND (expires_at IS NULL OR expires_at >= ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(now));
            try (ResultSet rs = ps.executeQuery()) {
                List<Template> out = new ArrayList<>();
                while (rs.next()) out.add(map(rs));
                return out;
            }
        }
    }

    private static Template map(ResultSet rs) throws SQLException {
        Timestamp expiresAt = rs.getTimestamp("expires_at");
        List<RewardEntry> rewards = GSON.fromJson(rs.getString("rewards"), REWARD_LIST_TYPE);
        return new Template(rs.getString("id"), rs.getString("title"), rs.getString("body"), rewards,
                rs.getTimestamp("created_at").getTime(), expiresAt == null ? null : expiresAt.getTime(),
                rs.getBoolean("active"));
    }
}
