package vn.dreamtech.myzoo.server.gacha;

import vn.dreamtech.myzoo.server.catalog.CosmeticCatalog;
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
import java.util.Random;

// Quay số. Toàn bộ RNG, pity và việc cấp đồ đều ở server (spec §27.8, 27.25).
public final class GachaService {
    public static final String DEFAULT_BANNER = "cozy_start";
    public static final int PITY_THRESHOLD = 80;
    public static final int COST_SINGLE = 100;
    public static final int COST_TEN = 900;
    public static final int TEN_PULL = 10;
    public static final int EXCHANGE_COST = 100;

    // Tỉ lệ công bố: R 79% · SR 17% · SSR 3.5% · UR 0.5%. Lưu dạng phần vạn để tính bằng số nguyên.
    // Dùng LinkedHashMap dựng tay chứ không Map.of vì cần giữ thứ tự R → UR cho bảng tỉ lệ hiển thị.
    private static final Map<String, Integer> DEFAULT_WEIGHTS = defaultWeights();

    private static Map<String, Integer> defaultWeights() {
        Map<String, Integer> weights = new LinkedHashMap<>();
        weights.put(CosmeticCatalog.R, 7900);
        weights.put(CosmeticCatalog.SR, 1700);
        weights.put(CosmeticCatalog.SSR, 350);
        weights.put(CosmeticCatalog.UR, 50);
        return weights;
    }

    private static final Map<String, Integer> FRAGMENTS_BY_TIER = Map.of(
            CosmeticCatalog.R, 1,
            CosmeticCatalog.SR, 5,
            CosmeticCatalog.SSR, 20,
            CosmeticCatalog.UR, 50);

    private final DataSource dataSource;
    private final EconomyService economy;
    private final PlayerService players;
    private final CosmeticService cosmetics;
    private final TimeSource time;
    private final Random random;

    public GachaService(DataSource dataSource, EconomyService economy, PlayerService players,
                        CosmeticService cosmetics, TimeSource time) {
        this(dataSource, economy, players, cosmetics, time, new Random());
    }

    // Random tiêm được để test kiểm tra phân phối bằng seed cố định.
    public GachaService(DataSource dataSource, EconomyService economy, PlayerService players,
                        CosmeticService cosmetics, TimeSource time, Random random) {
        this.dataSource = dataSource;
        this.economy = economy;
        this.players = players;
        this.cosmetics = cosmetics;
        this.time = time;
        this.random = random;
        seedDefaultBanner();
    }

    public record RateRow(String tier, double percent) {
    }

    public record BannerView(String id, String name, int costSingle, int costTen, int pityThreshold,
                             Long startAt, Long endAt, List<RateRow> rates) {
    }

    public record PullResult(String cosmeticId, String name, String kind, String tier,
                             boolean duplicate, int fragments) {
    }

    public record PullBatch(String bannerId, List<PullResult> results, long kcBalance,
                            int fragments, int pityCounter) {
    }

    public record PullRow(long id, String bannerId, String cosmeticId, String name, String tier,
                          boolean duplicate, int fragments, long createdAt) {
    }

    public record ExchangeResult(String cosmeticId, int fragmentsLeft) {
    }

