package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Bảng {@code event_board} — DDL:
 * <pre>
 * CREATE TABLE event_board (
 *   id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(100) NOT NULL, description VARCHAR(1000),
 *   start_at TIMESTAMP NOT NULL, end_at TIMESTAMP NOT NULL, active BOOLEAN NOT NULL DEFAULT TRUE,
 *   created_at TIMESTAMP NOT NULL
 * );
 * </pre>
 * Bảng thông báo sự kiện admin quản lý — CHỈ hiển thị thông tin (tên/mô
 * tả/thời gian), KHÔNG tự cấp thưởng (thưởng sự kiện gửi qua
 * {@code AdminBroadcastMailHandler} riêng, tách bạch "thông báo" khỏi "phát
 * thưởng" — 1 sự kiện có thể có nhiều đợt phát thưởng khác nhau).
 */
public final class EventBoardDao {
    private final DataSource dataSource;

    public EventBoardDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public record EventEntry(int id, String title, String description, long startAt, long endAt, boolean active) {
    }

    public EventEntry create(String title, String description, long startAt, long endAt) throws SQLException {
        String sql = "INSERT INTO event_board (title, description, start_at, end_at, active, created_at) VALUES (?, ?, ?, ?, TRUE, ?)";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setTimestamp(3, new Timestamp(startAt));
            ps.setTimestamp(4, new Timestamp(endAt));
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                return new EventEntry(keys.getInt(1), title, description, startAt, endAt, true);
            }
        }
    }

    public void update(int id, String title, String description, long startAt, long endAt, boolean active) throws SQLException {
        String sql = "UPDATE event_board SET title = ?, description = ?, start_at = ?, end_at = ?, active = ? WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setTimestamp(3, new Timestamp(startAt));
            ps.setTimestamp(4, new Timestamp(endAt));
            ps.setBoolean(5, active);
            ps.setInt(6, id);
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM event_board WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public Optional<EventEntry> find(int id) throws SQLException {
        String sql = "SELECT id, title, description, start_at, end_at, active FROM event_board WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    /** Sự kiện active và chưa kết thúc — dùng cho bảng sự kiện hiển thị cho người chơi. */
    public List<EventEntry> findActive(long now) throws SQLException {
        String sql = "SELECT id, title, description, start_at, end_at, active FROM event_board " +
                "WHERE active = TRUE AND end_at >= ? ORDER BY start_at";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(now));
            try (ResultSet rs = ps.executeQuery()) {
                List<EventEntry> out = new ArrayList<>();
                while (rs.next()) out.add(map(rs));
                return out;
            }
        }
    }

    public List<EventEntry> findAll() throws SQLException {
        String sql = "SELECT id, title, description, start_at, end_at, active FROM event_board ORDER BY start_at DESC";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<EventEntry> out = new ArrayList<>();
            while (rs.next()) out.add(map(rs));
            return out;
        }
    }

    private static EventEntry map(ResultSet rs) throws SQLException {
        return new EventEntry(rs.getInt("id"), rs.getString("title"), rs.getString("description"),
                rs.getTimestamp("start_at").getTime(), rs.getTimestamp("end_at").getTime(), rs.getBoolean("active"));
    }
}
