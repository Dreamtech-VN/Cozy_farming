package vn.dreamtech.game.server.battle.dungeon;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.battle.BattleException;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/battle/dungeon/start {userId, dungeonId} — bắt đầu dungeon từ tầng 1. */
public final class StartDungeonHandler implements HttpHandler {
    private final BattleService battleService;

    public StartDungeonHandler(BattleService battleService) {
        this.battleService = battleService;
    }

    record Req(int userId, int dungeonId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            JsonHttp.write(exchange, 201, battleService.startDungeon(req.userId(), req.dungeonId()));
        } catch (BattleException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
