package vn.dreamtech.game.server.character;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** GET /api/cosmetics/catalog — toàn bộ vật phẩm làm đẹp có thể sở hữu/trang bị. */
public final class CosmeticCatalogHandler implements HttpHandler {
    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        JsonHttp.write(exchange, 200, CosmeticCatalog.all());
    }
}
