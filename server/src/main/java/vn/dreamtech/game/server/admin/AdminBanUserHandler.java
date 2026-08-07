package vn.dreamtech.game.server.admin;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.BannedUserDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;
import java.sql.SQLException;

/** POST /api/admin/users/ban {userId, reason} — cấm đăng nhập (login/guest/social đều bị chặn). Cần header X-Admin-Token. */
public final class AdminBanUserHandler implements HttpHandler {
    private final UserDao userDao;
    private final BannedUserDao bannedUserDao;

    public AdminBanUserHandler(UserDao userDao, BannedUserDao bannedUserDao) {
        this.userDao = userDao;
        this.bannedUserDao = bannedUserDao;
    }

    record Req(int userId, String reason) {
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
            userDao.findById(req.userId()).orElseThrow(() -> new ItemException(404, "Không tìm thấy user"));
            bannedUserDao.ban(req.userId(), req.reason());
            JsonHttp.write(exchange, 200, bannedUserDao.find(req.userId()).orElseThrow());
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi cấm tài khoản: " + e.getMessage());
        }
    }
}
