package vn.dreamtech.game.server.auth;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.PasswordResetDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.security.PasswordHasher;

import java.io.IOException;
import java.sql.SQLException;
import java.time.Instant;

/** POST /api/auth/forgot/reset {username, code, newPassword} — đặt lại mật khẩu bằng mã đã gửi. */
public final class ForgotPasswordResetHandler implements HttpHandler {
    private final UserDao userDao;
    private final PasswordResetDao resetDao;

    public ForgotPasswordResetHandler(UserDao userDao, PasswordResetDao resetDao) {
        this.userDao = userDao;
        this.resetDao = resetDao;
    }

    record Req(String username, String code, String newPassword) {
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
            var found = req.username() == null ? java.util.Optional.<vn.dreamtech.game.server.model.User>empty()
                    : userDao.findByUsername(req.username());
            if (found.isEmpty()) {
                JsonHttp.writeError(exchange, 400, "Mã khôi phục không hợp lệ");
                return;
            }
            var reset = resetDao.find(found.get().id());
            if (reset.isEmpty() || reset.get().expiresAt().isBefore(Instant.now())
                    || req.code() == null || !PasswordHasher.verify(req.code(), reset.get().codeHash())) {
                JsonHttp.writeError(exchange, 400, "Mã khôi phục không hợp lệ hoặc đã hết hạn");
                return;
            }
            userDao.updatePassword(found.get().id(), PasswordHasher.hash(req.newPassword()));
            resetDao.delete(found.get().id());
            JsonHttp.write(exchange, 200, new RegisterHandler.Res(found.get().id(), found.get().username()));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi đặt lại mật khẩu: " + e.getMessage());
        }
    }
}
