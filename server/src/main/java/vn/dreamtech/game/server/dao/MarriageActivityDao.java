package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;

/**
 * Bảng {@code marriage_activity} — DDL:
 * <pre>
 * CREATE TABLE marriage_activity (
 *   user_id_a INT NOT NULL, user_id_b INT NOT NULL,
 *   last_online_tick_at TIMESTAMP, last_duo_quest_at TIMESTAMP,
 *   coop_a_completed_at TIMESTAMP, coop_b_completed_at TIMESTAMP, coop_last_awarded_at TIMESTAMP,
 *   PRIMARY KEY (user_id_a, user_id_b)
 * );
 * </pre>
 * Nguồn điểm thân mật SAU KHI CƯỚI (giai đoạn quà tặng vẫn dùng {@link
 * FriendshipDao} vì vợ/chồng vẫn là bạn bè): (1) "tick" khi cả 2 cùng
 * online, (2) nhiệm vụ đôi hàng ngày, (3) đánh trận hợp tác. Luôn chuẩn hoá
 * {@code userIdA < userIdB} giống {@link MarriageDao}/{@link FriendshipDao}.
 */
public final class MarriageActivityDao {
    private final DataSource dataSource;

    public MarriageActivityDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public record Activity(int userIdA, int userIdB, Long lastOnlineTickAt, Long lastDuoQuestAt,
                            Long coopACompletedAt, Long coopBCompletedAt, Long coopLastAwardedAt) {
    }

    private static int[] canonical(int userA, int userB) {
        return userA < userB ? new int[]{userA, userB} : new int[]{userB, userA};
    }

    public void ensureRow(int userA, int userB) throws SQLException {
        int[] pair = canonical(userA, userB);
        String sql = "INSERT INTO marriage_activity (user_id_a, user_id_b) " +
                "SELECT ?, ? WHERE NOT EXISTS (SELECT 1 FROM marriage_activity WHERE user_id_a = ? AND user_id_b = ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, pair[0]);
            ps.setInt(2, pair[1]);
            ps.setInt(3, pair[0]);
            ps.setInt(4, pair[1]);
            ps.executeUpdate();
        }
    }

    public Optional<Activity> find(int userA, int userB) throws SQLException {
        int[] pair = canonical(userA, userB);
        String sql = "SELECT * FROM marriage_activity WHERE user_id_a = ? AND user_id_b = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, pair[0]);
            ps.setInt(2, pair[1]);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    public void updateOnlineTick(int userA, int userB, long now) throws SQLException {
        int[] pair = canonical(userA, userB);
        String sql = "UPDATE marriage_activity SET last_online_tick_at = ? WHERE user_id_a = ? AND user_id_b = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(now));
            ps.setInt(2, pair[0]);
            ps.setInt(3, pair[1]);
            ps.executeUpdate();
        }
    }

    public void updateDuoQuest(int userA, int userB, long now) throws SQLException {
        int[] pair = canonical(userA, userB);
        String sql = "UPDATE marriage_activity SET last_duo_quest_at = ? WHERE user_id_a = ? AND user_id_b = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(now));
            ps.setInt(2, pair[0]);
            ps.setInt(3, pair[1]);
            ps.executeUpdate();
        }
    }

    /** Đánh dấu {@code completingUserId} vừa hoàn thành trận hợp tác — ghi vào cột A hoặc B tuỳ thứ tự chuẩn hoá. */
    public void updateCoopCompleted(int userA, int userB, int completingUserId, long now) throws SQLException {
        int[] pair = canonical(userA, userB);
        String column = completingUserId == pair[0] ? "coop_a_completed_at" : "coop_b_completed_at";
        String sql = "UPDATE marriage_activity SET " + column + " = ? WHERE user_id_a = ? AND user_id_b = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(now));
            ps.setInt(2, pair[0]);
            ps.setInt(3, pair[1]);
            ps.executeUpdate();
        }
    }

    public void updateCoopAwarded(int userA, int userB, long now) throws SQLException {
        int[] pair = canonical(userA, userB);
        String sql = "UPDATE marriage_activity SET coop_last_awarded_at = ? WHERE user_id_a = ? AND user_id_b = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(now));
            ps.setInt(2, pair[0]);
            ps.setInt(3, pair[1]);
            ps.executeUpdate();
        }
    }

    private static Activity map(ResultSet rs) throws SQLException {
        return new Activity(
                rs.getInt("user_id_a"), rs.getInt("user_id_b"),
                nullableMillis(rs, "last_online_tick_at"), nullableMillis(rs, "last_duo_quest_at"),
                nullableMillis(rs, "coop_a_completed_at"), nullableMillis(rs, "coop_b_completed_at"),
                nullableMillis(rs, "coop_last_awarded_at")
        );
    }

    private static Long nullableMillis(ResultSet rs, String column) throws SQLException {
        Timestamp ts = rs.getTimestamp(column);
        return ts == null ? null : ts.getTime();
    }
}
