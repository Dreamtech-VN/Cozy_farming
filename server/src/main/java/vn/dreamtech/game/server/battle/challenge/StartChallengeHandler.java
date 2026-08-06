package vn.dreamtech.game.server.battle.challenge;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.battle.BattleException;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/battle/challenge/start {userId, type} ("DAILY"/"WEEKLY") — 429 nếu còn trong thời gian chờ kể từ lần thắng gần nhất. */
public final class StartChallengeHandler implements HttpHandler {
    private final BattleService battleService;

    public StartChallengeHandler(BattleService battleService) {
        this.battleService = battleService;
    }

    record Req(int userId, String type) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        ChallengeType type;
        try {
            type = ChallengeType.valueOf(req.type() == null ? "" : req.type().toUpperCase());
        } catch (IllegalArgumentException e) {
            JsonHttp.writeError(exchange, 400, "Loại thử thách không hợp lệ (DAILY/WEEKLY)");
            return;
        }
        try {
            JsonHttp.write(exchange, 201, battleService.startChallenge(req.userId(), type));
        } catch (BattleException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
