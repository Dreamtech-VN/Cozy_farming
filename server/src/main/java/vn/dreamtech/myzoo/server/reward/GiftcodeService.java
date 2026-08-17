package vn.dreamtech.myzoo.server.reward;

import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.mail.MailService;
import vn.dreamtech.myzoo.server.player.PlayerService;
import vn.dreamtech.myzoo.server.time.TimeSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

// Quà nhập bằng mã. Phần thưởng trả qua hộp thư để có dấu vết và người chơi tự nhận.
public final class GiftcodeService {
    private final DataSource dataSource;
    private final MailService mail;
    private final PlayerService players;
    private final TimeSource time;

    public GiftcodeService(DataSource dataSource, MailService mail, PlayerService players, TimeSource time) {
        this.dataSource = dataSource;
        this.mail = mail;
        this.players = players;
        this.time = time;
    }

    public record RedeemResult(String code, long mailId, String message) {
    }

    public void create(String code, long rewardVang, long rewardKc, String foodId, int foodQty,
                       int maxUses, long expiresAt) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO giftcodes (code, reward_vang, reward_kc, reward_food_id, reward_food_qty, "
                        + "max_uses, used_count, expires_at) VALUES (?, ?, ?, ?, ?, ?, 0, ?)")) {
            ps.setString(1, normalize(code));
            ps.setLong(2, rewardVang);
            ps.setLong(3, rewardKc);
            ps.setString(4, foodId);
            ps.setInt(5, foodQty);
            ps.setInt(6, maxUses);
            ps.setTimestamp(7, new Timestamp(expiresAt));
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(409, "Mã này đã tồn tại");
        }
    }

    public RedeemResult redeem(int playerId, String rawCode) {
        players.requirePlayer(playerId);
        String code = normalize(rawCode);
        if (code.isEmpty()) throw new ApiException(400, "Cần nhập mã");

        long rewardVang, rewardKc;
        String foodId;
        int foodQty;
        try (Connection c = dataSource.getConnection()) {
            try (PreparedStatement ps = c.prepareStatement(
                    "SELECT reward_vang, reward_kc, reward_food_id, reward_food_qty, max_uses, used_count, expires_at "
                            + "FROM giftcodes WHERE code = ?")) {
                ps.setString(1, code);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) throw new ApiException(404, "Mã không tồn tại");
                    if (rs.getTimestamp("expires_at").getTime() <= time.now()) {
                        throw new ApiException(409, "Mã đã hết hạn");
                    }
                    if (rs.getInt("used_count") >= rs.getInt("max_uses")) {
                        throw new ApiException(409, "Mã đã hết lượt sử dụng");
                    }
                    rewardVang = rs.getLong("reward_vang");
                    rewardKc = rs.getLong("reward_kc");
                    foodId = rs.getString("reward_food_id");
                    foodQty = rs.getInt("reward_food_qty");
                }
            }

            // Mỗi người 1 lần: khoá bằng PK (code, player_id) nên hai request song song chỉ 1 cái thắng.
            try (PreparedStatement ins = c.prepareStatement(
                    "INSERT INTO giftcode_uses (code, player_id, created_at) VALUES (?, ?, ?)")) {
                ins.setString(1, code);
                ins.setInt(2, playerId);
                ins.setTimestamp(3, new Timestamp(time.now()));
                ins.executeUpdate();
            } catch (SQLException e) {
                throw new ApiException(409, "Bạn đã dùng mã này rồi");
            }

            // Tăng lượt dùng có điều kiện: hết lượt thì hoàn tác bản ghi vừa chèn.
            try (PreparedStatement upd = c.prepareStatement(
                    "UPDATE giftcodes SET used_count = used_count + 1 WHERE code = ? AND used_count < max_uses")) {
                upd.setString(1, code);
                if (upd.executeUpdate() == 0) {
                    try (PreparedStatement del = c.prepareStatement(
                            "DELETE FROM giftcode_uses WHERE code = ? AND player_id = ?")) {
                        del.setString(1, code);
                        del.setInt(2, playerId);
                        del.executeUpdate();
                    }
                    throw new ApiException(409, "Mã đã hết lượt sử dụng");
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi dùng mã: " + e.getMessage());
        }

        long mailId = mail.send(playerId, "Quà từ mã " + code,
                "Cảm ơn bạn đã đồng hành cùng MyZoo!", rewardVang, rewardKc, foodId, foodQty);
        return new RedeemResult(code, mailId, "Quà đã gửi vào hộp thư");
    }

    public static String normalize(String code) {
        return code == null ? "" : code.trim().toUpperCase();
    }
}
