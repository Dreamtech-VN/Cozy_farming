package vn.dreamtech.game.server.battle.tower;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.battle.BattleException;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/battle/tower/start {userId, towerId} — bắt đầu leo tháp từ tầng 1. */
public final class StartTowerHandler implements HttpHandler {
    private final BattleService battleService;

    public StartTowerHandler(BattleService battleService) {
        this.battleService = battleService;
    }

    record Req(int userId, int towerId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            JsonHttp.write(exchange, 201, battleService.startTower(req.userId(), req.towerId()));
        } catch (BattleException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
