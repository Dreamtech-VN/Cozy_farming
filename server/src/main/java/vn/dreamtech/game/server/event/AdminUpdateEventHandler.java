package vn.dreamtech.game.server.event;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;

/** POST /api/admin/events/update {id, title, description, startAt, endAt, active} — cần header X-Admin-Token. */
public final class AdminUpdateEventHandler implements HttpHandler {
    private final EventBoardService eventBoardService;

    public AdminUpdateEventHandler(EventBoardService eventBoardService) {
        this.eventBoardService = eventBoardService;
    }

    record Req(int id, String title, String description, long startAt, long endAt, boolean active) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        try {
            AdminAuth.requireAdmin(exchange);
            Req req = JsonHttp.readBody(exchange, Req.class);
            JsonHttp.write(exchange, 200, eventBoardService.update(req.id(), req.title(), req.description(),
                    req.startAt(), req.endAt(), req.active()));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
