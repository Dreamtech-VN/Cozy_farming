package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.model.FriendRequest;

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
 * Bảng {@code friend_requests} — DDL:
 * <pre>
 * CREATE TABLE friend_requests (
 *   id BIGINT AUTO_INCREMENT PRIMARY KEY, from_user_id INT NOT NULL, to_user_id INT NOT NULL,
 *   created_at TIMESTAMP NOT NULL, UNIQUE (from_user_id, to_user_id)
 * );
 * </pre>
 * Chấp nhận/từ chối đều XOÁ dòng khỏi bảng này (chấp nhận thì chuyển thành
 * dòng bên {@code friendships}) — bảng này chỉ chứa lời mời ĐANG chờ.
 */
public final class FriendRequestDao {
    private final DataSource dataSource;

    public FriendRequestDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public boolean exists(int fromUserId, int toUserId) throws SQLException {
        String sql = "SELECT 1 FROM friend_requests WHERE from_user_id = ? AND to_user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, fromUserId);
            ps.setInt(2, toUserId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public FriendRequest create(int fromUserId, int toUserId, long now) throws SQLException {
        String sql = "INSERT INTO friend_requests (from_user_id, to_user_id, created_at) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, fromUserId);
            ps.setInt(2, toUserId);
            ps.setTimestamp(3, new Timestamp(now));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                return new FriendRequest(keys.getLong(1), fromUserId, toUserId, now);
            }
        }
    }

    public Optional<FriendRequest> find(long id) throws SQLException {
        String sql = "SELECT id, from_user_id, to_user_id, created_at FROM friend_requests WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    /** Lời mời ĐANG CHỜ user này phản hồi (người khác gửi tới). */
    public List<FriendRequest> findIncoming(int userId) throws SQLException {
        String sql = "SELECT id, from_user_id, to_user_id, created_at FROM friend_requests WHERE to_user_id = ? ORDER BY id";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<FriendRequest> out = new ArrayList<>();
                while (rs.next()) out.add(map(rs));
                return out;
            }
        }
    }

    public void delete(long id) throws SQLException {
        String sql = "DELETE FROM friend_requests WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    private static FriendRequest map(ResultSet rs) throws SQLException {
        return new FriendRequest(rs.getLong("id"), rs.getInt("from_user_id"), rs.getInt("to_user_id"),
                rs.getTimestamp("created_at").getTime());
    }
}
