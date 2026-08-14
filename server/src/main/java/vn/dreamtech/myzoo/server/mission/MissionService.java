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
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;

public final class MissionService {
    public record MissionDef(String id, String type, int target, long rewardVang, String name) {
    }

    public static final List<MissionDef> DEFS = List.of(
            new MissionDef("plant_5", "PLANT", 5, 100, "Trồng 5 cây"),
            new MissionDef("harvest_8", "HARVEST", 8, 150, "Thu hoạch 8 lần"),
            new MissionDef("feed_5", "FEED", 5, 150, "Cho 5 con thú ăn"),
            new MissionDef("sell_10", "SELL", 10, 100, "Bán 10 nông sản"),
            new MissionDef("minigame_2", "MINIGAME", 2, 100, "Chơi 2 ván minigame"),
            new MissionDef("collect_1", "COLLECT", 1, 100, "Thu doanh thu sở thú"));

    private final DataSource dataSource;
    private final EconomyService economy;
    private final PlayerService players;
    private final TimeSource time;

    public MissionService(DataSource dataSource, EconomyService economy, PlayerService players, TimeSource time) {
        this.dataSource = dataSource;
        this.economy = economy;
        this.players = players;
        this.time = time;
    }

    public record MissionView(String id, String name, int target, int progress, long rewardVang, boolean claimed) {
    }

    public record ClaimResult(String missionId, long rewardVang, long vangBalance) {
    }

    public record CheckinResult(String day, int streak, long rewardVang, long vangBalance) {
    }

    public String day() {
        return LocalDate.ofInstant(Instant.ofEpochMilli(time.now()), ZoneOffset.UTC).toString();
    }

    public void record(int playerId, String type, int amount) {
        if (amount <= 0) return;
        String day = day();
        for (MissionDef def : DEFS) {
            if (!def.type().equals(type)) continue;
            try (Connection c = dataSource.getConnection()) {
                int updated;
                try (PreparedStatement upd = c.prepareStatement(
                        "UPDATE mission_progress SET progress = progress + ? WHERE player_id = ? AND mission_id = ? AND day_key = ?")) {
                    upd.setInt(1, amount);
                    upd.setInt(2, playerId);
                    upd.setString(3, def.id());
                    upd.setString(4, day);
                    updated = upd.executeUpdate();
                }
                if (updated == 0) {
                    try (PreparedStatement ins = c.prepareStatement(
                            "INSERT INTO mission_progress (player_id, mission_id, day_key, progress, claimed) VALUES (?, ?, ?, ?, FALSE)")) {
                        ins.setInt(1, playerId);
                        ins.setString(2, def.id());
                        ins.setString(3, day);
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
        String day = day();
        List<MissionView> out = new ArrayList<>();
        for (MissionDef def : DEFS) {
            int progress = 0;
            boolean claimed = false;
            try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                    "SELECT progress, claimed FROM mission_progress WHERE player_id = ? AND mission_id = ? AND day_key = ?")) {
                ps.setInt(1, playerId);
                ps.setString(2, def.id());
                ps.setString(3, day);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        progress = rs.getInt("progress");
                        claimed = rs.getBoolean("claimed");
                    }
                }
            } catch (SQLException e) {
                throw new ApiException(500, "Lỗi đọc nhiệm vụ: " + e.getMessage());
            }
            out.add(new MissionView(def.id(), def.name(), def.target(), Math.min(progress, def.target()),
                    def.rewardVang(), claimed));
        }
        return out;
    }

    public ClaimResult claim(int playerId, String missionId) {
        players.requirePlayer(playerId);
        MissionDef def = DEFS.stream().filter(d -> d.id().equals(missionId)).findFirst()
                .orElseThrow(() -> new ApiException(404, "Không có nhiệm vụ này"));
        String day = day();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE mission_progress SET claimed = TRUE WHERE player_id = ? AND mission_id = ? AND day_key = ? AND claimed = FALSE AND progress >= ?")) {
            ps.setInt(1, playerId);
            ps.setString(2, missionId);
            ps.setString(3, day);
            ps.setInt(4, def.target());
            if (ps.executeUpdate() == 0) {
                throw new ApiException(409, "Nhiệm vụ chưa xong hoặc đã nhận thưởng");
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi nhận thưởng: " + e.getMessage());
        }
        long balance = economy.earn(playerId, EconomyService.VANG, def.rewardVang(), "MISSION", "mission", missionId);
        return new ClaimResult(missionId, def.rewardVang(), balance);
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
}
