package vn.dreamtech.game.server.item;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.dao.ItemDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/admin/items/delete {id} — cần header X-Admin-Token. KHÔNG kiểm
 * tra item đang được giftcode/thư/sự kiện nào tham chiếu (rewards lưu JSON
 * nên không ràng buộc khoá ngoại được) — xoá nhầm item đang dùng thì lúc
 * claim sẽ báo lỗi "không tìm thấy item" thay vì cấp sai. TODO: cảnh báo/
 * chặn xoá khi đang được tham chiếu.
 */
public final class AdminDeleteItemHandler implements HttpHandler {
    private final ItemDao itemDao;

    public AdminDeleteItemHandler(ItemDao itemDao) {
        this.itemDao = itemDao;
    }

    record Req(int id) {
    }

    record Res(boolean deleted) {
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
            itemDao.find(req.id()).orElseThrow(() -> new ItemException(404, "Không tìm thấy item id=" + req.id()));
            itemDao.delete(req.id());
            JsonHttp.write(exchange, 200, new Res(true));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi xoá item: " + e.getMessage());
        }
    }
}
