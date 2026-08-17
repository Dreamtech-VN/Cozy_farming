package vn.dreamtech.myzoo.server.mission;

import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;
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
import java.time.temporal.WeekFields;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public final class MissionService {
    public static final String DAILY = "DAILY";
    public static final String WEEKLY = "WEEKLY";
    public static final String EVENT = "EVENT";

    // Nhiệm vụ nằm trong bảng mission_defs chứ không phải hằng số Java, để bật/tắt sự kiện
    // và đổi mốc thưởng mà không cần build lại (spec §11).
    public record MissionDef(String id, String name, String type, int target, long rewardVang, long rewardKc,
                             String scope, String eventId, Long activeFrom, Long activeTo, int sortOrder) {
    }

    // Bộ nhiệm vụ khởi tạo lần đầu. Sửa trong DB sau đó sẽ không bị ghi đè.
    private static final List<MissionDef> SEED = List.of(
            new MissionDef("plant_5", "Trồng 5 cây", "PLANT", 5, 100, 0, DAILY, null, null, null, 1),
            new MissionDef("harvest_8", "Thu hoạch 8 lần", "HARVEST", 8, 150, 0, DAILY, null, null, null, 2),
            new MissionDef("feed_5", "Cho 5 con thú ăn", "FEED", 5, 150, 0, DAILY, null, null, null, 3),
            new MissionDef("sell_10", "Bán 10 nông sản", "SELL", 10, 100, 0, DAILY, null, null, null, 4),
            new MissionDef("minigame_2", "Chơi 2 ván minigame", "MINIGAME", 2, 100, 0, DAILY, null, null, null, 5),
            new MissionDef("collect_1", "Thu doanh thu sở thú", "COLLECT", 1, 100, 0, DAILY, null, null, null, 6),

            new MissionDef("w_harvest_50", "Thu hoạch 50 lần trong tuần", "HARVEST", 50, 800, 0,
                    WEEKLY, null, null, null, 11),
            new MissionDef("w_feed_30", "Cho 30 con thú ăn trong tuần", "FEED", 30, 800, 0,
                    WEEKLY, null, null, null, 12),
            new MissionDef("w_minigame_10", "Chơi 10 ván minigame trong tuần", "MINIGAME", 10, 600, 0,
                    WEEKLY, null, null, null, 13),
            new MissionDef("w_livestock_20", "Thu 20 sản phẩm chăn nuôi trong tuần", "LIVESTOCK", 20, 700, 0,
                    WEEKLY, null, null, null, 14),
            // Nguồn Kim Cương miễn phí duy nhất ngoài nạp — mỗi tuần đúng 25 KC, khoảng 1 lượt quay/tháng.
            new MissionDef("w_help_10", "Giúp bạn bè 10 lượt trong tuần", "FRIEND_HELP", 10, 400, 25,
                    WEEKLY, null, null, null, 15));

    private final DataSource dataSource;
    private final EconomyService economy;
    private final PlayerService players;
    private final TimeSource time;

    public MissionService(DataSource dataSource, EconomyService economy, PlayerService players, TimeSource time) {
        this.dataSource = dataSource;
        this.economy = economy;
        this.players = players;
        this.time = time;
        seedDefs();
    }

    public record MissionView(String id, String name, String scope, int target, int progress,
                              long rewardVang, long rewardKc, boolean claimed, Long endsAt) {
    }

    public record ClaimResult(String missionId, long rewardVang, long rewardKc, long vangBalance, long kcBalance) {
    }

    public record CheckinResult(String day, int streak, long rewardVang, long vangBalance) {
    }

    public String day() {
        return LocalDate.ofInstant(Instant.ofEpochMilli(time.now()), ZoneOffset.UTC).toString();
    }

    public String week() {
        LocalDate date = LocalDate.ofInstant(Instant.ofEpochMilli(time.now()), ZoneOffset.UTC);
        WeekFields iso = WeekFields.of(Locale.UK);   // tuần bắt đầu thứ Hai theo chuẩn ISO
        return date.get(iso.weekBasedYear()) + "-W" + String.format("%02d", date.get(iso.weekOfWeekBasedYear()));
    }

    // Khoá chu kỳ dùng chung một cột: ngày cho DAILY, tuần cho WEEKLY, mã sự kiện cho EVENT.
    public String periodKey(MissionDef def) {
        return switch (def.scope()) {
            case WEEKLY -> week();
            case EVENT -> "E:" + (def.eventId() == null ? def.id() : def.eventId());
            default -> day();
        };
    }

    public void record(int playerId, String type, int amount) {
        if (amount <= 0) return;
        for (MissionDef def : activeDefs()) {
            if (!def.type().equals(type)) continue;
            String period = periodKey(def);
            try (Connection c = dataSource.getConnection()) {
                int updated;
                try (PreparedStatement upd = c.prepareStatement(
                        "UPDATE mission_progress SET progress = progress + ? "
                                + "WHERE player_id = ? AND mission_id = ? AND day_key = ?")) {
                    upd.setInt(1, amount);
                    upd.setInt(2, playerId);
                    upd.setString(3, def.id());
                    upd.setString(4, period);
                    updated = upd.executeUpdate();
                }
                if (updated == 0) {
                    try (PreparedStatement ins = c.prepareStatement(
                            "INSERT INTO mission_progress (player_id, mission_id, day_key, progress, claimed) "
                                    + "VALUES (?, ?, ?, ?, FALSE)")) {
                        ins.setInt(1, playerId);
                        ins.setString(2, def.id());
                        ins.setString(3, period);
                        ins.setInt(4, amount);
                        ins.executeUpdate();
                    }
                }
            } catch (SQLException e) {
                throw new ApiException(500, "Lỗi ghi nhiệm vụ: " + e.getMessage());
            }
        }
    }

    public List<MissionView> view(int playerId) {
        players.requirePlayer(playerId);
        List<MissionView> out = new ArrayList<>();
        for (MissionDef def : activeDefs()) {
            int progress = 0;
            boolean claimed = false;
            try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                    "SELECT progress, claimed FROM mission_progress "
                            + "WHERE player_id = ? AND mission_id = ? AND day_key = ?")) {
                ps.setInt(1, playerId);
                ps.setString(2, def.id());
                ps.setString(3, periodKey(def));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        progress = rs.getInt("progress");
                        claimed = rs.getBoolean("claimed");
                    }
                }
            } catch (SQLException e) {
                throw new ApiException(500, "Lỗi đọc nhiệm vụ: " + e.getMessage());
            }
            out.add(new MissionView(def.id(), def.name(), def.scope(), def.target(),
                    Math.min(progress, def.target()), def.rewardVang(), def.rewardKc(), claimed, def.activeTo()));
        }
        return out;
    }

    public ClaimResult claim(int playerId, String missionId) {
        players.requirePlayer(playerId);
        MissionDef def = activeDefs().stream().filter(d -> d.id().equals(missionId)).findFirst()
                .orElseThrow(() -> new ApiException(404, "Không có nhiệm vụ này"));
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE mission_progress SET claimed = TRUE WHERE player_id = ? AND mission_id = ? "
                        + "AND day_key = ? AND claimed = FALSE AND progress >= ?")) {
            ps.setInt(1, playerId);
            ps.setString(2, missionId);
            ps.setString(3, periodKey(def));
            ps.setInt(4, def.target());
            if (ps.executeUpdate() == 0) {
                throw new ApiException(409, "Nhiệm vụ chưa xong hoặc đã nhận thưởng");
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi nhận thưởng: " + e.getMessage());
        }
        long vang = economy.earn(playerId, EconomyService.VANG, def.rewardVang(), "MISSION", "mission", missionId);
        long kc = def.rewardKc() > 0
                ? economy.earn(playerId, EconomyService.KIM_CUONG, def.rewardKc(), "MISSION", "mission", missionId)
                : economy.balances(playerId).get(EconomyService.KIM_CUONG);
        return new ClaimResult(missionId, def.rewardVang(), def.rewardKc(), vang, kc);
    }

    public CheckinResult checkin(int playerId) {
        players.requirePlayer(playerId);
        LocalDate today = LocalDate.ofInstant(Instant.ofEpochMilli(time.now()), ZoneOffset.UTC);
        int streak = 1;
        try (Connection c = dataSource.getConnection()) {
            try (PreparedStatement ps = c.prepareStatement(
                    "SELECT streak FROM daily_checkin WHERE player_id = ? AND day_key = ?")) {
                ps.setInt(1, playerId);
                ps.setString(2, today.minusDays(1).toString());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) streak = rs.getInt("streak") + 1;
                }
            }
            try (PreparedStatement ins = c.prepareStatement(
                    "INSERT INTO daily_checkin (player_id, day_key, streak) VALUES (?, ?, ?)")) {
                ins.setInt(1, playerId);
                ins.setString(2, today.toString());
                ins.setInt(3, streak);
                ins.executeUpdate();
            }
        } catch (SQLException e) {
            throw new ApiException(409, "Hôm nay đã điểm danh rồi");
        }
        long reward = 100 + Math.min(streak, 7) * 50L;
        long balance = economy.earn(playerId, EconomyService.VANG, reward, "CHECKIN", "day", today.toString());
        return new CheckinResult(today.toString(), streak, reward, balance);
    }

    public List<MissionDef> activeDefs() {
        long now = time.now();
        List<MissionDef> out = new ArrayList<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT id, name, type, target, reward_vang, reward_kc, scope, event_id, active_from, active_to, "
                        + "sort_order FROM mission_defs ORDER BY sort_order, id")) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Timestamp from = rs.getTimestamp("active_from");
                    Timestamp to = rs.getTimestamp("active_to");
                    if (from != null && from.getTime() > now) continue;
                    if (to != null && to.getTime() <= now) continue;
                    out.add(new MissionDef(rs.getString("id"), rs.getString("name"), rs.getString("type"),
                            rs.getInt("target"), rs.getLong("reward_vang"), rs.getLong("reward_kc"),
                            rs.getString("scope"), rs.getString("event_id"),
                            from == null ? null : from.getTime(), to == null ? null : to.getTime(),
                            rs.getInt("sort_order")));
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc danh sách nhiệm vụ: " + e.getMessage());
        }
        return out;
    }

    private void seedDefs() {
        try (Connection c = dataSource.getConnection()) {
            try (PreparedStatement check = c.prepareStatement("SELECT COUNT(*) FROM mission_defs")) {
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) return;
                }
            }
            try (PreparedStatement ins = c.prepareStatement(
                    "INSERT INTO mission_defs (id, name, type, target, reward_vang, reward_kc, scope, sort_order) "
                            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
                for (MissionDef def : SEED) {
                    ins.setString(1, def.id());
                    ins.setString(2, def.name());
                    ins.setString(3, def.type());
                    ins.setInt(4, def.target());
                    ins.setLong(5, def.rewardVang());
                    ins.setLong(6, def.rewardKc());
                    ins.setString(7, def.scope());
                    ins.setInt(8, def.sortOrder());
                    ins.executeUpdate();
                }
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Không tạo được danh sách nhiệm vụ: " + e.getMessage(), e);
        }
    }
}
