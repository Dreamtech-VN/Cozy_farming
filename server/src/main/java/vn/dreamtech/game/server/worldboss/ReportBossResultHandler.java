package vn.dreamtech.game.server.worldboss;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/world-boss/report {userId, battleId} — sau khi trận (WON/LOST) kết thúc, đồng bộ sát thương vào HP chung toàn server + phát thưởng. */
public final class ReportBossResultHandler implements HttpHandler {
    private final WorldBossService worldBossService;

    public ReportBossResultHandler(WorldBossService worldBossService) {
        this.worldBossService = worldBossService;
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
            JsonHttp.write(exchange, 200, worldBossService.report(req.userId(), req.battleId()));
        } catch (WorldBossException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
