package vn.dreamtech.game.server.auth;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.auth.oauth.OAuthVerificationException;
import vn.dreamtech.game.server.auth.oauth.OAuthVerifier;
import vn.dreamtech.game.server.auth.oauth.ProviderIdentity;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

/**
 * POST /api/auth/social/{google,apple} {idToken} — đăng nhập THẲNG bằng
 * mạng xã hội (khác {@link LinkSocialHandler} — endpoint đó gắn thêm vào
 * tài khoản đang đăng nhập sẵn). Đã liên kết trước đó thì đăng nhập lại
 * đúng tài khoản; chưa từng liên kết thì tạo tài khoản MỚI chỉ có mạng xã
 * hội (chưa có username/password) — người chơi có thể set thêm sau qua
 * {@link UpgradeGuestHandler} nếu muốn có thêm cách đăng nhập bằng mật khẩu.
 */
public final class SocialLoginHandler implements HttpHandler {
    public enum Provider { GOOGLE, APPLE }

    private final UserDao userDao;
    private final OAuthVerifier verifier;
    private final Provider provider;

    public SocialLoginHandler(UserDao userDao, OAuthVerifier verifier, Provider provider) {
        this.userDao = userDao;
        this.verifier = verifier;
        this.provider = provider;
    }

    record Req(String idToken) {
    }

    record Res(int userId, boolean isNew) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        if (req.idToken() == null || req.idToken().isBlank()) {
            JsonHttp.writeError(exchange, 400, "Thiếu idToken");
            return;
        }
        try {
            ProviderIdentity identity = verifier.verify(req.idToken());
            Optional<User> found = provider == Provider.GOOGLE
                    ? userDao.findByGoogleId(identity.providerUserId())
                    : userDao.findByAppleId(identity.providerUserId());
            if (found.isPresent()) {
                JsonHttp.write(exchange, 200, new Res(found.get().id(), false));
                return;
            }
            User user = userDao.createReal(null, null, identity.email());
            if (provider == Provider.GOOGLE) userDao.linkGoogle(user.id(), identity.providerUserId());
            else userDao.linkApple(user.id(), identity.providerUserId());
            JsonHttp.write(exchange, 201, new Res(user.id(), true));
        } catch (OAuthVerificationException e) {
            JsonHttp.writeError(exchange, 401, e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi đăng nhập mạng xã hội: " + e.getMessage());
        }
    }
}
