package vn.dreamtech.game.server.battle.eventpuzzle;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** GET /api/battle/event-puzzle/list — TOÀN BỘ sự kiện (kể cả chưa/đã diễn ra) — client tự so `startAt`/`endAt` để hiện "sắp diễn ra"/"đã kết thúc". */
public final class EventPuzzleListHandler implements HttpHandler {
    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        JsonHttp.write(exchange, 200, EventPuzzleCatalog.all());
    }
}
