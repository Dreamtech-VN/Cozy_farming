package vn.dreamtech.game.server.pvp;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/pvp/queue/join {userId} — vào hàng chờ ghép cặp; ghép được ngay thì trả về matchId luôn. */
public final class JoinQueueHandler implements HttpHandler {
    private final PvpService pvpService;

    public JoinQueueHandler(PvpService pvpService) {
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
            JsonHttp.write(exchange, 200, pvpService.joinQueue(req.userId()));
        } catch (PvpException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
