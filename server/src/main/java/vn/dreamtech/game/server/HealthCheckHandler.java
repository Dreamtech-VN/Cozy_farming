package vn.dreamtech.game.server;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** GET /health — xác nhận server sống. */
public final class HealthCheckHandler implements HttpHandler {
    record Status(String status) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        JsonHttp.write(exchange, 200, new Status("ok"));
    }
}
