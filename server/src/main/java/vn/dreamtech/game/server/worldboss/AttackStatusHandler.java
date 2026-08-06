package vn.dreamtech.game.server.worldboss;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;

/** GET /api/world-boss/attack-status?userId= — còn lượt đánh trùm thế giới trong chu kỳ này không. */
public final class AttackStatusHandler implements HttpHandler {
    private final WorldBossService worldBossService;

    public AttackStatusHandler(WorldBossService worldBossService) {
        this.worldBossService = worldBossService;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        Integer userId = QueryParam.intParam(exchange.getRequestURI().getQuery(), "userId");
        if (userId == null) {
            JsonHttp.writeError(exchange, 400, "Thiếu tham số userId");
            return;
        }
        try {
            JsonHttp.write(exchange, 200, worldBossService.attackStatus(userId));
        } catch (WorldBossException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
