package vn.dreamtech.game.server.support;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.SupportTicketDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Set;

/** POST /api/support/report {userId, category, message} — category "bug" (báo lỗi) hoặc "contact" (liên hệ). */
public final class ReportHandler implements HttpHandler {
    private static final Set<String> VALID_CATEGORIES = Set.of("bug", "contact");
    private static final int MAX_LENGTH = 1000;

    private final SupportTicketDao supportTicketDao;

    public ReportHandler(SupportTicketDao supportTicketDao) {
        this.supportTicketDao = supportTicketDao;
    }

    record Req(int userId, String category, String message) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        String message = req.message() == null ? "" : req.message().strip();
        if (req.category() == null || !VALID_CATEGORIES.contains(req.category())) {
            JsonHttp.writeError(exchange, 400, "category không hợp lệ (chỉ nhận bug/contact)");
            return;
        }
        if (message.isEmpty() || message.length() > MAX_LENGTH) {
            JsonHttp.writeError(exchange, 400, "Nội dung không hợp lệ (tối đa " + MAX_LENGTH + " ký tự)");
            return;
        }
        try {
            var ticket = supportTicketDao.create(req.userId(), req.category(), message, System.currentTimeMillis());
            JsonHttp.write(exchange, 201, ticket);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi gửi báo cáo: " + e.getMessage());
        }
    }
}
