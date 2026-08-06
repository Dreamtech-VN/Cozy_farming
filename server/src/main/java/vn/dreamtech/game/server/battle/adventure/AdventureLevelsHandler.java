package vn.dreamtech.game.server.battle.adventure;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** GET /api/battle/adventure/levels — danh sách màn Adventure. */
public final class AdventureLevelsHandler implements HttpHandler {
    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        JsonHttp.write(exchange, 200, AdventureLevelCatalog.all());
    }
}
