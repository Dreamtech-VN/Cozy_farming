package vn.dreamtech.game.server.auth;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.security.PasswordHasher;

import java.io.IOException;
import java.sql.SQLException;

/** POST /api/auth/register {username, password} — tạo tài khoản thường mới (không phải nâng cấp từ khách). */
public final class RegisterHandler implements HttpHandler {
    private final UserDao userDao;

    public RegisterHandler(UserDao userDao) {
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
        if (req.username() == null || req.username().isBlank() || req.password() == null || req.password().length() < 6) {
            JsonHttp.writeError(exchange, 400, "Tên đăng nhập/mật khẩu không hợp lệ (mật khẩu tối thiểu 6 ký tự)");
            return;
        }
        try {
            if (userDao.findByUsername(req.username()).isPresent()) {
                JsonHttp.writeError(exchange, 409, "Tên đăng nhập đã tồn tại");
                return;
            }
            var user = userDao.createReal(req.username(), PasswordHasher.hash(req.password()), req.username());
            JsonHttp.write(exchange, 201, new Res(user.id(), user.username()));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi đăng ký: " + e.getMessage());
        }
    }
}
