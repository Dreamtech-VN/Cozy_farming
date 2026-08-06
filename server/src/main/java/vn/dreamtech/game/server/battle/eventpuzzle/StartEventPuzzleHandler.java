package vn.dreamtech.game.server.battle.eventpuzzle;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.battle.BattleException;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/battle/event-puzzle/start {userId, eventId} — 404 nếu không tồn tại, 409 nếu chưa/đã hết hạn. */
public final class StartEventPuzzleHandler implements HttpHandler {
    private final BattleService battleService;

    public StartEventPuzzleHandler(BattleService battleService) {
        this.battleService = battleService;
    }

    record Req(int userId, int eventId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            JsonHttp.write(exchange, 201, battleService.startEventPuzzle(req.userId(), req.eventId()));
        } catch (BattleException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
