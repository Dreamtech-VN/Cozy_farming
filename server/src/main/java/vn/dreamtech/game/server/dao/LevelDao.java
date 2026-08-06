package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.model.LevelInfo;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Bảng {@code character_levels} — DDL:
 * <pre>
 * CREATE TABLE character_levels (
 *   user_id INT NOT NULL PRIMARY KEY, level INT NOT NULL DEFAULT 1, exp INT NOT NULL DEFAULT 0
 * );
 * </pre>
 * Chưa từng lưu thì trả về mặc định level 1 (khớp cách {@code WalletDao}/
 * {@code UserSettingsDao} đã làm).
 */
public final class LevelDao {
    private final DataSource dataSource;

    public LevelDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public LevelInfo find(int userId) throws SQLException {
        String sql = "SELECT level, exp FROM character_levels WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return LevelInfo.defaultsFor(userId);
                return new LevelInfo(userId, rs.getInt("level"), rs.getInt("exp"));
            }
        }
    }

    public void save(LevelInfo info) throws SQLException {
        String sql = "MERGE INTO character_levels (user_id, level, exp) KEY (user_id) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, info.userId());
            ps.setInt(2, info.level());
            ps.setInt(3, info.exp());
            ps.executeUpdate();
        }
    }
}
