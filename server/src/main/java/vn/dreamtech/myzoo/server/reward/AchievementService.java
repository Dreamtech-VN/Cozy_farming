package vn.dreamtech.myzoo.server.reward;

import vn.dreamtech.myzoo.server.catalog.Catalog;
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
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

// Thành tựu tích luỹ trọn đời (khác nhiệm vụ ngày: không reset) + bộ sưu tập loài đã nuôi.
public final class AchievementService {
    public record AchievementDef(String id, String type, int target, long rewardVang, String name) {
    }

    public static final List<AchievementDef> DEFS = List.of(
            new AchievementDef("plant_50", "PLANT", 50, 500, "Trồng 50 cây"),
            new AchievementDef("plant_500", "PLANT", 500, 3000, "Trồng 500 cây"),
            new AchievementDef("harvest_100", "HARVEST", 100, 800, "Thu hoạch 100 lần"),
            new AchievementDef("feed_100", "FEED", 100, 800, "Cho thú ăn 100 lần"),
            new AchievementDef("collect_50", "COLLECT", 50, 1000, "Thu doanh thu 50 lần"),
            new AchievementDef("species_3", "SPECIES", 3, 700, "Sưu tầm 3 loài thú"),
            new AchievementDef("species_6", "SPECIES", 6, 2500, "Sưu tầm đủ 6 loài thú"),
            new AchievementDef("friend_5", "FRIEND_HELP", 5, 600, "Giúp bạn bè 5 lần"));

    private final DataSource dataSource;
    private final EconomyService economy;
    private final PlayerService players;
    private final TimeSource time;

    public AchievementService(DataSource dataSource, EconomyService economy, PlayerService players, TimeSource time) {
        this.dataSource = dataSource;
        this.economy = economy;
        this.players = players;
        this.time = time;
    }

    public record AchievementView(String id, String name, int target, int progress, long rewardVang, boolean claimed) {
    }

    public record ClaimResult(String achievementId, long rewardVang, long vangBalance) {
    }

    public record SpeciesEntry(String speciesId, String name, String rarity, int appeal, boolean owned, long firstOwnedAt) {
    }

    public void record(int playerId, String type, int amount) {
        if (amount <= 0) return;
        try (Connection c = dataSource.getConnection()) {
            int updated;
            try (PreparedStatement upd = c.prepareStatement(
                    "UPDATE achievement_counters SET counter = counter + ? WHERE player_id = ? AND counter_type = ?")) {
                upd.setInt(1, amount);
                upd.setInt(2, playerId);
                upd.setString(3, type);
                updated = upd.executeUpdate();
            }
            if (updated == 0) {
                try (PreparedStatement ins = c.prepareStatement(
                        "INSERT INTO achievement_counters (player_id, counter_type, counter) VALUES (?, ?, ?)")) {
                    ins.setInt(1, playerId);
                    ins.setString(2, type);
                    ins.setInt(3, amount);
                    ins.executeUpdate();
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi ghi thành tựu: " + e.getMessage());
        }
    }

    // Gọi khi mua thú: ghi vào bộ sưu tập, lần đầu mới tính.
    public void recordSpecies(int playerId, String speciesId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO species_collection (player_id, species_id, first_owned_at) VALUES (?, ?, ?)")) {
            ps.setInt(1, playerId);
            ps.setString(2, speciesId);
            ps.setTimestamp(3, new Timestamp(time.now()));
            ps.executeUpdate();
        } catch (SQLException e) {
            return;   // đã có loài này, không tính lại
        }
        record(playerId, "SPECIES", 1);
    }

    public List<AchievementView> view(int playerId) {
        players.requirePlayer(playerId);
        Map<String, Integer> counters = counters(playerId);
        Map<String, Boolean> claimed = claimedMap(playerId);
        List<AchievementView> out = new ArrayList<>();
        for (AchievementDef def : DEFS) {
            int progress = counters.getOrDefault(def.type(), 0);
            out.add(new AchievementView(def.id(), def.name(), def.target(),
                    Math.min(progress, def.target()), def.rewardVang(),
                    Boolean.TRUE.equals(claimed.get(def.id()))));
        }
        return out;
    }

    public ClaimResult claim(int playerId, String achievementId) {
        players.requirePlayer(playerId);
        AchievementDef def = DEFS.stream().filter(d -> d.id().equals(achievementId)).findFirst()
                .orElseThrow(() -> new ApiException(404, "Không có thành tựu này"));
        if (counters(playerId).getOrDefault(def.type(), 0) < def.target()) {
            throw new ApiException(409, "Thành tựu chưa hoàn thành");
        }
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO achievement_claims (player_id, achievement_id, created_at) VALUES (?, ?, ?)")) {
            ps.setInt(1, playerId);
            ps.setString(2, achievementId);
            ps.setTimestamp(3, new Timestamp(time.now()));
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(409, "Thành tựu này đã nhận thưởng");
        }
        long balance = economy.earn(playerId, EconomyService.VANG, def.rewardVang(),
                "ACHIEVEMENT", "achievement", achievementId);
        return new ClaimResult(achievementId, def.rewardVang(), balance);
    }

    public List<SpeciesEntry> collection(int playerId) {
        players.requirePlayer(playerId);
        Map<String, Long> owned = new LinkedHashMap<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT species_id, first_owned_at FROM species_collection WHERE player_id = ?")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) owned.put(rs.getString("species_id"), rs.getTimestamp("first_owned_at").getTime());
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc bộ sưu tập: " + e.getMessage());
        }
        List<SpeciesEntry> out = new ArrayList<>();
        for (Catalog.SpeciesDef species : Catalog.SPECIES) {
            Long at = owned.get(species.id());
            out.add(new SpeciesEntry(species.id(), species.name(), species.rarity(), species.appeal(),
                    at != null, at == null ? 0 : at));
        }
        return out;
    }

    Map<String, Integer> counters(int playerId) {
        Map<String, Integer> out = new LinkedHashMap<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT counter_type, counter FROM achievement_counters WHERE player_id = ?")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.put(rs.getString("counter_type"), rs.getInt("counter"));
            }
            return out;
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc tiến độ thành tựu: " + e.getMessage());
        }
    }

    private Map<String, Boolean> claimedMap(int playerId) {
        Map<String, Boolean> out = new LinkedHashMap<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT achievement_id FROM achievement_claims WHERE player_id = ?")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.put(rs.getString("achievement_id"), true);
            }
            return out;
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc thành tựu đã nhận: " + e.getMessage());
        }
    }
}
