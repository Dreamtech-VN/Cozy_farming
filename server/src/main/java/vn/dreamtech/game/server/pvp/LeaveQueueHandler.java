package vn.dreamtech.game.server.pvp;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/pvp/queue/leave {userId} — rời hàng chờ trước khi ghép được cặp. */
public final class LeaveQueueHandler implements HttpHandler {
    private final PvpService pvpService;

    public LeaveQueueHandler(PvpService pvpService) {
        this.pvpService = pvpService;
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
            pvpService.leaveQueue(req.userId());
            JsonHttp.write(exchange, 200, new Object());
        } catch (PvpException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
