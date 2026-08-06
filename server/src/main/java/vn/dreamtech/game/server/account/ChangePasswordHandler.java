package vn.dreamtech.game.server.account;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.security.PasswordHasher;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/account/change-password {userId, currentPassword, newPassword}
 * — đổi mật khẩu khi ĐANG đăng nhập (khác {@code ForgotPasswordResetHandler}
 * — endpoint đó dùng khi KHÔNG đăng nhập được, xác thực bằng mã gửi qua
 * email/SMS thay vì mật khẩu cũ).
 */
public final class ChangePasswordHandler implements HttpHandler {
    private final UserDao userDao;

    public ChangePasswordHandler(UserDao userDao) {
        this.userDao = userDao;
    }

    record Req(int userId, String currentPassword, String newPassword) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        if (req.newPassword() == null || req.newPassword().length() < 6) {
            JsonHttp.writeError(exchange, 400, "Mật khẩu mới tối thiểu 6 ký tự");
            return;
        }
        try {
            var found = userDao.findById(req.userId());
            if (found.isEmpty() || found.get().passwordHash() == null) {
                JsonHttp.writeError(exchange, 404, "Tài khoản chưa có mật khẩu (khách/mạng xã hội thuần)");
                return;
            }
            if (req.currentPassword() == null || !PasswordHasher.verify(req.currentPassword(), found.get().passwordHash())) {
                JsonHttp.writeError(exchange, 401, "Mật khẩu hiện tại không đúng");
                return;
            }
            userDao.updatePassword(req.userId(), PasswordHasher.hash(req.newPassword()));
            JsonHttp.write(exchange, 200, new Object());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi đổi mật khẩu: " + e.getMessage());
        }
    }
}
