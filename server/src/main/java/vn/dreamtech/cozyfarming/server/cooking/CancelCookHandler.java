package vn.dreamtech.cozyfarming.server.cooking;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.CookingStateDao;
import vn.dreamtech.cozyfarming.server.dao.FarmStoreDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.CookingState;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

/**
 * POST /api/cooking/cancel {userId} — khớp {@code cancelCook()} client: hủy
 * nấu (kể cả đã chín hay chưa), trả lại nguyên liệu vào kho.
 */
public final class CancelCookHandler implements HttpHandler {
    private final CookingStateDao cookingStateDao;
    private final FarmStoreDao farmStoreDao;

    public CancelCookHandler(CookingStateDao cookingStateDao, FarmStoreDao farmStoreDao) {
        this.cookingStateDao = cookingStateDao;
        this.farmStoreDao = farmStoreDao;
    }

    record Req(int userId) {
    }

    record Res(String foodId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            Optional<CookingState> found = cookingStateDao.find(req.userId());
            if (found.isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Bếp đang rảnh, không có gì để hủy");
                return;
            }
            CookingState state = found.get();
            FoodDef def = FoodCatalog.find(state.foodId())
                    .orElseThrow(() -> new IllegalStateException("foodId không có trong catalog: " + state.foodId()));
            for (FoodIngredient ing : def.material()) {
                farmStoreDao.addTo(req.userId(), "produce", ing.cropId(), ing.qty());
            }
            cookingStateDao.clear(req.userId());
            JsonHttp.write(exchange, 200, new Res(state.foodId()));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi hủy nấu: " + e.getMessage());
        }
    }
}
