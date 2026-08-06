package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Bảng {@code pvp_ranks} — DDL:
 * <pre>
 * CREATE TABLE pvp_ranks (
 *   user_id INT NOT NULL PRIMARY KEY, rating INT NOT NULL DEFAULT 1000,
 *   wins INT NOT NULL DEFAULT 0, losses INT NOT NULL DEFAULT 0, draws INT NOT NULL DEFAULT 0
 * );
 * </pre>
 * Chưa từng đấu thì mặc định rating 1000/0/0/0 (khớp cách {@code WalletDao}
 * đã làm). Hệ số Elo-lite đơn giản, xem {@code PvpConstants}.
 */
public final class PvpRankDao {
    private final DataSource dataSource;

    public PvpRankDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public record Rank(int userId, int rating, int wins, int losses, int draws) {
        public static Rank defaultsFor(int userId) {
            return new Rank(userId, 1000, 0, 0, 0);
        }
    }

    public Rank find(int userId) throws SQLException {
        String sql = "SELECT rating, wins, losses, draws FROM pvp_ranks WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Rank.defaultsFor(userId);
                return new Rank(userId, rs.getInt("rating"), rs.getInt("wins"), rs.getInt("losses"), rs.getInt("draws"));
            }
        }
    }

    public void save(Rank rank) throws SQLException {
        String sql = "MERGE INTO pvp_ranks (user_id, rating, wins, losses, draws) KEY (user_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, rank.userId());
            ps.setInt(2, rank.rating());
            ps.setInt(3, rank.wins());
            ps.setInt(4, rank.losses());
            ps.setInt(5, rank.draws());
            ps.executeUpdate();
        }
    }

    public List<Rank> topByRating(int limit) throws SQLException {
        String sql = "SELECT user_id, rating, wins, losses, draws FROM pvp_ranks ORDER BY rating DESC LIMIT ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                List<Rank> ranks = new ArrayList<>();
                while (rs.next()) {
                    ranks.add(new Rank(rs.getInt("user_id"), rs.getInt("rating"), rs.getInt("wins"), rs.getInt("losses"), rs.getInt("draws")));
                }
                return ranks;
            }
        }
    }
}
