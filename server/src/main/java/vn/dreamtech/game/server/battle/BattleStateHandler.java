package vn.dreamtech.game.server.battle;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;

/** GET /api/battle/state?battleId= — trạng thái hiện tại của trận đấu. */
public final class BattleStateHandler implements HttpHandler {
    private final BattleService battleService;

    public BattleStateHandler(BattleService battleService) {
        this.battleService = battleService;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        String battleId = QueryParam.stringParam(exchange.getRequestURI().getQuery(), "battleId");
        if (battleId == null) {
            JsonHttp.writeError(exchange, 400, "Thiếu tham số battleId");
            return;
        }
        try {
            JsonHttp.write(exchange, 200, battleService.getState(battleId));
        } catch (BattleException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
