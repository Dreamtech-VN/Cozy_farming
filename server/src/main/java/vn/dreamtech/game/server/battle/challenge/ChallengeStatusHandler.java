package vn.dreamtech.game.server.battle.challenge;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.battle.BattleException;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;

/** GET /api/battle/challenge/status?userId=&type=DAILY|WEEKLY — còn làm được không, còn bao lâu nếu chưa. */
public final class ChallengeStatusHandler implements HttpHandler {
    private final BattleService battleService;

    public ChallengeStatusHandler(BattleService battleService) {
        this.battleService = battleService;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        String query = exchange.getRequestURI().getQuery();
        Integer userId = QueryParam.intParam(query, "userId");
        String typeParam = QueryParam.stringParam(query, "type");
        if (userId == null || typeParam == null) {
            JsonHttp.writeError(exchange, 400, "Thiếu tham số userId/type");
            return;
        }
        ChallengeType type;
        try {
            type = ChallengeType.valueOf(typeParam.toUpperCase());
        } catch (IllegalArgumentException e) {
            JsonHttp.writeError(exchange, 400, "Loại thử thách không hợp lệ (DAILY/WEEKLY)");
            return;
        }
        try {
            JsonHttp.write(exchange, 200, battleService.challengeStatus(userId, type));
        } catch (BattleException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
