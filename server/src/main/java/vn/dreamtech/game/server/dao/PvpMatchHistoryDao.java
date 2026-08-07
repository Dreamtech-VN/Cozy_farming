package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Bảng {@code pvp_match_history} — DDL:
 * <pre>
 * CREATE TABLE pvp_match_history (
 *   match_id VARCHAR(36) NOT NULL PRIMARY KEY, player_a INT NOT NULL, player_b INT NOT NULL,
 *   score_a INT NOT NULL, score_b INT NOT NULL, winner_user_id INT, resolved_at TIMESTAMP NOT NULL
 * );
 * </pre>
 * Chỉ ghi lúc trận KẾT THÚC (cả 2 bên đã report) — không lưu từng lượt,
 * giống triết lý "chỉ lưu kết quả cuối" đã ghi ở {@code BattleSession}.
 * {@code winner_user_id} NULL nghĩa là hoà.
 */
public final class PvpMatchHistoryDao {
    private final DataSource dataSource;

    public PvpMatchHistoryDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public record MatchRecord(String matchId, int playerA, int playerB, int scoreA, int scoreB, Integer winnerUserId, long resolvedAt) {
    }

    public void record(String matchId, int playerA, int playerB, int scoreA, int scoreB, Integer winnerUserId) throws SQLException {
        String sql = "INSERT INTO pvp_match_history (match_id, player_a, player_b, score_a, score_b, winner_user_id, resolved_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, matchId);
            ps.setInt(2, playerA);
            ps.setInt(3, playerB);
            ps.setInt(4, scoreA);
            ps.setInt(5, scoreB);
            if (winnerUserId == null) {
                ps.setNull(6, java.sql.Types.INTEGER);
            } else {
                ps.setInt(6, winnerUserId);
            }
            ps.setTimestamp(7, Timestamp.from(java.time.Instant.now()));
            ps.executeUpdate();
        }
    }

    /** GM tra cứu lịch sử đấu của 1 user (VD: xử lý report tố cáo gian lận), mới nhất trước. */
    public List<MatchRecord> listByUser(int userId, int limit) throws SQLException {
        String sql = "SELECT match_id, player_a, player_b, score_a, score_b, winner_user_id, resolved_at " +
                "FROM pvp_match_history WHERE player_a = ? OR player_b = ? ORDER BY resolved_at DESC LIMIT ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                List<MatchRecord> matches = new ArrayList<>();
                while (rs.next()) {
                    int winner = rs.getInt("winner_user_id");
                    Integer winnerUserId = rs.wasNull() ? null : winner;
                    matches.add(new MatchRecord(
                            rs.getString("match_id"), rs.getInt("player_a"), rs.getInt("player_b"),
                            rs.getInt("score_a"), rs.getInt("score_b"), winnerUserId,
                            rs.getTimestamp("resolved_at").getTime()
                    ));
                }
                return matches;
            }
        }
    }
}
