package vn.dreamtech.game.server.auth;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.BannedUserDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;

/**
 * POST /api/auth/guest {guestToken?} — đăng nhập khách. Không gửi
 * {@code guestToken} (hoặc gửi token lạ) thì tạo tài khoản khách mới, trả
 * về token để client tự lưu lại (đăng nhập khách lần sau gửi đúng token này
 * để vào lại ĐÚNG tài khoản đó, không tạo mới).
 */
public final class GuestLoginHandler implements HttpHandler {
    private final UserDao userDao;
    private final BannedUserDao bannedUserDao;

    public GuestLoginHandler(UserDao userDao, BannedUserDao bannedUserDao) {
        this.userDao = userDao;
        this.bannedUserDao = bannedUserDao;
    }

    record Req(String guestToken) {
    }

    record Res(int userId, String guestToken, boolean isNew) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            if (req.guestToken() != null && !req.guestToken().isBlank()) {
                var found = userDao.findByGuestToken(req.guestToken());
                if (found.isPresent()) {
                    if (bannedUserDao.isBanned(found.get().id())) {
                        JsonHttp.writeError(exchange, 403, "Tài khoản đã bị cấm");
                        return;
                    }
                    JsonHttp.write(exchange, 200, new Res(found.get().id(), found.get().guestToken(), false));
                    return;
                }
            }
            String newToken = UUID.randomUUID().toString();
            var user = userDao.createGuest(newToken);
            JsonHttp.write(exchange, 201, new Res(user.id(), user.guestToken(), true));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi đăng nhập khách: " + e.getMessage());
        }
    }
}
