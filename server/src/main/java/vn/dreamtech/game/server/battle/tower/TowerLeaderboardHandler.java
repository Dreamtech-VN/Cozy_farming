package vn.dreamtech.game.server.battle.tower;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.battle.BattleException;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;

/** GET /api/battle/tower/leaderboard?towerId= — tầng cao nhất từng đạt của mỗi người chơi trong 1 tháp, xếp giảm dần. */
public final class TowerLeaderboardHandler implements HttpHandler {
    private final BattleService battleService;

    public TowerLeaderboardHandler(BattleService battleService) {
        this.battleService = battleService;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        Integer towerId = QueryParam.intParam(exchange.getRequestURI().getQuery(), "towerId");
        if (towerId == null) {
            JsonHttp.writeError(exchange, 400, "Thiếu tham số towerId");
            return;
        }
        try {
            JsonHttp.write(exchange, 200, battleService.towerLeaderboard(towerId));
        } catch (BattleException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
