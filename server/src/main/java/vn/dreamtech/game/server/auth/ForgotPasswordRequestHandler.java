package vn.dreamtech.game.server.auth;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.PasswordResetDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.model.PasswordReset;
import vn.dreamtech.game.server.security.PasswordHasher;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

/**
 * POST /api/auth/forgot/request {username} — sinh mã 6 số, hạn 15 phút.
 * ⚠️ CHƯA gửi email/SMS thật — trả thẳng {@code devOnlyCode} để test được
 * luồng, PHẢI thay bằng gửi thật trước khi triển khai.
 */
public final class ForgotPasswordRequestHandler implements HttpHandler {
    private final UserDao userDao;
    private final PasswordResetDao resetDao;
    private final SecureRandom random = new SecureRandom();

    public ForgotPasswordRequestHandler(UserDao userDao, PasswordResetDao resetDao) {
        this.userDao = userDao;
        this.resetDao = resetDao;
    }

    record Req(String username) {
    }

    record Res(boolean sent, String devOnlyCode) {
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
            if (found.isEmpty()) {
                // không lộ tài khoản có tồn tại hay không
                JsonHttp.write(exchange, 200, new Res(true, null));
                return;
            }
            String code = String.format("%06d", random.nextInt(1_000_000));
            resetDao.upsert(new PasswordReset(found.get().id(), PasswordHasher.hash(code), Instant.now().plus(15, ChronoUnit.MINUTES)));
            JsonHttp.write(exchange, 200, new Res(true, code));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi yêu cầu quên mật khẩu: " + e.getMessage());
        }
    }
}
