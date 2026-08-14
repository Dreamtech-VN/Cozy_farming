package vn.dreamtech.myzoo.server.player;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.http.ApiException;

import static org.junit.jupiter.api.Assertions.*;

class PlayerServiceTest {
    PlayerService players;

    @BeforeEach
    void setUp() {
        var db = TestSupport.newDb();
        var time = new TestSupport.FakeTime();
        players = new PlayerService(db, new EconomyService(db, time), time);
    }

    @Test
    void newGuestGetsStarterVang() {
        var login = players.guestLogin(null);
        assertTrue(login.isNew());
        assertEquals(PlayerService.STARTER_VANG,
                players.profile(login.playerId()).wallets().get(EconomyService.VANG));
    }

    @Test
    void existingTokenReusesPlayer() {
        var first = players.guestLogin(null);
        var second = players.guestLogin(first.guestToken());
        assertFalse(second.isNew());
        assertEquals(first.playerId(), second.playerId());
    }

    @Test
    void authenticateResolvesTokenAndRejectsUnknown() {
        var login = players.guestLogin(null);
        assertEquals(login.playerId(), players.authenticate(login.guestToken()));
        assertEquals(401, assertThrows(ApiException.class, () -> players.authenticate("khong-ton-tai")).status());
        assertEquals(401, assertThrows(ApiException.class, () -> players.authenticate(null)).status());
    }

    @Test
    void setNameValidatesLengthAndUniqueness() {
        var a = players.guestLogin(null);
        var b = players.guestLogin(null);
        assertEquals(400, assertThrows(ApiException.class, () -> players.setName(a.playerId(), "x")).status());
        players.setName(a.playerId(), "NongDanA");
        assertEquals(409, assertThrows(ApiException.class, () -> players.setName(b.playerId(), "NongDanA")).status());
    }

    @Test
    void levelCurve() {
        assertEquals(1, PlayerService.levelFor(0));
        assertEquals(2, PlayerService.levelFor(50));
        assertEquals(3, PlayerService.levelFor(200));
    }
}
