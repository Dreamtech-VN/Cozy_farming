package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.model.CharacterAppearance;
import vn.dreamtech.game.server.model.CosmeticType;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Bảng {@code character_appearance} — DDL:
 * <pre>
 * CREATE TABLE character_appearance (
 *   user_id INT NOT NULL PRIMARY KEY, eyes_id INT, avatar_id INT, avatar_frame_id INT,
 *   title_id INT, emote_id INT, hat_id INT, shirt_id INT, pants_id INT, shoes_id INT,
 *   pet_id INT, skin_id INT
 * );
 * </pre>
 * Chưa từng lưu thì trả về toàn {@code null} (chưa trang bị gì).
 */
public final class CharacterAppearanceDao {
    private final DataSource dataSource;

    public CharacterAppearanceDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public CharacterAppearance find(int userId) throws SQLException {
        String sql = "SELECT eyes_id, avatar_id, avatar_frame_id, title_id, emote_id, hat_id, shirt_id, pants_id, shoes_id, pet_id, skin_id " +
                "FROM character_appearance WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return CharacterAppearance.defaultsFor(userId);
                return new CharacterAppearance(
                        userId,
                        nullableInt(rs, "eyes_id"),
                        nullableInt(rs, "avatar_id"),
                        nullableInt(rs, "avatar_frame_id"),
                        nullableInt(rs, "title_id"),
                        nullableInt(rs, "emote_id"),
                        nullableInt(rs, "hat_id"),
                        nullableInt(rs, "shirt_id"),
                        nullableInt(rs, "pants_id"),
                        nullableInt(rs, "shoes_id"),
                        nullableInt(rs, "pet_id"),
                        nullableInt(rs, "skin_id")
                );
            }
        }
    }

    public void equip(int userId, CosmeticType slot, Integer itemId) throws SQLException {
        CharacterAppearance updated = find(userId).withSlot(slot, itemId);
        String sql = "MERGE INTO character_appearance (user_id, eyes_id, avatar_id, avatar_frame_id, title_id, emote_id, " +
                "hat_id, shirt_id, pants_id, shoes_id, pet_id, skin_id) KEY (user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            setNullableInt(ps, 2, updated.eyesId());
            setNullableInt(ps, 3, updated.avatarId());
            setNullableInt(ps, 4, updated.avatarFrameId());
            setNullableInt(ps, 5, updated.titleId());
            setNullableInt(ps, 6, updated.emoteId());
            setNullableInt(ps, 7, updated.hatId());
            setNullableInt(ps, 8, updated.shirtId());
            setNullableInt(ps, 9, updated.pantsId());
            setNullableInt(ps, 10, updated.shoesId());
            setNullableInt(ps, 11, updated.petId());
            setNullableInt(ps, 12, updated.skinId());
            ps.executeUpdate();
        }
    }

    private static Integer nullableInt(ResultSet rs, String column) throws SQLException {
        int value = rs.getInt(column);
        return rs.wasNull() ? null : value;
    }

    private static void setNullableInt(PreparedStatement ps, int index, Integer value) throws SQLException {
        if (value == null) {
            ps.setNull(index, java.sql.Types.INTEGER);
        } else {
            ps.setInt(index, value);
        }
    }
}
