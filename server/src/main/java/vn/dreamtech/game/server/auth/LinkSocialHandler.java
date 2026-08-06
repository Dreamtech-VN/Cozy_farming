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
 * POST /api/auth/link/{google,apple} {userId, idToken} — gắn thêm mạng xã
 * hội vào tài khoản ĐANG đăng nhập (thường là tài khoản thường username/mật
 * khẩu, nhưng khách cũng gắn được). Chặn nếu id nhà cung cấp đó đã gắn cho
 * user KHÁC (409) — không tự động gộp 2 tài khoản.
 */
public final class LinkSocialHandler implements HttpHandler {
    private final UserDao userDao;
    private final OAuthVerifier verifier;
    private final SocialLoginHandler.Provider provider;

    public LinkSocialHandler(UserDao userDao, OAuthVerifier verifier, SocialLoginHandler.Provider provider) {
        this.userDao = userDao;
        this.verifier = verifier;
        this.provider = provider;
    }

    record Req(int userId, String idToken) {
    }

    record Res(int userId, String provider) {
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
            if (userDao.findById(req.userId()).isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Không tìm thấy tài khoản");
                return;
            }
            ProviderIdentity identity = verifier.verify(req.idToken());
            Optional<User> existing = provider == SocialLoginHandler.Provider.GOOGLE
                    ? userDao.findByGoogleId(identity.providerUserId())
                    : userDao.findByAppleId(identity.providerUserId());
            if (existing.isPresent() && existing.get().id() != req.userId()) {
                JsonHttp.writeError(exchange, 409, "Tài khoản mạng xã hội này đã liên kết với 1 tài khoản khác");
                return;
            }
            if (provider == SocialLoginHandler.Provider.GOOGLE) userDao.linkGoogle(req.userId(), identity.providerUserId());
            else userDao.linkApple(req.userId(), identity.providerUserId());
            JsonHttp.write(exchange, 200, new Res(req.userId(), provider.name().toLowerCase()));
        } catch (OAuthVerificationException e) {
            JsonHttp.writeError(exchange, 401, e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi liên kết mạng xã hội: " + e.getMessage());
        }
    }
}
