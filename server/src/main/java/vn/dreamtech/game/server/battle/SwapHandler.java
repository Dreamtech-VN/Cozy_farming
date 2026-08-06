package vn.dreamtech.game.server.battle;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/battle/swap {battleId, r1, c1, r2, c2} — đổi 2 ô liền kề, xử lý khớp/dây chuyền/sát thương/mana/phản đòn. */
public final class SwapHandler implements HttpHandler {
    private final BattleService battleService;

    public SwapHandler(BattleService battleService) {
        this.battleService = battleService;
    }

    record Req(String battleId, int r1, int c1, int r2, int c2) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            JsonHttp.write(exchange, 200, battleService.swap(req.battleId(), req.r1(), req.c1(), req.r2(), req.c2()));
        } catch (BattleException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
