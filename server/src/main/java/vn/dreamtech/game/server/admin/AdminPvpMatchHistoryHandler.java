package vn.dreamtech.game.server.admin;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.PvpMatchHistoryDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;
import java.sql.SQLException;

/**
 * GET /api/admin/pvp/match/history?userId=&limit= — GM tra cứu lịch sử
 * đấu PvP của 1 user để xử lý report tố cáo gian lận/dispute kết quả.
 * {@code limit} mặc định 20, tối đa 100. Cần header X-Admin-Token.
 */
public final class AdminPvpMatchHistoryHandler implements HttpHandler {
    private static final int DEFAULT_LIMIT = 20;
    private static final int MAX_LIMIT = 100;

    private final PvpMatchHistoryDao matchHistoryDao;

    public AdminPvpMatchHistoryHandler(PvpMatchHistoryDao matchHistoryDao) {
        this.matchHistoryDao = matchHistoryDao;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        try {
            AdminAuth.requireAdmin(exchange);
            Integer userId = QueryParam.intParam(exchange.getRequestURI().getQuery(), "userId");
            if (userId == null) {
                JsonHttp.writeError(exchange, 400, "Thiếu tham số userId");
                return;
            }
            Integer limit = QueryParam.intParam(exchange.getRequestURI().getQuery(), "limit");
            int effectiveLimit = limit == null ? DEFAULT_LIMIT : Math.min(Math.max(limit, 1), MAX_LIMIT);
            JsonHttp.write(exchange, 200, matchHistoryDao.listByUser(userId, effectiveLimit));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi tra cứu lịch sử đấu: " + e.getMessage());
        }
    }
}
