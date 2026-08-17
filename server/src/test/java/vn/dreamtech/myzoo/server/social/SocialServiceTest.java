package vn.dreamtech.myzoo.server.social;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.farm.FarmService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;
import vn.dreamtech.myzoo.server.zoo.ZooService;

import static org.junit.jupiter.api.Assertions.*;

class SocialServiceTest {
    TestSupport.FakeTime time;
    EconomyService economy;
    PlayerService players;
    SocialService social;
    int an, binh;

    @BeforeEach
    void setUp() {
        var db = TestSupport.newDb();
        time = new TestSupport.FakeTime();
        economy = new EconomyService(db, time);
        players = new PlayerService(db, economy, time);
        var farm = new FarmService(db, economy, players, time);
        var zoo = new ZooService(db, economy, farm, players, time);
        social = new SocialService(db, economy, players, farm, zoo, time);

        an = players.guestLogin(null).playerId();
        binh = players.guestLogin(null).playerId();
        players.createCharacter(an, "An", "farmer_1");
        players.createCharacter(binh, "Bình", "farmer_2");
    }

    void makeFriends() {
        social.sendRequest(an, "Bình");
        social.accept(binh, an);
    }

    @Test
    void requestThenAcceptCreatesFriendship() {
        social.sendRequest(an, "Bình");
        assertEquals(1, social.view(binh).incoming().size());
        assertEquals(1, social.view(an).outgoing().size());
        assertTrue(social.view(an).friends().isEmpty());

        social.accept(binh, an);
        assertEquals(1, social.view(an).friends().size());
        assertEquals("Bình", social.view(an).friends().get(0).name());
        assertEquals(1, social.view(binh).friends().size());
    }

    @Test
    void duplicateAndSelfRequestRejected() {
        assertEquals(400, assertThrows(ApiException.class, () -> social.sendRequest(an, "An")).status());
        social.sendRequest(an, "Bình");
        assertEquals(409, assertThrows(ApiException.class, () -> social.sendRequest(an, "Bình")).status());
        assertEquals(409, assertThrows(ApiException.class, () -> social.sendRequest(binh, "An")).status());
        assertEquals(404, assertThrows(ApiException.class, () -> social.sendRequest(an, "KhongCo")).status());
    }

    @Test
    void removeWorksForBothPendingAndAccepted() {
        social.sendRequest(an, "Bình");
        social.remove(binh, an);                 // từ chối lời mời
        assertTrue(social.view(binh).incoming().isEmpty());

        makeFriends();
        social.remove(an, binh);                 // huỷ kết bạn
        assertTrue(social.view(an).friends().isEmpty());
        assertEquals(404, assertThrows(ApiException.class, () -> social.remove(an, binh)).status());
    }

    @Test
    void visitOnlyAllowedForFriends() {
        assertEquals(403, assertThrows(ApiException.class, () -> social.visit(an, binh)).status());
        makeFriends();
        var visit = social.visit(an, binh);
        assertEquals("Bình", visit.name());
        assertEquals(48, visit.plots().size());
        assertTrue(visit.canHelp());
        assertNotNull(social.visit(an, an));     // tự xem vườn mình luôn được
    }

    @Test
    void helpPaysBothSidesOncePerDay() {
        makeFriends();
        long anBefore = economy.balances(an).get(EconomyService.VANG);
        long binhBefore = economy.balances(binh).get(EconomyService.VANG);

        var result = social.help(an, binh);
        assertEquals(SocialService.HELP_REWARD_VANG, result.vangEarned());
        assertEquals(anBefore + SocialService.HELP_REWARD_VANG, economy.balances(an).get(EconomyService.VANG));
        assertEquals(binhBefore + SocialService.HELP_REWARD_VANG / 2, economy.balances(binh).get(EconomyService.VANG));
        assertEquals(SocialService.MAX_HELP_PER_DAY - 1, result.helpsLeftToday());

        assertEquals(409, assertThrows(ApiException.class, () -> social.help(an, binh)).status());
        assertFalse(social.visit(an, binh).canHelp());

        time.advance(24 * 60 * 60 * 1000L);
        assertEquals(SocialService.HELP_REWARD_VANG, social.help(an, binh).vangEarned());
    }

    @Test
    void helpRequiresFriendship() {
        assertEquals(403, assertThrows(ApiException.class, () -> social.help(an, binh)).status());
        assertEquals(400, assertThrows(ApiException.class, () -> social.help(an, an)).status());
    }

    @Test
    void leaderboardRanksByXpDescending() {
        players.addZooXp(an, 500);
        players.addZooXp(binh, 900);
        var rows = social.leaderboard("zoo", 10);
        assertEquals(2, rows.size());
        assertEquals("Bình", rows.get(0).name());
        assertEquals(1, rows.get(0).rank());
        assertEquals(900, rows.get(0).score());
        assertEquals("An", rows.get(1).name());

        players.addFarmXp(an, 2000);
        assertEquals("An", social.leaderboard("farm", 10).get(0).name());
        assertEquals(400, assertThrows(ApiException.class, () -> social.leaderboard("bua-bai", 10)).status());
    }
}
