package vn.dreamtech.game.server.item;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.dao.ItemDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

/** POST /api/admin/items/update {id, name, category, refId, description} — cần header X-Admin-Token. */
public final class AdminUpdateItemHandler implements HttpHandler {
    private final ItemDao itemDao;

    public AdminUpdateItemHandler(ItemDao itemDao) {
        this.itemDao = itemDao;
    }

    record Req(int id, String name, ItemCategory category, Integer refId, String description) {
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
            itemDao.find(req.id()).orElseThrow(() -> new ItemException(404, "Không tìm thấy item id=" + req.id()));
            itemDao.update(req.id(), req.name(), req.category(), req.refId(), req.description());
            JsonHttp.write(exchange, 200, itemDao.find(req.id()).orElseThrow());
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi cập nhật item: " + e.getMessage());
        }
    }
}
