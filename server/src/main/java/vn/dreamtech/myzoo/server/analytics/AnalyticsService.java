package vn.dreamtech.myzoo.server.analytics;

import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.http.JsonHttp;
import vn.dreamtech.myzoo.server.time.TimeSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

// Ghi sự kiện để sau khi ra mắt còn đo được (spec §27.21). Ghi hỏng không bao giờ được làm hỏng
// hành động chính của người chơi — mất một dòng thống kê nhẹ hơn nhiều so với mất một giao dịch.
public final class AnalyticsService {
    public static final String LOGIN = "login";
    public static final String CHARACTER_CREATE = "character_create";
    public static final String GACHA_PULL = "gacha_pull";
    public static final String PREMIUM_PURCHASE = "premium_purchase";
    public static final String MISSION_CLAIM = "mission_claim";
    public static final String ZOO_COLLECT = "zoo_collect";

    private static final int MAX_PROPS_LENGTH = 500;

    private final DataSource dataSource;
    private final TimeSource time;

    public AnalyticsService(DataSource dataSource, TimeSource time) {
        this.dataSource = dataSource;
        this.time = time;
    }

    public record EventCount(String event, int count) {
    }

    public record Summary(int days, int activePlayers, int totalEvents, List<EventCount> events) {
    }

    public void track(Integer playerId, String event, Map<String, Object> props) {
        try {
            String json = props == null || props.isEmpty() ? null : JsonHttp.GSON.toJson(props);
            if (json != null && json.length() > MAX_PROPS_LENGTH) json = json.substring(0, MAX_PROPS_LENGTH);
            long now = time.now();
            try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                    "INSERT INTO analytics_events (player_id, event, props, day_key, created_at) "
                            + "VALUES (?, ?, ?, ?, ?)")) {
                if (playerId == null) ps.setNull(1, java.sql.Types.INTEGER); else ps.setInt(1, playerId);
                ps.setString(2, event);
                ps.setString(3, json);
                ps.setString(4, LocalDate.ofInstant(Instant.ofEpochMilli(now), ZoneOffset.UTC).toString());
                ps.setTimestamp(5, new Timestamp(now));
                ps.executeUpdate();
            }
        } catch (SQLException | RuntimeException ignored) {
            // Cố tình nuốt lỗi: xem chú thích ở đầu lớp.
        }
    }

    public Summary summary(int days) {
        int window = days <= 0 || days > 90 ? 7 : days;
        long from = time.now() - window * 24L * 60 * 60 * 1000;
        List<EventCount> events = new ArrayList<>();
        int total = 0;
        int active = 0;
        try (Connection c = dataSource.getConnection()) {
            try (PreparedStatement ps = c.prepareStatement(
                    "SELECT event, COUNT(*) AS n FROM analytics_events WHERE created_at >= ? "
                            + "GROUP BY event ORDER BY n DESC")) {
                ps.setTimestamp(1, new Timestamp(from));
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int n = rs.getInt("n");
                        total += n;
                        events.add(new EventCount(rs.getString("event"), n));
                    }
                }
            }
            try (PreparedStatement ps = c.prepareStatement(
                    "SELECT COUNT(DISTINCT player_id) FROM analytics_events "
                            + "WHERE created_at >= ? AND player_id IS NOT NULL")) {
                ps.setTimestamp(1, new Timestamp(from));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) active = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc thống kê: " + e.getMessage());
        }
        return new Summary(window, active, total, events);
    }
}
