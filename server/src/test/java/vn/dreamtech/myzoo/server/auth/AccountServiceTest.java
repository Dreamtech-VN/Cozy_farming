package vn.dreamtech.myzoo.server.auth;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;

import static org.junit.jupiter.api.Assertions.*;

class AccountServiceTest {
    EconomyService economy;
    PlayerService players;
    AccountService accounts;

    @BeforeEach
    void setUp() {
        var db = TestSupport.newDb();
        var time = new TestSupport.FakeTime();
        economy = new EconomyService(db, time);
        players = new PlayerService(db, economy, time);
        accounts = new AccountService(db, players, time);
    }

    @Test
    void registerThenLoginWorks() {
        var registered = accounts.register("nongdan1", "matkhau123", null);
        assertTrue(registered.needsCharacter());
        assertNotNull(registered.sessionToken());
        assertEquals(registered.playerId(), players.authenticate(registered.sessionToken()));

        var loggedIn = accounts.login("nongdan1", "matkhau123");
        assertEquals(registered.playerId(), loggedIn.playerId());
        assertNotEquals(registered.sessionToken(), loggedIn.sessionToken());
    }

    @Test
    void loginRejectsWrongCredentials() {
        accounts.register("nongdan1", "matkhau123", null);
        assertEquals(401, assertThrows(ApiException.class, () -> accounts.login("nongdan1", "sai")).status());
        assertEquals(401, assertThrows(ApiException.class, () -> accounts.login("khongco", "matkhau123")).status());
    }

    @Test
    void registerKeepsGuestProgress() {
        var guest = players.guestLogin(null);
        economy.spend(guest.playerId(), EconomyService.VANG, 400, "TEST", "t", "1");
        players.createCharacter(guest.playerId(), "NongDanA", "farmer_1");

        var registered = accounts.register("nongdan1", "matkhau123", guest.guestToken());
        assertEquals(guest.playerId(), registered.playerId());
        assertFalse(registered.needsCharacter());
        assertEquals("NongDanA", registered.name());
        assertEquals(600, economy.balances(guest.playerId()).get(EconomyService.VANG));
        assertTrue(players.profile(guest.playerId()).hasAccount());

        assertEquals(409, assertThrows(ApiException.class,
                () -> accounts.register("nongdan2", "matkhau123", guest.guestToken())).status());
    }

    @Test
    void duplicateUsernameRejected() {
        accounts.register("nongdan1", "matkhau123", null);
        assertEquals(409, assertThrows(ApiException.class,
                () -> accounts.register("NongDan1", "matkhau456", null)).status());
    }

    @Test
    void usernameAndPasswordValidated() {
        assertEquals(400, assertThrows(ApiException.class, () -> accounts.register("ab", "matkhau123", null)).status());
        assertEquals(400, assertThrows(ApiException.class, () -> accounts.register("có dấu", "matkhau123", null)).status());
        assertEquals(400, assertThrows(ApiException.class, () -> accounts.register("nongdan1", "123", null)).status());
    }

    @Test
    void changePasswordRequiresOldPassword() {
        var registered = accounts.register("nongdan1", "matkhau123", null);
        assertEquals(401, assertThrows(ApiException.class,
                () -> accounts.changePassword(registered.playerId(), "sai", "matkhaumoi")).status());
        accounts.changePassword(registered.playerId(), "matkhau123", "matkhaumoi");
        assertEquals(401, assertThrows(ApiException.class, () -> accounts.login("nongdan1", "matkhau123")).status());
        assertNotNull(accounts.login("nongdan1", "matkhaumoi").sessionToken());
    }

    @Test
    void logoutInvalidatesSessionButKeepsGuestToken() {
        var guest = players.guestLogin(null);
        players.logout(guest.sessionToken());
        assertEquals(401, assertThrows(ApiException.class,
                () -> players.authenticate(guest.sessionToken())).status());
        assertEquals(guest.playerId(), players.authenticate(guest.guestToken()));
    }
}
