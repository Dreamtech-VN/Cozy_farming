package vn.dreamtech.game.server.pvp;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;

/** GET /api/pvp/match/status?matchId= — trạng thái/điểm số của 1 trận PvP. */
public final class MatchStatusHandler implements HttpHandler {
    private final PvpService pvpService;

    public MatchStatusHandler(PvpService pvpService) {
        this.pvpService = pvpService;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        String matchId = QueryParam.stringParam(exchange.getRequestURI().getQuery(), "matchId");
        if (matchId == null) {
            JsonHttp.writeError(exchange, 400, "Thiếu tham số matchId");
            return;
        }
        try {
            JsonHttp.write(exchange, 200, pvpService.matchStatus(matchId));
        } catch (PvpException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
