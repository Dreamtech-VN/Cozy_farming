package vn.dreamtech.game.server.event;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;

/** POST /api/admin/events/delete {id} — cần header X-Admin-Token. */
public final class AdminDeleteEventHandler implements HttpHandler {
    private final EventBoardService eventBoardService;

    public AdminDeleteEventHandler(EventBoardService eventBoardService) {
        this.eventBoardService = eventBoardService;
    }

    record Req(int id) {
    }

    record Res(boolean deleted) {
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
            eventBoardService.delete(req.id());
            JsonHttp.write(exchange, 200, new Res(true));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
