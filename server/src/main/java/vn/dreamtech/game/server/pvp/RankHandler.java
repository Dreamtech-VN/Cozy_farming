package vn.dreamtech.game.server.pvp;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;

/** GET /api/pvp/rank?userId= — điểm rating/thắng/thua/hoà của user (mặc định 1000/0/0/0 nếu chưa đấu trận nào). */
public final class RankHandler implements HttpHandler {
    private final PvpService pvpService;

    public RankHandler(PvpService pvpService) {
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
            JsonHttp.write(exchange, 200, pvpService.rank(userId));
        } catch (PvpException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
