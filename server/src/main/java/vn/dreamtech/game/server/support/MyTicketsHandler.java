package vn.dreamtech.game.server.support;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.SupportTicketDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;
import java.sql.SQLException;

/** GET /api/support/tickets?userId= — người chơi xem lại các báo cáo mình đã gửi (mới nhất trước). */
public final class MyTicketsHandler implements HttpHandler {
    private final SupportTicketDao supportTicketDao;

    public MyTicketsHandler(SupportTicketDao supportTicketDao) {
        this.supportTicketDao = supportTicketDao;
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
            JsonHttp.write(exchange, 200, supportTicketDao.findByUser(userId));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy danh sách báo cáo: " + e.getMessage());
        }
    }
}
