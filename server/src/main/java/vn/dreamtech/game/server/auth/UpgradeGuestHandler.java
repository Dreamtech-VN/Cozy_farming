package vn.dreamtech.game.server.auth;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.security.PasswordHasher;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/auth/link/upgrade {userId, username, password} — khách nâng
 * cấp lên tài khoản thường: gắn username/password vào ĐÚNG user id đang
 * chơi, giữ nguyên toàn bộ tiến trình (không tạo tài khoản mới). Chặn nếu
 * user đã có username (không phải khách thuần) hoặc username bị trùng.
 */
public final class UpgradeGuestHandler implements HttpHandler {
    private final UserDao userDao;

    public UpgradeGuestHandler(UserDao userDao) {
        this.userDao = userDao;
    }

    record Req(int userId, String username, String password) {
    }

    record Res(int userId, String username) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        if (req.username() == null || req.username().isBlank() || req.password() == null || req.password().length() < 6) {
            JsonHttp.writeError(exchange, 400, "Tên đăng nhập/mật khẩu không hợp lệ (mật khẩu tối thiểu 6 ký tự)");
            return;
        }
        try {
            var found = userDao.findById(req.userId());
            if (found.isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Không tìm thấy tài khoản");
                return;
            }
            if (!found.get().isGuestOnly()) {
                JsonHttp.writeError(exchange, 409, "Tài khoản này đã là tài khoản thường, không phải khách");
                return;
            }
            if (userDao.findByUsername(req.username()).isPresent()) {
                JsonHttp.writeError(exchange, 409, "Tên đăng nhập đã tồn tại");
                return;
            }
            userDao.upgradeGuestToReal(req.userId(), req.username(), PasswordHasher.hash(req.password()), req.username());
            JsonHttp.write(exchange, 200, new Res(req.userId(), req.username()));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi nâng cấp tài khoản: " + e.getMessage());
        }
    }
}
