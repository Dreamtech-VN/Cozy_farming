package vn.dreamtech.game.server.battle.adventure;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.battle.BattleException;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/battle/adventure/start {userId, levelId} — bắt đầu 1 màn Adventure. */
public final class StartAdventureHandler implements HttpHandler {
    private final BattleService battleService;

    public StartAdventureHandler(BattleService battleService) {
        this.battleService = battleService;
    }

    record Req(int userId, int levelId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            JsonHttp.write(exchange, 201, battleService.startAdventure(req.userId(), req.levelId()));
        } catch (BattleException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
