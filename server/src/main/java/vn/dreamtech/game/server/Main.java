package vn.dreamtech.game.server;

import com.sun.net.httpserver.HttpServer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import vn.dreamtech.game.server.auth.ForgotPasswordRequestHandler;
import vn.dreamtech.game.server.auth.ForgotPasswordResetHandler;
import vn.dreamtech.game.server.auth.GuestLoginHandler;
import vn.dreamtech.game.server.auth.LinkSocialHandler;
import vn.dreamtech.game.server.auth.LoginHandler;
import vn.dreamtech.game.server.auth.RegisterHandler;
import vn.dreamtech.game.server.auth.SocialLoginHandler;
import vn.dreamtech.game.server.auth.UpgradeGuestHandler;
import vn.dreamtech.game.server.auth.oauth.AppleTokenVerifier;
import vn.dreamtech.game.server.auth.oauth.GoogleTokenVerifier;
import vn.dreamtech.game.server.dao.PasswordResetDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.db.DataSourceProvider;

import javax.sql.DataSource;
import java.net.InetSocketAddress;

/**
 * Điểm khởi động server. Giai đoạn 1: khung HTTP tối thiểu (/health) + DB.
 * Giai đoạn 2 (hiện tại): tài khoản — đăng ký/đăng nhập/quên mật khẩu/khách,
 * liên kết khách->thường, đăng nhập/liên kết Google/Apple (khung xác thực
 * dựng sẵn, Apple chưa xong thật — xem {@code AppleTokenVerifier}). Tạo
 * nhân vật, sảnh, chat, cài đặt thêm dần ở các giai đoạn sau.
 */
public final class Main {
    private static final Logger log = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) throws Exception {
        int port = Integer.parseInt(System.getProperty("server.port", "8080"));
        DataSource dataSource = DataSourceProvider.create();
        UserDao userDao = new UserDao(dataSource);
        PasswordResetDao resetDao = new PasswordResetDao(dataSource);
        var googleVerifier = new GoogleTokenVerifier(System.getenv("GOOGLE_CLIENT_ID"));
        var appleVerifier = new AppleTokenVerifier();

        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        server.createContext("/health", new HealthCheckHandler());
        server.createContext("/api/auth/register", new RegisterHandler(userDao));
        server.createContext("/api/auth/login", new LoginHandler(userDao));
        server.createContext("/api/auth/guest", new GuestLoginHandler(userDao));
        server.createContext("/api/auth/forgot/request", new ForgotPasswordRequestHandler(userDao, resetDao));
        server.createContext("/api/auth/forgot/reset", new ForgotPasswordResetHandler(userDao, resetDao));
        server.createContext("/api/auth/link/upgrade", new UpgradeGuestHandler(userDao));
        server.createContext("/api/auth/social/google", new SocialLoginHandler(userDao, googleVerifier, SocialLoginHandler.Provider.GOOGLE));
        server.createContext("/api/auth/social/apple", new SocialLoginHandler(userDao, appleVerifier, SocialLoginHandler.Provider.APPLE));
        server.createContext("/api/auth/link/google", new LinkSocialHandler(userDao, googleVerifier, SocialLoginHandler.Provider.GOOGLE));
        server.createContext("/api/auth/link/apple", new LinkSocialHandler(userDao, appleVerifier, SocialLoginHandler.Provider.APPLE));
        server.setExecutor(null);
        server.start();
        log.info("Game server đang chạy ở cổng {}", port);
    }

    private Main() {
    }
}
