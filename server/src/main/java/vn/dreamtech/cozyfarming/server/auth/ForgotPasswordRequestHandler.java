package vn.dreamtech.cozyfarming.server.auth;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.PasswordResetDao;
import vn.dreamtech.cozyfarming.server.dao.UserDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.User;
import vn.dreamtech.cozyfarming.server.security.PasswordHasher;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.time.Duration;
import java.time.Instant;
import java.util.Optional;

/**
 * POST /api/forgot/request {username} — sinh mã khôi phục 6 số, hạn 15 phút,
 * lưu HASH của mã (không lưu mã thô) vào bảng phụ {@code password_resets}.
 *
 * ⚠️ CHƯA gửi email/SMS thật (chưa cấu hình SMTP/gateway SMS trong môi trường
 * này) — response trả thẳng mã ra ngoài để còn TEST được luồng, đây là placeholder
 * rõ ràng phải thay bằng gửi qua email/SMS thật trước khi triển khai thật,
 * không được để lộ mã qua response trong bản chạy thật.
 */
public final class ForgotPasswordRequestHandler implements HttpHandler {
    private static final Duration TTL = Duration.ofMinutes(15);
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
            Optional<User> found = req.username() == null ? Optional.empty() : userDao.findByUsername(req.username());
            if (found.isEmpty()) {
                // không tiết lộ tài khoản có tồn tại hay không -> trả về y hệt trường hợp thành công
                JsonHttp.write(exchange, 200, new Res(true, null));
                return;
            }
            String code = String.format("%06d", random.nextInt(1_000_000));
            resetDao.upsert(found.get().id(), PasswordHasher.hash(code), Instant.now().plus(TTL));
            // TODO(triển khai thật): gửi `code` qua email (found.get().gmail()) hoặc SMS (phone),
            // KHÔNG trả trong response nữa — devOnlyCode chỉ phục vụ test giai đoạn này.
            JsonHttp.write(exchange, 200, new Res(true, code));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi tạo mã khôi phục: " + e.getMessage());
        }
    }
}
