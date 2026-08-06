package vn.dreamtech.game.server.pvp;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/pvp/match/start {userId, matchId} — bắt đầu trận cá nhân sau khi ghép cặp. */
public final class StartMatchHandler implements HttpHandler {
    private final PvpService pvpService;

    public StartMatchHandler(PvpService pvpService) {
        this.pvpService = pvpService;
    }

    record Req(int userId, String matchId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            JsonHttp.write(exchange, 201, pvpService.startMatch(req.userId(), req.matchId()));
        } catch (PvpException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
