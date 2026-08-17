package vn.dreamtech.myzoo.server.mission;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;

import static org.junit.jupiter.api.Assertions.*;

class WeeklyMissionTest {
    static final long DAY = 24L * 60 * 60 * 1000;

    DataSource db;
    TestSupport.FakeTime time;
    EconomyService economy;
    PlayerService players;
    MissionService missions;
    int an;

    @BeforeEach
    void setUp() {
        db = TestSupport.newDb();
        time = new TestSupport.FakeTime();
        economy = new EconomyService(db, time);
        players = new PlayerService(db, economy, time);
        missions = new MissionService(db, economy, players, time);
        an = players.guestLogin(null).playerId();
        players.createCharacter(an, "An", "farmer_1");
    }

    MissionService.MissionView find(String id) {
        return missions.view(an).stream().filter(m -> m.id().equals(id)).findFirst()
                .orElseThrow(() -> new AssertionError("không thấy nhiệm vụ " + id));
    }

    // ---------- Dữ liệu hoá ----------
    @Test
    void definitionsComeFromDatabaseAndKeepBothScopes() {
        var defs = missions.activeDefs();
        assertTrue(defs.stream().anyMatch(d -> d.scope().equals(MissionService.DAILY)));
        assertTrue(defs.stream().anyMatch(d -> d.scope().equals(MissionService.WEEKLY)));
        assertTrue(defs.size() >= 10);

        // Dựng lại service không được nhân đôi bộ nhiệm vụ.
        int before = defs.size();
        new MissionService(db, economy, players, time);
        assertEquals(before, missions.activeDefs().size());
    }

    @Test
    void dailyResetsEachDayButWeeklyKeepsCounting() {
        missions.record(an, "HARVEST", 5);
        assertEquals(5, find("harvest_8").progress());
        assertEquals(5, find("w_harvest_50").progress());

        time.advance(DAY);
        assertEquals(0, find("harvest_8").progress(), "nhiệm vụ ngày sang ngày mới là về 0");
        assertEquals(5, find("w_harvest_50").progress(), "nhiệm vụ tuần vẫn giữ tiến độ");
    }

    @Test
    void weeklyResetsAfterTheWeekRollsOver() {
        missions.record(an, "HARVEST", 20);
        assertEquals(20, find("w_harvest_50").progress());
        String weekBefore = missions.week();

        time.advance(7 * DAY);
        assertNotEquals(weekBefore, missions.week(), "qua 7 ngày phải sang tuần mới");
        assertEquals(0, find("w_harvest_50").progress());
    }

    @Test
    void weekKeyIsStableWithinTheSameWeek() {
        String first = missions.week();
        time.advance(DAY);
        assertEquals(first.length(), missions.week().length());
        assertTrue(missions.week().contains("-W"));
    }

    // ---------- Nhận thưởng ----------
    @Test
    void weeklyClaimPaysBothCurrenciesWhenConfigured() {
        missions.record(an, "FRIEND_HELP", 10);
        var result = missions.claim(an, "w_help_10");
        assertEquals(400, result.rewardVang());
        assertEquals(25, result.rewardKc(), "nhiệm vụ tuần này là nguồn Kim Cương miễn phí");
        assertEquals(25, economy.balances(an).get(EconomyService.KIM_CUONG));
        assertEquals(409, assertThrows(ApiException.class, () -> missions.claim(an, "w_help_10")).status());
    }

    @Test
    void claimBeforeFinishingRejected() {
        missions.record(an, "HARVEST", 3);
        assertEquals(409, assertThrows(ApiException.class, () -> missions.claim(an, "w_harvest_50")).status());
        assertEquals(404, assertThrows(ApiException.class, () -> missions.claim(an, "khong-co")).status());
    }

    @Test
    void claimedWeeklyBecomesAvailableAgainNextWeek() {
        missions.record(an, "FRIEND_HELP", 10);
        missions.claim(an, "w_help_10");
        assertTrue(find("w_help_10").claimed());

        time.advance(7 * DAY);
        assertFalse(find("w_help_10").claimed(), "tuần mới thì nhận lại được");
        assertEquals(0, find("w_help_10").progress());
    }

    // ---------- Sự kiện bật/tắt không cần build lại ----------
    @Test
    void eventMissionOnlyVisibleWhileWindowIsOpen() {
        insertEvent("ev_tet", "Gói bánh chưng", "PROCESS", 5, time.now() + DAY, time.now() + 3 * DAY);
        assertTrue(missions.view(an).stream().noneMatch(m -> m.id().equals("ev_tet")), "chưa tới ngày thì chưa hiện");

        time.advance(2 * DAY);
        var mission = find("ev_tet");
        assertEquals(MissionService.EVENT, mission.scope());
        assertNotNull(mission.endsAt(), "nhiệm vụ sự kiện phải cho biết khi nào kết thúc");

        time.advance(2 * DAY);
        assertTrue(missions.view(an).stream().noneMatch(m -> m.id().equals("ev_tet")), "hết hạn thì biến mất");
    }

    @Test
    void eventProgressIsNotResetByDayOrWeek() {
        insertEvent("ev_long", "Sự kiện dài", "HARVEST", 100, time.now() - DAY, time.now() + 30 * DAY);
        missions.record(an, "HARVEST", 10);
        assertEquals(10, find("ev_long").progress());

        time.advance(10 * DAY);
        assertEquals(10, find("ev_long").progress(), "tiến độ sự kiện tính theo cả đợt, không reset");
    }

    @Test
    void turningAnEventOffNeedsNoClientUpdate() {
        insertEvent("ev_off", "Sự kiện tắt được", "HARVEST", 5, null, null);
        assertTrue(missions.view(an).stream().anyMatch(m -> m.id().equals("ev_off")));

        // Đóng sự kiện bằng cách sửa mốc thời gian trong DB — không đụng tới code hay client.
        try (Connection c = db.getConnection(); var ps = c.prepareStatement(
                "UPDATE mission_defs SET active_to = ? WHERE id = ?")) {
            ps.setTimestamp(1, new Timestamp(time.now() - 1000));
            ps.setString(2, "ev_off");
            ps.executeUpdate();
        } catch (SQLException e) {
            fail("không sửa được mốc thời gian: " + e.getMessage());
        }
        assertTrue(missions.view(an).stream().noneMatch(m -> m.id().equals("ev_off")));
    }

    void insertEvent(String id, String name, String type, int target, Long from, Long to) {
        try (Connection c = db.getConnection(); var ps = c.prepareStatement(
                "INSERT INTO mission_defs (id, name, type, target, reward_vang, reward_kc, scope, event_id, "
                        + "active_from, active_to, sort_order) VALUES (?, ?, ?, ?, 500, 0, 'EVENT', ?, ?, ?, 90)")) {
            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, type);
            ps.setInt(4, target);
            ps.setString(5, id);
            ps.setTimestamp(6, from == null ? null : new Timestamp(from));
            ps.setTimestamp(7, to == null ? null : new Timestamp(to));
            ps.executeUpdate();
        } catch (SQLException e) {
            fail("không tạo được nhiệm vụ sự kiện: " + e.getMessage());
        }
    }
}
