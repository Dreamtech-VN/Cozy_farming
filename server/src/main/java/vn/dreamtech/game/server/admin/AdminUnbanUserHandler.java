package vn.dreamtech.game.server.admin;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.BannedUserDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;
import java.sql.SQLException;

/** POST /api/admin/users/unban {userId} — gỡ cấm. Cần header X-Admin-Token. */
public final class AdminUnbanUserHandler implements HttpHandler {
    private final BannedUserDao bannedUserDao;

    public AdminUnbanUserHandler(BannedUserDao bannedUserDao) {
        this.bannedUserDao = bannedUserDao;
    }

    record Req(int userId) {
    }

    record Res(boolean unbanned) {
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
            bannedUserDao.unban(req.userId());
            JsonHttp.write(exchange, 200, new Res(true));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi gỡ cấm: " + e.getMessage());
        }
    }
}
