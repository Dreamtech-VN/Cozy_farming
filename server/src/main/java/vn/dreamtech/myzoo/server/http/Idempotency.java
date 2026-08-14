package vn.dreamtech.myzoo.server.http;

import vn.dreamtech.myzoo.server.time.TimeSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.function.Supplier;

// Spec RULE 02/§27.17: retry cùng requestId trả lại đúng response cũ, không chạy transaction lần 2.
public final class Idempotency {
    private final DataSource dataSource;
    private final TimeSource time;

    public Idempotency(DataSource dataSource, TimeSource time) {
        this.dataSource = dataSource;
        this.time = time;
    }

    public String execute(String requestId, int playerId, Supplier<Object> action) {
        if (requestId == null || requestId.isBlank()) {
            return JsonHttp.GSON.toJson(action.get());
        }
        String existing = find(requestId);
        if (existing != null) return existing;

        String response = JsonHttp.GSON.toJson(action.get());
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO idempotency (request_id, player_id, response, created_at) VALUES (?, ?, ?, ?)")) {
            ps.setString(1, requestId);
            ps.setInt(2, playerId);
            ps.setString(3, response);
            ps.setTimestamp(4, new Timestamp(time.now()));
            ps.executeUpdate();
        } catch (SQLException e) {
            // Đụng độ khoá (2 request song song cùng id): trả bản đã lưu của request thắng cuộc.
            String winner = find(requestId);
            if (winner != null) return winner;
            throw new ApiException(500, "Lỗi lưu idempotency: " + e.getMessage());
        }
        return response;
    }

    private String find(String requestId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT response FROM idempotency WHERE request_id = ?")) {
            ps.setString(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString("response") : null;
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc idempotency: " + e.getMessage());
        }
    }
}
