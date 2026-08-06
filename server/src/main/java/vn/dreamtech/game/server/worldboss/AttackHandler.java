package vn.dreamtech.game.server.worldboss;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/world-boss/attack {userId} — bắt đầu 1 lượt đánh trùm thế giới (1 lần/chu kỳ, không cần vào guild). */
public final class AttackHandler implements HttpHandler {
    private final WorldBossService worldBossService;

    public AttackHandler(WorldBossService worldBossService) {
        this.worldBossService = worldBossService;
    }

    record Req(int userId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            JsonHttp.write(exchange, 201, worldBossService.attack(req.userId()));
        } catch (WorldBossException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
