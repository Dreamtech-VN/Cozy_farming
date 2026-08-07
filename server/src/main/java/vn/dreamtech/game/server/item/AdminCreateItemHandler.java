package vn.dreamtech.game.server.item;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.dao.ItemDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

/** POST /api/admin/items/create {name, category, refId, description} — cần header X-Admin-Token. */
public final class AdminCreateItemHandler implements HttpHandler {
    private final ItemDao itemDao;

    public AdminCreateItemHandler(ItemDao itemDao) {
        this.itemDao = itemDao;
    }

    record Req(String name, ItemCategory category, Integer refId, String description) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        try {
            AdminAuth.requireAdmin(exchange);
            Req req = JsonHttp.readBody(exchange, Req.class);
            if (req.name() == null || req.name().isBlank() || req.category() == null) {
                JsonHttp.writeError(exchange, 400, "Thiếu name/category");
                return;
            }
            if (req.category() == ItemCategory.COSMETIC && req.refId() == null) {
                JsonHttp.writeError(exchange, 400, "Item loại COSMETIC cần refId (id trong CosmeticCatalog)");
                return;
            }
            JsonHttp.write(exchange, 201, itemDao.create(req.name(), req.category(), req.refId(), req.description()));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi tạo item: " + e.getMessage());
        }
    }
}
