package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.model.Friendship;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Bảng {@code friendships} — DDL:
 * <pre>
 * CREATE TABLE friendships (
 *   user_id_a INT NOT NULL, user_id_b INT NOT NULL, intimacy_points INT NOT NULL DEFAULT 0,
 *   last_gift_at TIMESTAMP, created_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id_a, user_id_b)
 * );
 * </pre>
 * LUÔN chuẩn hoá {@code userIdA < userIdB} trước khi đọc/ghi (xem
 * {@link #canonical}) — 1 cặp bạn chỉ 1 dòng duy nhất, không quan trọng ai
 * là người gửi lời mời kết bạn trước.
 */
public final class FriendshipDao {
    private final DataSource dataSource;

    public FriendshipDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    private static int[] canonical(int userA, int userB) {
        return userA < userB ? new int[]{userA, userB} : new int[]{userB, userA};
    }

    public boolean areFriends(int userA, int userB) throws SQLException {
        int[] pair = canonical(userA, userB);
        String sql = "SELECT 1 FROM friendships WHERE user_id_a = ? AND user_id_b = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, pair[0]);
            ps.setInt(2, pair[1]);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void create(int userA, int userB, long now) throws SQLException {
        int[] pair = canonical(userA, userB);
        String sql = "INSERT INTO friendships (user_id_a, user_id_b, intimacy_points, created_at) VALUES (?, ?, 0, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, pair[0]);
            ps.setInt(2, pair[1]);
            ps.setTimestamp(3, new Timestamp(now));
            ps.executeUpdate();
        }
    }

    public void remove(int userA, int userB) throws SQLException {
        int[] pair = canonical(userA, userB);
        String sql = "DELETE FROM friendships WHERE user_id_a = ? AND user_id_b = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, pair[0]);
            ps.setInt(2, pair[1]);
            ps.executeUpdate();
        }
    }

    public Optional<Friendship> find(int userA, int userB) throws SQLException {
        int[] pair = canonical(userA, userB);
        String sql = "SELECT user_id_a, user_id_b, intimacy_points, last_gift_at FROM friendships WHERE user_id_a = ? AND user_id_b = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, pair[0]);
            ps.setInt(2, pair[1]);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    /** id tất cả bạn bè của {@code userId} (không phân biệt ai ở cột A/B). */
    public List<Integer> listFriendIds(int userId) throws SQLException {
        String sql = "SELECT user_id_a, user_id_b FROM friendships WHERE user_id_a = ? OR user_id_b = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Integer> out = new ArrayList<>();
                while (rs.next()) {
                    int a = rs.getInt("user_id_a");
                    int b = rs.getInt("user_id_b");
                    out.add(a == userId ? b : a);
                }
                return out;
            }
        }
    }

    public void addIntimacy(int userA, int userB, int delta, long now) throws SQLException {
        int[] pair = canonical(userA, userB);
        String sql = "UPDATE friendships SET intimacy_points = intimacy_points + ?, last_gift_at = ? WHERE user_id_a = ? AND user_id_b = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, delta);
            ps.setTimestamp(2, new Timestamp(now));
            ps.setInt(3, pair[0]);
            ps.setInt(4, pair[1]);
            ps.executeUpdate();
        }
    }

    /** Trừ điểm thân mật (dùng khi "mua nhẫn cầu hôn") — không cập nhật {@code last_gift_at}. */
    public void spendIntimacy(int userA, int userB, int amount) throws SQLException {
        int[] pair = canonical(userA, userB);
        String sql = "UPDATE friendships SET intimacy_points = intimacy_points - ? WHERE user_id_a = ? AND user_id_b = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, amount);
            ps.setInt(2, pair[0]);
            ps.setInt(3, pair[1]);
            ps.executeUpdate();
        }
    }

    private static Friendship map(ResultSet rs) throws SQLException {
        Timestamp lastGift = rs.getTimestamp("last_gift_at");
        return new Friendship(rs.getInt("user_id_a"), rs.getInt("user_id_b"), rs.getInt("intimacy_points"),
                lastGift == null ? null : lastGift.getTime());
    }
}
