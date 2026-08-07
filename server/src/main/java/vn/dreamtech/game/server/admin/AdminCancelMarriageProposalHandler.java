package vn.dreamtech.game.server.admin;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.MarriageProposalDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/admin/marriage/proposal/cancel {proposalId} — GM huỷ 1 lời
 * cầu hôn đang chờ (VD: bị report spam/quấy rối), không cần người nhận
 * phải tự từ chối. Cần header X-Admin-Token.
 */
public final class AdminCancelMarriageProposalHandler implements HttpHandler {
    private final MarriageProposalDao proposalDao;

    public AdminCancelMarriageProposalHandler(MarriageProposalDao proposalDao) {
        this.proposalDao = proposalDao;
    }

    public record Req(long proposalId) {
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
            proposalDao.find(req.proposalId()).orElseThrow(() -> new ItemException(404, "Không tìm thấy lời cầu hôn"));
            proposalDao.delete(req.proposalId());
            JsonHttp.write(exchange, 200, new Object());
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi huỷ lời cầu hôn: " + e.getMessage());
        }
    }
}
