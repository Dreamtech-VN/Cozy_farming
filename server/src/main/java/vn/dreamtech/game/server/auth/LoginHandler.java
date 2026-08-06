package vn.dreamtech.game.server.auth;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.security.PasswordHasher;

import java.io.IOException;
import java.sql.SQLException;

/** POST /api/auth/login {username, password} — đăng nhập tài khoản thường. */
public final class LoginHandler implements HttpHandler {
    private final UserDao userDao;

    public LoginHandler(UserDao userDao) {
        this.userDao = userDao;
    }

    record Req(String username, String password) {
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
        try {
            var found = req.username() == null ? java.util.Optional.<vn.dreamtech.game.server.model.User>empty()
                    : userDao.findByUsername(req.username());
            if (found.isEmpty() || found.get().passwordHash() == null
                    || !PasswordHasher.verify(req.password() == null ? "" : req.password(), found.get().passwordHash())) {
                JsonHttp.writeError(exchange, 401, "Sai tên đăng nhập hoặc mật khẩu");
                return;
            }
            JsonHttp.write(exchange, 200, new Res(found.get().id(), found.get().username()));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi đăng nhập: " + e.getMessage());
        }
    }
}
