package vn.dreamtech.cozyfarming.server.inventory;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.FarmStoreDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.http.QueryParam;

import java.io.IOException;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * GET /api/inventory/farmstore?userId=&kind= — kho nông trại. {@code kind}
 * là 1 trong seeds/produce/fert/fish (bỏ trống -> trả cả 4 ngăn cùng lúc,
 * khớp {@code FarmService.getInventory()} client trả 3-4 danh sách 1 lần).
 */
public final class FarmStoreHandler implements HttpHandler {
    private static final List<String> KINDS = List.of("seeds", "produce", "fert", "fish");

    private final FarmStoreDao farmStoreDao;

    public FarmStoreHandler(FarmStoreDao farmStoreDao) {
        this.farmStoreDao = farmStoreDao;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        String query = exchange.getRequestURI().getQuery();
        Integer userId = QueryParam.intParam(query, "userId");
        if (userId == null) {
            JsonHttp.writeError(exchange, 400, "Thiếu tham số userId");
            return;
        }
        String kind = QueryParam.stringParam(query, "kind");
        if (kind != null && !KINDS.contains(kind)) {
            JsonHttp.writeError(exchange, 400, "kind không hợp lệ (seeds/produce/fert/fish)");
            return;
        }
        try {
            if (kind != null) {
                JsonHttp.write(exchange, 200, farmStoreDao.listOf(userId, kind));
                return;
            }
            Map<String, Map<String, Integer>> all = new LinkedHashMap<>();
            for (String k : KINDS) all.put(k, farmStoreDao.listOf(userId, k));
            JsonHttp.write(exchange, 200, all);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy kho nông trại: " + e.getMessage());
        }
    }
}
