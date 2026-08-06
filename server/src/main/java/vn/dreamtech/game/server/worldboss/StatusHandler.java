package vn.dreamtech.game.server.worldboss;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** GET /api/world-boss/status — HP còn lại của trùm thế giới trong chu kỳ hiện tại. */
public final class StatusHandler implements HttpHandler {
    private final WorldBossService worldBossService;

    public StatusHandler(WorldBossService worldBossService) {
        this.worldBossService = worldBossService;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        try {
            JsonHttp.write(exchange, 200, worldBossService.status());
        } catch (WorldBossException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
