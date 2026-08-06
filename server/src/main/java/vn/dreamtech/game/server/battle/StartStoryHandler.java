package vn.dreamtech.game.server.battle;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/battle/story/start {userId, levelId} — bắt đầu 1 trận Story mới, trả về bàn cờ + trạng thái ban đầu. */
public final class StartStoryHandler implements HttpHandler {
    private final BattleService battleService;

    public StartStoryHandler(BattleService battleService) {
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
            JsonHttp.write(exchange, 201, battleService.startStory(req.userId(), req.levelId()));
        } catch (BattleException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