    // ---------- Banner ----------
    public List<BannerView> banners() {
        long now = time.now();
        List<BannerView> out = new ArrayList<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT id, name, cost_single, cost_ten, pity_threshold, start_at, end_at FROM gacha_banners")) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Timestamp start = rs.getTimestamp("start_at");
                    Timestamp end = rs.getTimestamp("end_at");
                    if (end != null && end.getTime() <= now) continue;
                    if (start != null && start.getTime() > now) continue;
                    String id = rs.getString("id");
                    out.add(new BannerView(id, rs.getString("name"), rs.getInt("cost_single"),
                            rs.getInt("cost_ten"), rs.getInt("pity_threshold"),
                            start == null ? null : start.getTime(), end == null ? null : end.getTime(),
                            rates(id)));
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc banner: " + e.getMessage());
        }
        return out;
    }

    // Tỉ lệ hiển thị cho người chơi — bắt buộc công khai theo quy định của các store.
    public List<RateRow> rates(String bannerId) {
        Map<String, Integer> weights = weights(bannerId);
        int total = weights.values().stream().mapToInt(Integer::intValue).sum();
        List<RateRow> out = new ArrayList<>();
        for (var entry : weights.entrySet()) {
            out.add(new RateRow(entry.getKey(), Math.round(entry.getValue() * 10000.0 / total) / 100.0));
        }
        return out;
    }

    // ---------- Quay ----------
    public PullBatch pull(int playerId, String bannerId, int count) {
        players.requirePlayer(playerId);
        if (count != 1 && count != TEN_PULL) throw new ApiException(400, "Chỉ quay 1 hoặc " + TEN_PULL + " lượt");
        BannerRow banner = requireOpenBanner(bannerId == null ? DEFAULT_BANNER : bannerId);

        long cost = count == 1 ? banner.costSingle : banner.costTen;
        // Trừ tiền trước; hỏng ở bước sau thì hoàn lại (giống ShopService.use hoàn vật phẩm).
        economy.spend(playerId, EconomyService.KIM_CUONG, cost, "GACHA", "banner", banner.id);

        try {
            return draw(playerId, banner, count);
        } catch (RuntimeException e) {
            economy.earn(playerId, EconomyService.KIM_CUONG, cost, "GACHA_REFUND", "banner", banner.id);
            throw e;
        }
    }

    private PullBatch draw(int playerId, BannerRow banner, int count) {
        Map<String, Integer> weights = weights(banner.id);
        int startPity = pityOf(playerId, banner.id);
        List<String> tiers = new ArrayList<>();

        int pity = startPity;
        for (int i = 0; i < count; i++) {
            // Chạm ngưỡng thì ép bậc cao, còn lại quay theo weight.
            String tier = pity + 1 >= banner.pityThreshold ? forcedHighTier(weights) : rollTier(weights);
            pity = isHigh(tier) ? 0 : pity + 1;
            tiers.add(tier);
        }

        // Bảo đảm quay 10 có ít nhất 1 SR trở lên: toàn R thì nâng lượt cuối lên SR.
        // SR không reset pity nên thay thế này không làm lệch bộ đếm tính ở trên.
        if (count == TEN_PULL && tiers.stream().allMatch(CosmeticCatalog.R::equals)) {
            tiers.set(TEN_PULL - 1, CosmeticCatalog.SR);
        }

        List<PullResult> results = new ArrayList<>();
        int gainedFragments = 0;
        int runningPity = startPity;

        for (String tier : tiers) {
            var pool = CosmeticCatalog.byTier(tier);
            var def = pool.get(random.nextInt(pool.size()));
            boolean isNew = cosmetics.grant(playerId, def.id(), "GACHA");
            int fragments = isNew ? 0 : FRAGMENTS_BY_TIER.getOrDefault(tier, 1);
            gainedFragments += fragments;

            int before = runningPity;
            runningPity = isHigh(tier) ? 0 : runningPity + 1;
            recordPull(playerId, banner.id, def.id(), tier, !isNew, fragments, before, runningPity);
            results.add(new PullResult(def.id(), def.name(), def.kind(), tier, !isNew, fragments));
        }

        savePity(playerId, banner.id, runningPity);
        int fragmentTotal = addFragments(playerId, gainedFragments);
        long kc = economy.balances(playerId).get(EconomyService.KIM_CUONG);
        return new PullBatch(banner.id, results, kc, fragmentTotal, runningPity);
    }

    private String rollTier(Map<String, Integer> weights) {
        int total = weights.values().stream().mapToInt(Integer::intValue).sum();
        int roll = random.nextInt(total);
        for (var entry : weights.entrySet()) {
            roll -= entry.getValue();
            if (roll < 0) return entry.getKey();
        }
        return CosmeticCatalog.R;
    }

    // Pity chỉ bảo đảm SSR trở lên; chia theo tỉ trọng gốc giữa SSR và UR.
    private String forcedHighTier(Map<String, Integer> weights) {
        int ssr = weights.getOrDefault(CosmeticCatalog.SSR, 1);
        int ur = weights.getOrDefault(CosmeticCatalog.UR, 0);
        if (ur <= 0) return CosmeticCatalog.SSR;
        return random.nextInt(ssr + ur) < ssr ? CosmeticCatalog.SSR : CosmeticCatalog.UR;
    }

    private static boolean isHigh(String tier) {
        return CosmeticCatalog.SSR.equals(tier) || CosmeticCatalog.UR.equals(tier);
    }

    // ---------- Đổi mảnh ----------
    public ExchangeResult exchange(int playerId, String cosmeticId) {
        players.requirePlayer(playerId);
        var def = CosmeticCatalog.cosmetic(cosmeticId)
                .orElseThrow(() -> new ApiException(404, "Không có món ngoại hình này"));
        if (!CosmeticCatalog.SSR.equals(def.tier())) {
            throw new ApiException(400, "Chỉ đổi được món bậc SSR");
        }
        if (cosmetics.ownedIds(playerId).contains(cosmeticId)) {
            throw new ApiException(409, "Bạn đã có món này rồi");
        }
        // Trừ có điều kiện: hai request song song thì chỉ một cái đủ mảnh đi qua.
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE gacha_fragments SET amount = amount - ? WHERE player_id = ? AND amount >= ?")) {
            ps.setInt(1, EXCHANGE_COST);
            ps.setInt(2, playerId);
            ps.setInt(3, EXCHANGE_COST);
            if (ps.executeUpdate() == 0) throw new ApiException(402, "Không đủ mảnh (cần " + EXCHANGE_COST + ")");
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đổi mảnh: " + e.getMessage());
        }
        cosmetics.grant(playerId, cosmeticId, "EXCHANGE");
        return new ExchangeResult(cosmeticId, fragments(playerId));
    }

    public int fragments(int playerId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT amount FROM gacha_fragments WHERE player_id = ?")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("amount") : 0;
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc mảnh: " + e.getMessage());
        }
    }

    public List<PullRow> history(int playerId, int limit) {
        int size = limit <= 0 || limit > 100 ? 50 : limit;
        List<PullRow> out = new ArrayList<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT id, banner_id, cosmetic_id, tier, duplicate, fragments, created_at FROM gacha_pulls "
                        + "WHERE player_id = ? ORDER BY id DESC LIMIT ?")) {
            ps.setInt(1, playerId);
            ps.setInt(2, size);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String id = rs.getString("cosmetic_id");
                    out.add(new PullRow(rs.getLong("id"), rs.getString("banner_id"), id,
                            CosmeticCatalog.cosmetic(id).map(CosmeticCatalog.CosmeticDef::name).orElse(id),
                            rs.getString("tier"), rs.getBoolean("duplicate"), rs.getInt("fragments"),
                            rs.getTimestamp("created_at").getTime()));
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc lịch sử quay: " + e.getMessage());
        }
        return out;
    }

    public int pityOf(int playerId, String bannerId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT counter FROM gacha_pity WHERE player_id = ? AND banner_id = ?")) {
            ps.setInt(1, playerId);
            ps.setString(2, bannerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("counter") : 0;
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc pity: " + e.getMessage());
        }
    }

    // ---------- Nội bộ ----------
    private Map<String, Integer> weights(String bannerId) {
        Map<String, Integer> out = new LinkedHashMap<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT tier, weight FROM gacha_pools WHERE banner_id = ?")) {
            ps.setString(1, bannerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.put(rs.getString("tier"), rs.getInt("weight"));
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc tỉ lệ: " + e.getMessage());
        }
        if (out.isEmpty()) return DEFAULT_WEIGHTS;
        // Giữ thứ tự R → UR cho bảng tỉ lệ hiển thị, không phụ thuộc thứ tự DB trả về.
        Map<String, Integer> ordered = new LinkedHashMap<>();
        for (String tier : DEFAULT_WEIGHTS.keySet()) {
            if (out.containsKey(tier)) ordered.put(tier, out.get(tier));
        }
        out.forEach(ordered::putIfAbsent);
        return ordered;
    }

    private BannerRow requireOpenBanner(String bannerId) {
        long now = time.now();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT id, cost_single, cost_ten, pity_threshold, start_at, end_at "
                        + "FROM gacha_banners WHERE id = ?")) {
            ps.setString(1, bannerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new ApiException(404, "Không có banner này");
                Timestamp start = rs.getTimestamp("start_at");
                Timestamp end = rs.getTimestamp("end_at");
                if (start != null && start.getTime() > now) throw new ApiException(404, "Banner chưa mở");
                if (end != null && end.getTime() <= now) throw new ApiException(404, "Banner đã kết thúc");
                return new BannerRow(rs.getString("id"), rs.getInt("cost_single"), rs.getInt("cost_ten"),
                        rs.getInt("pity_threshold"));
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc banner: " + e.getMessage());
        }
    }

    private void recordPull(int playerId, String bannerId, String cosmeticId, String tier,
                            boolean duplicate, int fragments, int pityBefore, int pityAfter) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO gacha_pulls (player_id, banner_id, cosmetic_id, tier, duplicate, fragments, "
                        + "pity_before, pity_after, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)")) {
            ps.setInt(1, playerId);
            ps.setString(2, bannerId);
            ps.setString(3, cosmeticId);
            ps.setString(4, tier);
            ps.setBoolean(5, duplicate);
            ps.setInt(6, fragments);
            ps.setInt(7, pityBefore);
            ps.setInt(8, pityAfter);
            ps.setTimestamp(9, new Timestamp(time.now()));
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi ghi lịch sử quay: " + e.getMessage());
        }
    }

    private void savePity(int playerId, String bannerId, int counter) {
        try (Connection c = dataSource.getConnection()) {
            int updated;
            try (PreparedStatement upd = c.prepareStatement(
                    "UPDATE gacha_pity SET counter = ? WHERE player_id = ? AND banner_id = ?")) {
                upd.setInt(1, counter);
                upd.setInt(2, playerId);
                upd.setString(3, bannerId);
                updated = upd.executeUpdate();
            }
            if (updated == 0) {
                try (PreparedStatement ins = c.prepareStatement(
                        "INSERT INTO gacha_pity (player_id, banner_id, counter) VALUES (?, ?, ?)")) {
                    ins.setInt(1, playerId);
                    ins.setString(2, bannerId);
                    ins.setInt(3, counter);
                    ins.executeUpdate();
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi lưu pity: " + e.getMessage());
        }
    }

    private int addFragments(int playerId, int amount) {
        if (amount <= 0) return fragments(playerId);
        try (Connection c = dataSource.getConnection()) {
            int updated;
            try (PreparedStatement upd = c.prepareStatement(
                    "UPDATE gacha_fragments SET amount = amount + ? WHERE player_id = ?")) {
                upd.setInt(1, amount);
                upd.setInt(2, playerId);
                updated = upd.executeUpdate();
            }
            if (updated == 0) {
                try (PreparedStatement ins = c.prepareStatement(
                        "INSERT INTO gacha_fragments (player_id, amount) VALUES (?, ?)")) {
                    ins.setInt(1, playerId);
                    ins.setInt(2, amount);
                    ins.executeUpdate();
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi cộng mảnh: " + e.getMessage());
        }
        return fragments(playerId);
    }

    // Banner mặc định nằm trong DB để đổi tỉ lệ/thời gian không cần build lại server.
    private void seedDefaultBanner() {
        try (Connection c = dataSource.getConnection()) {
            try (PreparedStatement check = c.prepareStatement("SELECT 1 FROM gacha_banners WHERE id = ?")) {
                check.setString(1, DEFAULT_BANNER);
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) return;
                }
            }
            try (PreparedStatement ins = c.prepareStatement(
                    "INSERT INTO gacha_banners (id, name, version, cost_single, cost_ten, pity_threshold) "
                            + "VALUES (?, ?, 1, ?, ?, ?)")) {
                ins.setString(1, DEFAULT_BANNER);
                ins.setString(2, "Tủ đồ nông trại");
                ins.setInt(3, COST_SINGLE);
                ins.setInt(4, COST_TEN);
                ins.setInt(5, PITY_THRESHOLD);
                ins.executeUpdate();
            }
            try (PreparedStatement ins = c.prepareStatement(
                    "INSERT INTO gacha_pools (banner_id, tier, weight) VALUES (?, ?, ?)")) {
                for (var entry : DEFAULT_WEIGHTS.entrySet()) {
                    ins.setString(1, DEFAULT_BANNER);
                    ins.setString(2, entry.getKey());
                    ins.setInt(3, entry.getValue());
                    ins.executeUpdate();
                }
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Không tạo được banner mặc định: " + e.getMessage(), e);
        }
    }

    private record BannerRow(String id, int costSingle, int costTen, int pityThreshold) {
    }
}
