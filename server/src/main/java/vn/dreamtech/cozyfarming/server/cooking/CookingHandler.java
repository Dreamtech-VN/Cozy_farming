package vn.dreamtech.cozyfarming.server.cooking;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.CookingStateDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.http.QueryParam;
import vn.dreamtech.cozyfarming.server.model.CookingState;

import java.io.IOException;
import java.sql.SQLException;

/** GET /api/cooking?userId= — trạng thái bếp hiện tại, {@code null} nếu bếp đang rảnh (khớp {@code cookingFood()} client). */
public final class CookingHandler implements HttpHandler {
    private final CookingStateDao cookingStateDao;

    public CookingHandler(CookingStateDao cookingStateDao) {
        this.cookingStateDao = cookingStateDao;
    }

    record View(String foodId, long remainSec, boolean done) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        Integer userId = QueryParam.intParam(exchange.getRequestURI().getQuery(), "userId");
        if (userId == null) {
            JsonHttp.writeError(exchange, 400, "Thiếu tham số userId");
            return;
        }
        try {
            var found = cookingStateDao.find(userId);
            if (found.isEmpty()) {
                JsonHttp.write(exchange, 200, null);
                return;
            }
            CookingState state = found.get();
            FoodDef def = FoodCatalog.find(state.foodId())
                    .orElseThrow(() -> new IllegalStateException("foodId không có trong catalog: " + state.foodId()));
            long remain = CookingService.remainSeconds(state, def);
            JsonHttp.write(exchange, 200, new View(state.foodId(), remain, remain <= 0));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy trạng thái bếp: " + e.getMessage());
        }
    }
}
