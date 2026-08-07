package vn.dreamtech.game.server.item;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.ItemDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

/** GET /api/items/catalog — toàn bộ item trong kho (public, để client hiện tên/loại phần thưởng). */
public final class ItemCatalogHandler implements HttpHandler {
    private final ItemDao itemDao;

    public ItemCatalogHandler(ItemDao itemDao) {
        this.itemDao = itemDao;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        try {
            JsonHttp.write(exchange, 200, itemDao.findAll());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy danh sách item: " + e.getMessage());
        }
    }
}
