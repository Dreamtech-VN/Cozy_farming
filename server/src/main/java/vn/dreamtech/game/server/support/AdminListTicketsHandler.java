package vn.dreamtech.game.server.support;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.dao.SupportTicketDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;
import java.sql.SQLException;

/** GET /api/admin/support/tickets?unresolvedOnly=true — toàn bộ ticket báo lỗi/liên hệ (trước đây phải xem trực tiếp DB). Cần header X-Admin-Token. */
public final class AdminListTicketsHandler implements HttpHandler {
    private final SupportTicketDao supportTicketDao;

    public AdminListTicketsHandler(SupportTicketDao supportTicketDao) {
        this.supportTicketDao = supportTicketDao;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        try {
            AdminAuth.requireAdmin(exchange);
            boolean unresolvedOnly = "true".equalsIgnoreCase(
                    QueryParam.stringParam(exchange.getRequestURI().getQuery(), "unresolvedOnly"));
            JsonHttp.write(exchange, 200, supportTicketDao.findAll(unresolvedOnly));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy danh sách ticket: " + e.getMessage());
        }
    }
}
