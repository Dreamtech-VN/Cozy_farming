package vn.dreamtech.myzoo.server.player;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.http.ApiException;

import static org.junit.jupiter.api.Assertions.*;

class CharacterCreateTest {
    PlayerService players;
    int playerId;

    @BeforeEach
    void setUp() {
        var db = TestSupport.newDb();
        var time = new TestSupport.FakeTime();
        players = new PlayerService(db, new EconomyService(db, time), time);
        playerId = players.guestLogin(null).playerId();
    }

    @Test
    void createCharacterStoresNameAndAvatar() {
        var profile = players.createCharacter(playerId, "  NongDanA  ", "farmer_2");
        assertEquals("NongDanA", profile.name());
        assertEquals("farmer_2", profile.avatar());
        assertFalse(profile.hasAccount());
    }

    @Test
    void avatarDefaultsWhenMissing() {
        assertEquals("farmer_1", players.createCharacter(playerId, "NongDanA", null).avatar());
    }

    @Test
    void nameRulesEnforced() {
        assertEquals(400, assertThrows(ApiException.class, () -> players.createCharacter(playerId, "A", null)).status());
        assertEquals(400, assertThrows(ApiException.class,
                () -> players.createCharacter(playerId, "ten@#$%", null)).status());
        assertEquals(400, assertThrows(ApiException.class,
                () -> players.createCharacter(playerId, "adminshop", null)).status());
        players.createCharacter(playerId, "Nông Dân 1", null);
    }

    @Test
    void duplicateNameRejected() {
        players.createCharacter(playerId, "NongDanA", null);
        int other = players.guestLogin(null).playerId();
        assertEquals(409, assertThrows(ApiException.class,
                () -> players.createCharacter(other, "NongDanA", null)).status());
    }

    @Test
    void selectServerValidatesId() {
        assertEquals(404, assertThrows(ApiException.class, () -> players.selectServer(playerId, "s99")).status());
        players.selectServer(playerId, "s1");
        assertEquals("s1", players.profile(playerId).serverId());
    }
}
