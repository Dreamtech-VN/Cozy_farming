package vn.dreamtech.game.server.pvp;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/pvp/match/report {userId, matchId, battleId} — nộp điểm sau khi trận cá nhân kết thúc (hết lượt hoặc hết máu). */
public final class ReportScoreHandler implements HttpHandler {
    private final PvpService pvpService;

    public ReportScoreHandler(PvpService pvpService) {
        this.pvpService = pvpService;
    }

    record Req(int userId, String matchId, String battleId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            JsonHttp.write(exchange, 200, pvpService.reportScore(req.userId(), req.matchId(), req.battleId()));
        } catch (PvpException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
