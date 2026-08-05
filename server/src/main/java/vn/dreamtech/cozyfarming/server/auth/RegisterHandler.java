package vn.dreamtech.cozyfarming.server.auth;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.UserDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.security.PasswordHasher;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/register {username, password, gmail?} — khớp đúng luồng "Đăng
 * ký" ở client (`src/ui/login.ts` renderRegister): cùng ràng buộc tên 3-24
 * ký tự, mật khẩu tối thiểu 6 ký tự. Khác với client offline (tự sinh mã
 * khôi phục và CHỈ hiện 1 lần trên máy), server thật không cần vì đã có
 * cột `gmail` — mã khôi phục thật xin ở bước quên mật khẩu riêng.
 */
public final class RegisterHandler implements HttpHandler {
    private final UserDao userDao;

    public RegisterHandler(UserDao userDao) {
        this.userDao = userDao;
    }

    record Req(String username, String password, String gmail) {
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
        if (req.username() == null || req.username().length() < 3 || req.username().length() > 24) {
            JsonHttp.writeError(exchange, 400, "Tên đăng nhập phải từ 3-24 ký tự");
            return;
        }
        if (req.password() == null || req.password().length() < 6) {
            JsonHttp.writeError(exchange, 400, "Mật khẩu tối thiểu 6 ký tự");
            return;
        }
        try {
            if (userDao.findByUsername(req.username()).isPresent()) {
                JsonHttp.writeError(exchange, 409, "Tên đăng nhập đã có người dùng");
                return;
            }
            String hash = PasswordHasher.hash(req.password());
            int userId = userDao.create(req.username(), hash, req.gmail());
            JsonHttp.write(exchange, 201, new Res(userId, req.username()));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi tạo tài khoản: " + e.getMessage());
        }
    }
}
