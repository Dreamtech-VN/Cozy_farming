package vn.dreamtech.game.server;

import com.sun.net.httpserver.HttpServer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import vn.dreamtech.game.server.db.DataSourceProvider;

import javax.sql.DataSource;
import java.net.InetSocketAddress;

/**
 * Điểm khởi động server. Giai đoạn 1 (hiện tại): khung HTTP tối thiểu
 * (/health) + kết nối DB. Đăng ký/đăng nhập/khách/liên kết tài khoản, tạo
 * nhân vật, sảnh, chat thêm dần ở các giai đoạn sau.
 */
public final class Main {
    private static final Logger log = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) throws Exception {
        int port = Integer.parseInt(System.getProperty("server.port", "8080"));
        DataSource dataSource = DataSourceProvider.create();

        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        server.createContext("/health", new HealthCheckHandler());
        server.setExecutor(null);
        server.start();
        log.info("Game server đang chạy ở cổng {}", port);
    }

    private Main() {
    }
}
