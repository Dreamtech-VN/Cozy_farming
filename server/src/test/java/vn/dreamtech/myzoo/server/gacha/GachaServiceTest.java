package vn.dreamtech.myzoo.server.gacha;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.catalog.CosmeticCatalog;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;

import javax.sql.DataSource;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import static org.junit.jupiter.api.Assertions.*;

class GachaServiceTest {
    DataSource db;
    TestSupport.FakeTime time;
    EconomyService economy;
    PlayerService players;
    CosmeticService cosmetics;
    GachaService gacha;
    int an;

    @BeforeEach
    void setUp() {
        db = TestSupport.newDb();
        time = new TestSupport.FakeTime();
        economy = new EconomyService(db, time);
        players = new PlayerService(db, economy, time);
        cosmetics = new CosmeticService(db, players, time);
        gacha = new GachaService(db, economy, players, cosmetics, time, new Random(12345));
        an = players.guestLogin(null).playerId();
        players.createCharacter(an, "An", "farmer_1");
    }

    void giveKc(long amount) {
        economy.earn(an, EconomyService.KIM_CUONG, amount, "TEST", null, null);
    }

    // ---------- Tỉ lệ công bố ----------
    @Test
    void publishedRatesAddUpToOneHundredPercent() {
        var rates = gacha.rates(GachaService.DEFAULT_BANNER);
        assertEquals(4, rates.size());
        double total = rates.stream().mapToDouble(GachaService.RateRow::percent).sum();
        assertEquals(100.0, total, 0.01);
        assertEquals(CosmeticCatalog.R, rates.get(0).tier(), "bảng tỉ lệ hiện từ bậc thấp lên cao");
        assertEquals(79.0, rates.get(0).percent(), 0.01);
        assertEquals(0.5, rates.get(3).percent(), 0.01);
    }

    // Đây là test quan trọng nhất: phân phối thực tế lệch tỉ lệ công bố là rủi ro pháp lý, không chỉ là bug.
    @Test
    void actualDistributionMatchesPublishedRates() {
        giveKc(10_000L * GachaService.COST_SINGLE);
        Map<String, Integer> counts = new HashMap<>();
        for (int i = 0; i < 10_000; i++) {
            var batch = gacha.pull(an, GachaService.DEFAULT_BANNER, 1);
            String tier = batch.results().get(0).tier();
            counts.merge(tier, 1, Integer::sum);
        }

        // Biên độ đặt rộng hơn 3 lần độ lệch chuẩn của 10.000 phép thử để test không đỏ vì may rủi,
        // nhưng vẫn đủ chặt để bắt lỗi cài sai bảng trọng số.
        assertEquals(79.0, percent(counts, CosmeticCatalog.R, 10_000), 1.5);
        assertEquals(17.0, percent(counts, CosmeticCatalog.SR, 10_000), 1.5);
        assertEquals(3.5, percent(counts, CosmeticCatalog.SSR, 10_000), 0.7);
        assertEquals(0.5, percent(counts, CosmeticCatalog.UR, 10_000), 0.35);
    }

    static double percent(Map<String, Integer> counts, String tier, int total) {
        return counts.getOrDefault(tier, 0) * 100.0 / total;
    }

    // ---------- Pity ----------
    @Test
    void pityGuaranteesHighTierAtThreshold() {
        giveKc(10_000L * GachaService.COST_SINGLE);
        int pulls = 0;
        while (gacha.pityOf(an, GachaService.DEFAULT_BANNER) < GachaService.PITY_THRESHOLD - 1) {
            gacha.pull(an, GachaService.DEFAULT_BANNER, 1);
            if (++pulls > 5000) fail("không dồn được pity — bộ đếm sai");
        }
        var batch = gacha.pull(an, GachaService.DEFAULT_BANNER, 1);
        String tier = batch.results().get(0).tier();
        assertTrue(CosmeticCatalog.SSR.equals(tier) || CosmeticCatalog.UR.equals(tier),
                "chạm ngưỡng phải ra SSR trở lên, nhận được " + tier);
        assertEquals(0, batch.pityCounter(), "trúng rồi thì pity về 0");
    }

    @Test
    void pitySurvivesReconnect() {
        giveKc(50L * GachaService.COST_SINGLE);
        for (int i = 0; i < 5; i++) gacha.pull(an, GachaService.DEFAULT_BANNER, 1);
        int saved = gacha.pityOf(an, GachaService.DEFAULT_BANNER);

        // Dựng lại service như thể server khởi động lại — pity nằm ở DB nên phải còn nguyên.
        var fresh = new GachaService(db, economy, players, cosmetics, time, new Random(999));
        assertEquals(saved, fresh.pityOf(an, GachaService.DEFAULT_BANNER));
    }

