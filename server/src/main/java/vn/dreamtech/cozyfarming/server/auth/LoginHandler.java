package vn.dreamtech.cozyfarming.server.auth;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.UserDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.User;
import vn.dreamtech.cozyfarming.server.security.PasswordHasher;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

/** POST /api/login {username, password} — khớp luồng "Đăng nhập" ở client (`login.ts` renderLogin). */
public final class LoginHandler implements HttpHandler {
    private final UserDao userDao;

    public LoginHandler(UserDao userDao) {
        this.userDao = userDao;
    }

    record Req(String username, String password) {
    }

    record Res(int userId, String username, int vnd) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        if (req.username() == null || req.password() == null) {
            JsonHttp.writeError(exchange, 400, "Thiếu tên đăng nhập hoặc mật khẩu");
            return;
        }
        try {
            Optional<User> found = userDao.findByUsername(req.username());
            if (found.isEmpty()) {
                JsonHttp.writeError(exchange, 401, "Tài khoản chưa tồn tại");
                return;
            }
            User user = found.get();
            if (user.loginLock()) {
                JsonHttp.writeError(exchange, 403, "Tài khoản đang bị khoá");
                return;
            }
            if (!PasswordHasher.verify(req.password(), user.passwordHash())) {
                JsonHttp.writeError(exchange, 401, "Sai mật khẩu");
                return;
            }
            JsonHttp.write(exchange, 200, new Res(user.id(), user.username(), user.vnd()));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi đăng nhập: " + e.getMessage());
        }
    }
}
