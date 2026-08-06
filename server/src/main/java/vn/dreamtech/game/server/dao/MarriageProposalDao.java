package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.model.MarriageProposal;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Optional;

/**
 * Bảng {@code marriage_proposals} — DDL:
 * <pre>
 * CREATE TABLE marriage_proposals (
 *   id BIGINT AUTO_INCREMENT PRIMARY KEY, from_user_id INT NOT NULL, to_user_id INT NOT NULL,
 *   created_at TIMESTAMP NOT NULL, UNIQUE (from_user_id, to_user_id)
 * );
 * </pre>
 * Chấp nhận/từ chối đều XOÁ dòng (chấp nhận thì chuyển thành dòng bên
 * {@code marriages}), khớp cách {@link FriendRequestDao} đã làm.
 */
public final class MarriageProposalDao {
    private final DataSource dataSource;

    public MarriageProposalDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public boolean exists(int fromUserId, int toUserId) throws SQLException {
        String sql = "SELECT 1 FROM marriage_proposals WHERE from_user_id = ? AND to_user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, fromUserId);
            ps.setInt(2, toUserId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public MarriageProposal create(int fromUserId, int toUserId, long now) throws SQLException {
        String sql = "INSERT INTO marriage_proposals (from_user_id, to_user_id, created_at) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, fromUserId);
            ps.setInt(2, toUserId);
            ps.setTimestamp(3, new Timestamp(now));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                return new MarriageProposal(keys.getLong(1), fromUserId, toUserId, now);
            }
        }
    }

    public Optional<MarriageProposal> find(long id) throws SQLException {
        String sql = "SELECT id, from_user_id, to_user_id, created_at FROM marriage_proposals WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();
                return Optional.of(new MarriageProposal(rs.getLong("id"), rs.getInt("from_user_id"),
                        rs.getInt("to_user_id"), rs.getTimestamp("created_at").getTime()));
            }
        }
    }

    public void delete(long id) throws SQLException {
        String sql = "DELETE FROM marriage_proposals WHERE id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }
}
