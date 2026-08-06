package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.model.Presence;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Bảng {@code lobby_presence} — DDL:
 * <pre>
 * CREATE TABLE lobby_presence (
 *   user_id INT NOT NULL PRIMARY KEY, x INT NOT NULL, y INT NOT NULL, last_seen TIMESTAMP NOT NULL
 * );
 * </pre>
 * Chỉ REST polling (không phải WebSocket) — client gọi
 * {@code /api/lobby/heartbeat} định kỳ (vd. mỗi 1-2 giây) để báo còn hoạt
 * động + cập nhật vị trí, và {@code /api/lobby/players} để lấy danh sách
 * người khác đang ở sảnh. TODO: nâng cấp lên WebSocket nếu cần đồng bộ di
 * chuyển mượt hơn — polling đủ dùng cho sảnh tĩnh (đứng nói chuyện/chọn menu).
 */
public final class PresenceDao {
    private final DataSource dataSource;

    public PresenceDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public void heartbeat(int userId, int x, int y, long now) throws SQLException {
        String sql = "MERGE INTO lobby_presence (user_id, x, y, last_seen) KEY (user_id) VALUES (?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, x);
            ps.setInt(3, y);
            ps.setTimestamp(4, new Timestamp(now));
            ps.executeUpdate();
        }
    }

    /** Người chơi còn hoạt động trong {@code activeWithinMs} tính từ {@code now}. */
    public List<Presence> listActive(long now, long activeWithinMs) throws SQLException {
        String sql = "SELECT user_id, x, y, last_seen FROM lobby_presence WHERE last_seen >= ? ORDER BY user_id";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(now - activeWithinMs));
            try (ResultSet rs = ps.executeQuery()) {
                List<Presence> out = new ArrayList<>();
                while (rs.next()) {
                    out.add(new Presence(rs.getInt("user_id"), rs.getInt("x"), rs.getInt("y"), rs.getTimestamp("last_seen").getTime()));
                }
                return out;
            }
        }
    }

    public void remove(int userId) throws SQLException {
        String sql = "DELETE FROM lobby_presence WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }
}
