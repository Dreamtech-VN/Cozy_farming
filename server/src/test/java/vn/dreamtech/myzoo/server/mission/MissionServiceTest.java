package vn.dreamtech.myzoo.server.mission;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;

import static org.junit.jupiter.api.Assertions.*;

class MissionServiceTest {
    TestSupport.FakeTime time;
    EconomyService economy;
    PlayerService players;
    MissionService missions;
    int playerId;

    @BeforeEach
    void setUp() {
        var db = TestSupport.newDb();
        time = new TestSupport.FakeTime();
        economy = new EconomyService(db, time);
        players = new PlayerService(db, economy, time);
        missions = new MissionService(db, economy, players, time);
        playerId = players.guestLogin(null).playerId();
    }

    MissionService.MissionView find(String id) {
        return missions.view(playerId).stream().filter(m -> m.id().equals(id)).findFirst().orElseThrow();
    }

    @Test
    void progressAccumulatesAndCapsAtTarget() {
        missions.record(playerId, "PLANT", 3);
        assertEquals(3, find("plant_5").progress());
        missions.record(playerId, "PLANT", 99);
        assertEquals(5, find("plant_5").progress());
    }

    @Test
    void claimPaysOnceAndOnlyWhenComplete() {
        assertEquals(409, assertThrows(ApiException.class, () -> missions.claim(playerId, "plant_5")).status());
        missions.record(playerId, "PLANT", 5);
        var result = missions.claim(playerId, "plant_5");
        assertEquals(100, result.rewardVang());
        assertEquals(1100, result.vangBalance());
        assertEquals(409, assertThrows(ApiException.class, () -> missions.claim(playerId, "plant_5")).status());
        assertEquals(404, assertThrows(ApiException.class, () -> missions.claim(playerId, "khong-co")).status());
    }

    @Test
    void progressResetsNextDay() {
        missions.record(playerId, "PLANT", 5);
        time.advance(24 * 60 * 60 * 1000L);
        assertEquals(0, find("plant_5").progress());
        assertEquals(409, assertThrows(ApiException.class, () -> missions.claim(playerId, "plant_5")).status());
    }

    @Test
    void checkinOncePerDayWithStreakBonus() {
        var day1 = missions.checkin(playerId);
        assertEquals(1, day1.streak());
        assertEquals(150, day1.rewardVang());
        assertEquals(409, assertThrows(ApiException.class, () -> missions.checkin(playerId)).status());

        time.advance(24 * 60 * 60 * 1000L);
        var day2 = missions.checkin(playerId);
        assertEquals(2, day2.streak());
        assertEquals(200, day2.rewardVang());

        time.advance(2 * 24 * 60 * 60 * 1000L);
        assertEquals(1, missions.checkin(playerId).streak());
    }
}
