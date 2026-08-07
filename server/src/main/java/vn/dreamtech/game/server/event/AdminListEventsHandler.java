package vn.dreamtech.game.server.event;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;

/** GET /api/admin/events/list — toàn bộ sự kiện kể cả đã tắt/đã qua (cần header X-Admin-Token, để admin sửa lại được). */
public final class AdminListEventsHandler implements HttpHandler {
    private final EventBoardService eventBoardService;

    public AdminListEventsHandler(EventBoardService eventBoardService) {
        this.eventBoardService = eventBoardService;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        try {
            AdminAuth.requireAdmin(exchange);
            JsonHttp.write(exchange, 200, eventBoardService.listAll());
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
