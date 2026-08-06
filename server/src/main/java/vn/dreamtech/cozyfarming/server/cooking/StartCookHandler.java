package vn.dreamtech.cozyfarming.server.cooking;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.CookingStateDao;
import vn.dreamtech.cozyfarming.server.dao.FarmStoreDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

/**
 * POST /api/cooking/start {userId, foodId} — khớp {@code startCook()} client:
 * bếp đang bận thì chặn (409, mỗi user 1 món/lượt), trừ nguyên liệu từ ngăn
 * "produce" của kho nông trại TRƯỚC khi bắt đầu nấu, thiếu thì chặn (409).
 */
public final class StartCookHandler implements HttpHandler {
    private final CookingStateDao cookingStateDao;
    private final FarmStoreDao farmStoreDao;

    public StartCookHandler(CookingStateDao cookingStateDao, FarmStoreDao farmStoreDao) {
        this.cookingStateDao = cookingStateDao;
        this.farmStoreDao = farmStoreDao;
    }

    record Req(int userId, String foodId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        Optional<FoodDef> def = req.foodId() == null ? Optional.empty() : FoodCatalog.find(req.foodId());
        if (def.isEmpty()) {
            JsonHttp.writeError(exchange, 400, "foodId không hợp lệ");
            return;
        }
        try {
            if (cookingStateDao.find(req.userId()).isPresent()) {
                JsonHttp.writeError(exchange, 409, "Bếp đang bận — chờ món hiện tại xong đã");
                return;
            }
            for (FoodIngredient ing : def.get().material()) {
                if (farmStoreDao.countOf(req.userId(), "produce", ing.cropId()) < ing.qty()) {
                    JsonHttp.writeError(exchange, 409, "Kho không đủ nguyên liệu");
                    return;
                }
            }
            for (FoodIngredient ing : def.get().material()) {
                farmStoreDao.takeFrom(req.userId(), "produce", ing.cropId(), ing.qty());
            }
            long now = System.currentTimeMillis();
            cookingStateDao.start(req.userId(), req.foodId(), now);
            JsonHttp.write(exchange, 200, new vn.dreamtech.cozyfarming.server.model.CookingState(req.userId(), req.foodId(), now));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi bắt đầu nấu: " + e.getMessage());
        }
    }
}
