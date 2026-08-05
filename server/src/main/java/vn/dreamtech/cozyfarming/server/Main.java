package vn.dreamtech.cozyfarming.server;

import com.sun.net.httpserver.HttpServer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.InetSocketAddress;

/**
 * Điểm khởi động server. Giai đoạn 1: chỉ dựng HTTP server tối thiểu với một
 * endpoint /health để xác nhận project build/chạy được — các API thật (đăng
 * ký/đăng nhập, nông trại, vật nuôi...) sẽ thêm dần ở các giai đoạn sau, mỗi
 * giai đoạn xong mới sang giai đoạn kế tiếp.
 */
public final class Main {
    private static final Logger log = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) throws Exception {
        int port = Integer.parseInt(System.getProperty("server.port", "8080"));
        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        server.createContext("/health", new HealthCheckHandler());
        server.setExecutor(null);
        server.start();
        log.info("Cozy Farming server đang chạy ở cổng {}", port);
    }

    private Main() {
    }
}
