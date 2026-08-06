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
 * POST /api/cooking/collect {userId} — khớp {@code collectCook()} client:
 * chưa chín thì chặn (409), chín rồi thì cộng vào ngăn "produce" với id
 * {@code food_<tên món>} (khớp {@code addTo('produce', `food_${f.id}`, 1)}).
 */
public final class CollectCookHandler implements HttpHandler {
    private final CookingStateDao cookingStateDao;
    private final FarmStoreDao farmStoreDao;

    public CollectCookHandler(CookingStateDao cookingStateDao, FarmStoreDao farmStoreDao) {
        this.cookingStateDao = cookingStateDao;
        this.farmStoreDao = farmStoreDao;
    }

    record Req(int userId) {
    }

    record Res(String foodId, int exp) {
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
                JsonHttp.writeError(exchange, 404, "Bếp đang rảnh, không có gì để lấy");
                return;
            }
            CookingState state = found.get();
            FoodDef def = FoodCatalog.find(state.foodId())
                    .orElseThrow(() -> new IllegalStateException("foodId không có trong catalog: " + state.foodId()));
            if (!CookingService.isDone(state, def)) {
                JsonHttp.writeError(exchange, 409, "Món chưa chín");
                return;
            }
            farmStoreDao.addTo(req.userId(), "produce", "food_" + def.id(), 1);
            cookingStateDao.clear(req.userId());
            JsonHttp.write(exchange, 200, new Res(def.id(), def.exp()));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy món: " + e.getMessage());
        }
    }
}
