package vn.dreamtech.game.server.admin;

import com.sun.net.httpserver.HttpServer;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.item.ItemException;

import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import static org.junit.jupiter.api.Assertions.assertEquals;

/** Test logic so khớp token qua HTTP thật (không set biến môi trường ADMIN_TOKEN — dùng overload package-private để tiêm token kỳ vọng). */
class AdminAuthTest {
    private HttpServer server;
    private int port;
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/protected", exchange -> {
            try {
                AdminAuth.requireAdmin(exchange, "secret-token");
                byte[] body = "ok".getBytes();
                exchange.sendResponseHeaders(200, body.length);
                exchange.getResponseBody().write(body);
            } catch (ItemException e) {
                byte[] body = e.getMessage().getBytes();
                exchange.sendResponseHeaders(e.status(), body.length);
                exchange.getResponseBody().write(body);
            } finally {
                exchange.close();
            }
        });
        server.createContext("/unconfigured", exchange -> {
            try {
                AdminAuth.requireAdmin(exchange, null);
                exchange.sendResponseHeaders(200, -1);
            } catch (ItemException e) {
                byte[] body = e.getMessage().getBytes();
                exchange.sendResponseHeaders(e.status(), body.length);
                exchange.getResponseBody().write(body);
            } finally {
                exchange.close();
            }
        });
        server.setExecutor(null);
        server.start();
        port = server.getAddress().getPort();
    }

    @AfterEach
    void stop() {
        server.stop(0);
    }

    @Test
    void missingHeaderRejected() throws Exception {
        var req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/protected")).GET().build();
        var res = http.send(req, HttpResponse.BodyHandlers.ofString());
        assertEquals(401, res.statusCode());
    }

    @Test
    void wrongTokenRejected() throws Exception {
        var req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/protected"))
                .header("X-Admin-Token", "wrong").GET().build();
        var res = http.send(req, HttpResponse.BodyHandlers.ofString());
        assertEquals(401, res.statusCode());
    }

    @Test
    void correctTokenAccepted() throws Exception {
        var req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/protected"))
                .header("X-Admin-Token", "secret-token").GET().build();
        var res = http.send(req, HttpResponse.BodyHandlers.ofString());
        assertEquals(200, res.statusCode());
        assertEquals("ok", res.body());
    }

    @Test
    void unconfiguredServerRejectsEvenWithHeader() throws Exception {
        var req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/unconfigured"))
                .header("X-Admin-Token", "anything").GET().build();
        var res = http.send(req, HttpResponse.BodyHandlers.ofString());
        assertEquals(503, res.statusCode());
    }
}
