package vn.dreamtech.myzoo.server.minigame;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;

import static org.junit.jupiter.api.Assertions.*;

class MinigameServiceTest {
    EconomyService economy;
    PlayerService players;
    MinigameService minigames;
    int playerId;

    @BeforeEach
    void setUp() {
        var db = TestSupport.newDb();
        var time = new TestSupport.FakeTime();
        economy = new EconomyService(db, time);
        players = new PlayerService(db, economy, time);
        minigames = new MinigameService(db, economy, players, time);
        playerId = players.guestLogin(null).playerId();
    }

    @Test
    void finishPaysPerLine() {
        var session = minigames.create(playerId);
        var result = minigames.finish(playerId, session.sessionId(), 4);
        assertEquals(4, result.linesCounted());
        assertEquals(4 * MinigameService.VANG_PER_LINE, result.vangReward());
        assertEquals(1000 + result.vangReward(), result.vangBalance());
    }

    @Test
    void rewardCappedAtMaxLines() {
        var session = minigames.create(playerId);
        var result = minigames.finish(playerId, session.sessionId(), 999);
        assertEquals(MinigameService.MAX_LINES, result.linesCounted());
        assertEquals(MinigameService.MAX_LINES * MinigameService.VANG_PER_LINE, result.vangReward());
    }

    @Test
    void doubleFinishDoesNotPayTwice() {
        var session = minigames.create(playerId);
        minigames.finish(playerId, session.sessionId(), 5);
        var again = minigames.finish(playerId, session.sessionId(), 15);
        assertEquals(5, again.linesCounted());
        assertEquals(1000 + 5 * MinigameService.VANG_PER_LINE,
                economy.balances(playerId).get(EconomyService.VANG));
    }

    @Test
    void foreignOrUnknownSessionRejected() {
        var session = minigames.create(playerId);
        int other = players.guestLogin(null).playerId();
        assertEquals(404, assertThrows(ApiException.class,
                () -> minigames.finish(other, session.sessionId(), 3)).status());
        assertEquals(404, assertThrows(ApiException.class,
                () -> minigames.finish(playerId, "khong-co", 3)).status());
        assertEquals(400, assertThrows(ApiException.class,
                () -> minigames.finish(playerId, session.sessionId(), -1)).status());
    }
}