    // ---------- Quay 10 ----------
    @Test
    void tenPullAlwaysContainsAtLeastOneSrOrBetter() {
        giveKc(200L * GachaService.COST_TEN);
        for (int round = 0; round < 200; round++) {
            var batch = gacha.pull(an, GachaService.DEFAULT_BANNER, GachaService.TEN_PULL);
            assertEquals(10, batch.results().size());
            assertTrue(batch.results().stream().anyMatch(r -> !CosmeticCatalog.R.equals(r.tier())),
                    "lượt quay 10 thứ " + round + " toàn bậc R");
        }
    }

    @Test
    void tenPullCostsLessThanTenSingles() {
        assertTrue(GachaService.COST_TEN < GachaService.COST_SINGLE * GachaService.TEN_PULL);
    }

    // ---------- Trùng và mảnh ----------
    @Test
    void duplicateGivesFragmentsInsteadOfNothing() {
        giveKc(400L * GachaService.COST_SINGLE);
        int fragmentsBefore = gacha.fragments(an);
        boolean sawDuplicate = false;
        for (int i = 0; i < 400 && !sawDuplicate; i++) {
            var batch = gacha.pull(an, GachaService.DEFAULT_BANNER, 1);
            var result = batch.results().get(0);
            if (result.duplicate()) {
                sawDuplicate = true;
                assertTrue(result.fragments() > 0, "trùng thì phải được mảnh");
                assertTrue(gacha.fragments(an) > fragmentsBefore);
            } else {
                assertEquals(0, result.fragments(), "món mới thì không ra mảnh");
            }
        }
        assertTrue(sawDuplicate, "pool nhỏ nên 400 lượt chắc chắn phải trùng");
    }

    @Test
    void exchangeNeedsEnoughFragmentsAndGivesChosenSsr() {
        String target = CosmeticCatalog.byTier(CosmeticCatalog.SSR).get(0).id();
        assertEquals(402, assertThrows(ApiException.class, () -> gacha.exchange(an, target)).status());

        addFragments(GachaService.EXCHANGE_COST);
        var result = gacha.exchange(an, target);
        assertEquals(0, result.fragmentsLeft());
        assertTrue(cosmetics.ownedIds(an).contains(target), "đổi xong phải sở hữu đúng món đã chọn");

        addFragments(GachaService.EXCHANGE_COST);
        assertEquals(409, assertThrows(ApiException.class, () -> gacha.exchange(an, target)).status(),
                "đã có rồi thì không đổi lại");
    }

    @Test
    void exchangeOnlyAcceptsSsr() {
        addFragments(GachaService.EXCHANGE_COST * 2);
        String rTier = CosmeticCatalog.byTier(CosmeticCatalog.R).get(0).id();
        assertEquals(400, assertThrows(ApiException.class, () -> gacha.exchange(an, rTier)).status());
        assertEquals(404, assertThrows(ApiException.class, () -> gacha.exchange(an, "khong-co")).status());
        assertEquals(GachaService.EXCHANGE_COST * 2, gacha.fragments(an), "đổi hỏng không được trừ mảnh");
    }

    void addFragments(int amount) {
        try (var c = db.getConnection()) {
            try (var upd = c.prepareStatement(
                    "UPDATE gacha_fragments SET amount = amount + ? WHERE player_id = ?")) {
                upd.setInt(1, amount);
                upd.setInt(2, an);
                if (upd.executeUpdate() > 0) return;
            }
            try (var ins = c.prepareStatement("INSERT INTO gacha_fragments (player_id, amount) VALUES (?, ?)")) {
                ins.setInt(1, an);
                ins.setInt(2, amount);
                ins.executeUpdate();
            }
        } catch (java.sql.SQLException e) {
            fail("không nạp được mảnh cho test: " + e.getMessage());
        }
    }

    // ---------- Tiền và lỗi ----------
    @Test
    void notEnoughKcRejectedAndPityUntouched() {
        giveKc(GachaService.COST_SINGLE - 1);
        int pityBefore = gacha.pityOf(an, GachaService.DEFAULT_BANNER);
        assertEquals(402, assertThrows(ApiException.class,
                () -> gacha.pull(an, GachaService.DEFAULT_BANNER, 1)).status());
        assertEquals(pityBefore, gacha.pityOf(an, GachaService.DEFAULT_BANNER), "quay hỏng không tiêu pity");
        assertTrue(gacha.history(an, 10).isEmpty(), "quay hỏng không ghi lịch sử");
    }

    @Test
    void spendingIsRecordedInLedger() {
        giveKc(GachaService.COST_SINGLE);
        gacha.pull(an, GachaService.DEFAULT_BANNER, 1);
        assertEquals(0, economy.balances(an).get(EconomyService.KIM_CUONG));
        assertTrue(economy.history(an, null, 10).stream().anyMatch(e -> e.reason().equals("GACHA")),
                "mọi lượt quay phải có dòng sổ cái");
    }

