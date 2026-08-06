package vn.dreamtech.game.server.pvp;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;

/** GET /api/pvp/match/my?userId= — trận PvP gần nhất của user (kể cả đã kết thúc), 404 nếu chưa từng ghép cặp. */
public final class MyMatchHandler implements HttpHandler {
    private final PvpService pvpService;

    public MyMatchHandler(PvpService pvpService) {
        this.pvpService = pvpService;
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
            var found = pvpService.myMatch(userId);
            if (found.isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Chưa từng ghép cặp PvP");
                return;
            }
            JsonHttp.write(exchange, 200, found.get());
        } catch (PvpException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
