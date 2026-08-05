package vn.dreamtech.cozyfarming.server;

import com.sun.net.httpserver.HttpServer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import vn.dreamtech.cozyfarming.server.auth.ForgotPasswordRequestHandler;
import vn.dreamtech.cozyfarming.server.auth.ForgotPasswordResetHandler;
import vn.dreamtech.cozyfarming.server.auth.LoginHandler;
import vn.dreamtech.cozyfarming.server.auth.RegisterHandler;
import vn.dreamtech.cozyfarming.server.dao.PasswordResetDao;
import vn.dreamtech.cozyfarming.server.dao.UserDao;
import vn.dreamtech.cozyfarming.server.db.DataSourceProvider;

import javax.sql.DataSource;
import java.net.InetSocketAddress;

/**
 * Điểm khởi động server. Giai đoạn 1: khung HTTP tối thiểu (/health). Giai
 * đoạn 2: DB + DAO. Giai đoạn 3 (hiện tại): API đăng ký/đăng nhập/quên mật
 * khẩu. Các module còn lại (nông trại, vật nuôi, tủ đồ, chat...) thêm dần ở
 * giai đoạn sau, mỗi giai đoạn xong mới sang giai đoạn kế tiếp.
 */
public final class Main {
    private static final Logger log = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) throws Exception {
        int port = Integer.parseInt(System.getProperty("server.port", "8080"));
        DataSource dataSource = DataSourceProvider.create();
        UserDao userDao = new UserDao(dataSource);
        PasswordResetDao resetDao = new PasswordResetDao(dataSource);

        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        server.createContext("/health", new HealthCheckHandler());
        server.createContext("/api/register", new RegisterHandler(userDao));
        server.createContext("/api/login", new LoginHandler(userDao));
        server.createContext("/api/forgot/request", new ForgotPasswordRequestHandler(userDao, resetDao));
        server.createContext("/api/forgot/reset", new ForgotPasswordResetHandler(userDao, resetDao));
        server.setExecutor(null);
        server.start();
        log.info("Cozy Farming server đang chạy ở cổng {}", port);
    }

    private Main() {
    }
}
