package vn.dreamtech.cozyfarming.server.wardrobe;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.ItemDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.Item;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * GET /api/items?zorder=50&gender=1 — trả đúng danh sách tóc/áo/quần/kính/đồ
 * cầm tay theo z-order + giới tính, khớp {@code registerList()} phía client
 * (`chibi.ts`) — cùng bảng `items` thật, chỉ chuyển việc lọc từ client sang
 * server (bước đầu để sau này chặn gian lận, client không tự lọc tuỳ ý).
 */
public final class ItemsHandler implements HttpHandler {
    private final ItemDao itemDao;

    public ItemsHandler(ItemDao itemDao) {
        this.itemDao = itemDao;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        Map<String, String> query = parseQuery(exchange.getRequestURI().getQuery());
        Integer zorder = parseIntOrNull(query.get("zorder"));
        Integer gender = parseIntOrNull(query.get("gender"));
        if (zorder == null || gender == null) {
            JsonHttp.writeError(exchange, 400, "Thiếu tham số zorder hoặc gender");
            return;
        }
        try {
            List<Item> items = itemDao.findByZorderAndGender(zorder, gender);
            JsonHttp.write(exchange, 200, items);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy danh sách trang bị: " + e.getMessage());
        }
    }

    private static Integer parseIntOrNull(String s) {
        if (s == null) return null;
        try {
            return Integer.parseInt(s);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private static Map<String, String> parseQuery(String query) {
        if (query == null || query.isBlank()) return Map.of();
        Map<String, String> out = new java.util.HashMap<>();
        for (String pair : query.split("&")) {
            int eq = pair.indexOf('=');
            if (eq < 0) continue;
            out.put(pair.substring(0, eq), pair.substring(eq + 1));
        }
        return out;
    }
}
