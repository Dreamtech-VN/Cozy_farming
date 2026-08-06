package vn.dreamtech.game.server.account;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.security.PasswordHasher;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/account/delete {userId, password?} — xoá vĩnh viễn tài khoản.
 * Tài khoản có mật khẩu (thường/đã nâng cấp) BẮT BUỘC xác nhận đúng mật
 * khẩu (401 nếu sai/thiếu) — chặn xoá nhầm/xoá phá hoại tài khoản người
 * khác nếu chiếm được userId. Tài khoản khách thuần (chưa có mật khẩu) xoá
 * thẳng, không cần xác nhận gì thêm.
 */
public final class DeleteAccountHandler implements HttpHandler {
    private final UserDao userDao;

    public DeleteAccountHandler(UserDao userDao) {
        this.userDao = userDao;
    }

    record Req(int userId, String password) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            var found = userDao.findById(req.userId());
            if (found.isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Không tìm thấy tài khoản");
                return;
            }
            if (found.get().passwordHash() != null
                    && (req.password() == null || !PasswordHasher.verify(req.password(), found.get().passwordHash()))) {
                JsonHttp.writeError(exchange, 401, "Mật khẩu không đúng");
                return;
            }
            userDao.delete(req.userId());
            JsonHttp.write(exchange, 200, new Object());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi xoá tài khoản: " + e.getMessage());
        }
    }
}
