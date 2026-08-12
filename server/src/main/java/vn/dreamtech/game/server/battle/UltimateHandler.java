package vn.dreamtech.game.server.battle;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/battle/ultimate {battleId} — dùng chiêu cuối khi mana đầy, tốn toàn bộ mana. */
public final class UltimateHandler implements HttpHandler {
    private final BattleService battleService;

    public UltimateHandler(BattleService battleService) {
        this.battleService = battleService;
    }

    record Req(int userId, String battleId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            JsonHttp.write(exchange, 200, battleService.useUltimate(req.userId(), req.battleId()));
        } catch (BattleException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
