package vn.dreamtech.game.server.support;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.dao.SupportTicketDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;
import java.sql.SQLException;

/** POST /api/admin/support/resolve {ticketId} — đánh dấu ticket đã xử lý. Cần header X-Admin-Token. */
public final class AdminResolveTicketHandler implements HttpHandler {
    private final SupportTicketDao supportTicketDao;

    public AdminResolveTicketHandler(SupportTicketDao supportTicketDao) {
        this.supportTicketDao = supportTicketDao;
    }

    record Req(long ticketId) {
    }

    record Res(boolean resolved) {
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
            boolean found = supportTicketDao.resolve(req.ticketId());
            if (!found) {
                throw new ItemException(404, "Không tìm thấy ticket");
            }
            JsonHttp.write(exchange, 200, new Res(true));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi xử lý ticket: " + e.getMessage());
        }
    }
}