    @Test
    void unknownOrClosedBannerRejected() {
        giveKc(GachaService.COST_SINGLE);
        assertEquals(404, assertThrows(ApiException.class, () -> gacha.pull(an, "khong-co", 1)).status());

        closeDefaultBanner();
        assertEquals(404, assertThrows(ApiException.class,
                () -> gacha.pull(an, GachaService.DEFAULT_BANNER, 1)).status());
        assertTrue(gacha.banners().isEmpty(), "banner hết hạn không hiện trong danh sách");
        assertEquals(GachaService.COST_SINGLE, economy.balances(an).get(EconomyService.KIM_CUONG),
                "banner đóng thì không được trừ tiền");
    }

    void closeDefaultBanner() {
        try (var c = db.getConnection(); var ps = c.prepareStatement(
                "UPDATE gacha_banners SET end_at = ? WHERE id = ?")) {
            ps.setTimestamp(1, new java.sql.Timestamp(time.now() - 1000));
            ps.setString(2, GachaService.DEFAULT_BANNER);
            ps.executeUpdate();
        } catch (java.sql.SQLException e) {
            fail("không đóng được banner");
        }
    }

    @Test
    void onlyOneOrTenPullsAllowed() {
        giveKc(10_000);
        assertEquals(400, assertThrows(ApiException.class,
                () -> gacha.pull(an, GachaService.DEFAULT_BANNER, 3)).status());
        assertEquals(400, assertThrows(ApiException.class,
                () -> gacha.pull(an, GachaService.DEFAULT_BANNER, 0)).status());
    }

    // ---------- Ngoại hình ----------
    @Test
    void cannotEquipUnownedCosmetic() {
        String locked = CosmeticCatalog.byTier(CosmeticCatalog.UR).get(0).id();
        assertEquals(403, assertThrows(ApiException.class, () -> cosmetics.equip(an, locked)).status());
        assertEquals(404, assertThrows(ApiException.class, () -> cosmetics.equip(an, "khong-co")).status());
    }

    @Test
    void equipWorksAfterWinningAndShowsAsEquipped() {
        var avatar = CosmeticCatalog.COSMETICS.stream()
                .filter(c -> c.kind().equals(CosmeticCatalog.AVATAR)).findFirst().orElseThrow();
        cosmetics.grant(an, avatar.id(), "TEST");

        var result = cosmetics.equip(an, avatar.id());
        assertEquals(avatar.id(), result.avatar());
        assertEquals(avatar.id(), players.profile(an).avatar());
        assertTrue(cosmetics.list(an).stream().anyMatch(c -> c.id().equals(avatar.id()) && c.owned() && c.equipped()));
    }

    @Test
    void zooSkinAndAvatarEquipSeparately() {
        var avatar = CosmeticCatalog.COSMETICS.stream()
                .filter(c -> c.kind().equals(CosmeticCatalog.AVATAR)).findFirst().orElseThrow();
        var skin = CosmeticCatalog.COSMETICS.stream()
                .filter(c -> c.kind().equals(CosmeticCatalog.ZOO_SKIN)).findFirst().orElseThrow();
        cosmetics.grant(an, avatar.id(), "TEST");
        cosmetics.grant(an, skin.id(), "TEST");

        cosmetics.equip(an, avatar.id());
        var result = cosmetics.equip(an, skin.id());
        assertEquals(skin.id(), result.zooSkin());
        assertEquals(avatar.id(), result.avatar(), "mặc skin sở thú không làm mất ngoại hình nhân vật");
    }

    @Test
    void starterAvatarsAlwaysWearableButGachaOnesAreNot() {
        cosmetics.requireWearable(an, "farmer_1");
        cosmetics.requireWearable(an, null);
        String locked = CosmeticCatalog.byTier(CosmeticCatalog.SSR).get(0).id();
        assertEquals(403, assertThrows(ApiException.class,
                () -> cosmetics.requireWearable(an, locked)).status());
    }

    @Test
    void grantIsIdempotentSoDuplicateDetectionIsReliable() {
        String id = CosmeticCatalog.COSMETICS.get(0).id();
        assertTrue(cosmetics.grant(an, id, "TEST"), "lần đầu là món mới");
        assertFalse(cosmetics.grant(an, id, "TEST"), "lần sau phải báo trùng");
        assertEquals(1, cosmetics.ownedIds(an).size());
    }

    // ---------- Lịch sử ----------
    @Test
    void historyRecordsEveryPullNewestFirst() {
        giveKc(GachaService.COST_TEN);
        gacha.pull(an, GachaService.DEFAULT_BANNER, GachaService.TEN_PULL);
        var history = gacha.history(an, 50);
        assertEquals(10, history.size());
        assertTrue(history.get(0).id() > history.get(9).id(), "mới nhất đứng đầu");
        assertTrue(history.stream().allMatch(h -> h.bannerId().equals(GachaService.DEFAULT_BANNER)));
        assertTrue(history.stream().allMatch(h -> h.name() != null && !h.name().isBlank()));
    }
}
