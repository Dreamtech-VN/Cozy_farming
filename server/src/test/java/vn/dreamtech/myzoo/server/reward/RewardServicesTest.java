package vn.dreamtech.myzoo.server.reward;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.farm.FarmService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.mail.MailService;
import vn.dreamtech.myzoo.server.player.PlayerService;

import static org.junit.jupiter.api.Assertions.*;

class RewardServicesTest {
    TestSupport.FakeTime time;
    EconomyService economy;
    PlayerService players;
    FarmService farm;
    MailService mail;
    GiftcodeService giftcodes;
    AchievementService achievements;
    int playerId, other;

    @BeforeEach
    void setUp() {
        var db = TestSupport.newDb();
        time = new TestSupport.FakeTime();
        economy = new EconomyService(db, time);
        players = new PlayerService(db, economy, time);
        farm = new FarmService(db, economy, players, time);
        mail = new MailService(db, economy, players, time);
        giftcodes = new GiftcodeService(db, mail, players, time);
        achievements = new AchievementService(db, economy, players, time);
        playerId = players.guestLogin(null).playerId();
        other = players.guestLogin(null).playerId();
    }

    // ---------- Hộp thư ----------
    @Test
    void mailClaimPaysOnce() {
        long id = mail.send(playerId, "Quà", "Chúc mừng", 300, 5, "wheat", 2);
        assertEquals(1, mail.inbox(playerId).size());
        assertFalse(mail.inbox(playerId).get(0).claimed());

        var result = mail.claim(playerId, id);
        assertEquals(300, result.rewardVang());
        assertEquals(1300, result.vangBalance());
        assertEquals(5, result.kcBalance());
        assertEquals(2, TestSupport.qty(farm.storage(playerId), "wheat"));
        assertTrue(mail.inbox(playerId).get(0).claimed());

        assertEquals(409, assertThrows(ApiException.class, () -> mail.claim(playerId, id)).status());
        assertEquals(1300, economy.balances(playerId).get(EconomyService.VANG));
    }

    @Test
    void mailOfOtherPlayerNotVisible() {
        long id = mail.send(other, "Quà", "x", 100, 0, null, 0);
        assertTrue(mail.inbox(playerId).isEmpty());
        assertEquals(404, assertThrows(ApiException.class, () -> mail.claim(playerId, id)).status());
    }

    @Test
    void expiredMailDisappearsAndCannotBeClaimed() {
        long id = mail.send(playerId, "Quà", "x", 100, 0, null, 0);
        time.advance(MailService.DEFAULT_TTL_MS + 1000);
        assertTrue(mail.inbox(playerId).isEmpty());
        assertEquals(404, assertThrows(ApiException.class, () -> mail.claim(playerId, id)).status());
    }

    @Test
    void claimAllTakesEveryUnclaimedMail() {
        mail.send(playerId, "A", "x", 100, 0, null, 0);
        mail.send(playerId, "B", "x", 200, 0, null, 0);
        assertEquals(2, mail.claimAll(playerId));
        assertEquals(1300, economy.balances(playerId).get(EconomyService.VANG));
        assertEquals(0, mail.claimAll(playerId));
    }

    // ---------- Giftcode ----------
    @Test
    void redeemSendsMailAndBlocksReuse() {
        giftcodes.create("TET2026", 500, 10, "carrot", 3, 100, time.now() + 86_400_000L);
        var result = giftcodes.redeem(playerId, "tet2026");   // không phân biệt hoa thường
        assertEquals("TET2026", result.code());

        var inbox = mail.inbox(playerId);
        assertEquals(1, inbox.size());
        assertEquals(500, inbox.get(0).rewardVang());

        assertEquals(409, assertThrows(ApiException.class, () -> giftcodes.redeem(playerId, "TET2026")).status());
        assertEquals(1, mail.inbox(playerId).size());
    }

    @Test
    void redeemRespectsUseLimitAndExpiry() {
        giftcodes.create("ONE", 100, 0, null, 0, 1, time.now() + 86_400_000L);
        giftcodes.redeem(playerId, "ONE");
        assertEquals(409, assertThrows(ApiException.class, () -> giftcodes.redeem(other, "ONE")).status());

        giftcodes.create("OLD", 100, 0, null, 0, 10, time.now() + 1000);
        time.advance(2000);
        assertEquals(409, assertThrows(ApiException.class, () -> giftcodes.redeem(playerId, "OLD")).status());
        assertEquals(404, assertThrows(ApiException.class, () -> giftcodes.redeem(playerId, "KHONGCO")).status());
    }

    @Test
    void duplicateCodeRejected() {
        giftcodes.create("DUP", 100, 0, null, 0, 10, time.now() + 86_400_000L);
        assertEquals(409, assertThrows(ApiException.class,
                () -> giftcodes.create("DUP", 200, 0, null, 0, 10, time.now() + 86_400_000L)).status());
    }

    // ---------- Thành tựu ----------
    @Test
    void achievementProgressAccumulatesForever() {
        achievements.record(playerId, "PLANT", 30);
        time.advance(3 * 24 * 60 * 60 * 1000L);   // khác nhiệm vụ ngày: KHÔNG reset
        achievements.record(playerId, "PLANT", 25);
        assertEquals(50, find("plant_50").progress());
        assertEquals(55, achievements.counters(playerId).get("PLANT"));
    }

    @Test
    void achievementClaimOnlyWhenDoneAndOnce() {
        assertEquals(409, assertThrows(ApiException.class, () -> achievements.claim(playerId, "plant_50")).status());
        achievements.record(playerId, "PLANT", 50);
        var result = achievements.claim(playerId, "plant_50");
        assertEquals(500, result.rewardVang());
        assertEquals(1500, result.vangBalance());
        assertEquals(409, assertThrows(ApiException.class, () -> achievements.claim(playerId, "plant_50")).status());
        assertEquals(404, assertThrows(ApiException.class, () -> achievements.claim(playerId, "khong-co")).status());
    }

    // ---------- Bộ sưu tập ----------
    @Test
    void collectionCountsEachSpeciesOnce() {
        var before = achievements.collection(playerId);
        assertEquals(6, before.size());
        assertFalse(before.get(0).owned());

        achievements.recordSpecies(playerId, "rabbit");
        achievements.recordSpecies(playerId, "rabbit");   // mua con thứ 2 cùng loài
        achievements.recordSpecies(playerId, "sheep");

        assertEquals(2, achievements.counters(playerId).get("SPECIES"));
        long ownedCount = achievements.collection(playerId).stream().filter(e -> e.owned()).count();
        assertEquals(2, ownedCount);
    }

    AchievementService.AchievementView find(String id) {
        return achievements.view(playerId).stream().filter(a -> a.id().equals(id)).findFirst().orElseThrow();
    }
}
