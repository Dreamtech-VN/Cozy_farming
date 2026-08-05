package vn.dreamtech.cozyfarming.server.auth;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.PasswordResetDao;
import vn.dreamtech.cozyfarming.server.dao.UserDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.PasswordReset;
import vn.dreamtech.cozyfarming.server.model.User;
import vn.dreamtech.cozyfarming.server.security.PasswordHasher;

import java.io.IOException;
import java.sql.SQLException;
import java.time.Instant;
import java.util.Optional;

/** POST /api/forgot/reset {username, code, newPassword} — khớp bước cuối luồng "Quên mật khẩu" ở client. */
public final class ForgotPasswordResetHandler implements HttpHandler {
    private final UserDao userDao;
    private final PasswordResetDao resetDao;

    public ForgotPasswordResetHandler(UserDao userDao, PasswordResetDao resetDao) {
        this.userDao = userDao;
        this.resetDao = resetDao;
    }

    record Req(String username, String code, String newPassword) {
    }

    record Res(boolean reset) {
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
            Optional<User> found = req.username() == null ? Optional.empty() : userDao.findByUsername(req.username());
            if (found.isEmpty()) {
                JsonHttp.writeError(exchange, 400, "Mã khôi phục không đúng hoặc đã hết hạn");
                return;
            }
            User user = found.get();
            Optional<PasswordReset> reset = resetDao.find(user.id());
            if (reset.isEmpty() || reset.get().expiresAt().isBefore(Instant.now())
                    || req.code() == null || !PasswordHasher.verify(req.code(), reset.get().codeHash())) {
                JsonHttp.writeError(exchange, 400, "Mã khôi phục không đúng hoặc đã hết hạn");
                return;
            }
            userDao.updatePassword(user.id(), PasswordHasher.hash(req.newPassword()));
            resetDao.delete(user.id());   // dùng 1 lần, tránh phát lại (replay) mã cũ
            JsonHttp.write(exchange, 200, new Res(true));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi đặt lại mật khẩu: " + e.getMessage());
        }
    }
}
