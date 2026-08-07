package vn.dreamtech.game.server.event;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;

/** GET /api/events/board — bảng sự kiện đang diễn ra/sắp diễn ra (public). */
public final class EventBoardHandler implements HttpHandler {
    private final EventBoardService eventBoardService;

    public EventBoardHandler(EventBoardService eventBoardService) {
        this.eventBoardService = eventBoardService;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        try {
            JsonHttp.write(exchange, 200, eventBoardService.board());
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
