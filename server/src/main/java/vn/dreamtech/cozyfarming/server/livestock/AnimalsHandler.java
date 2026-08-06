package vn.dreamtech.cozyfarming.server.livestock;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.AnimalDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.http.QueryParam;
import vn.dreamtech.cozyfarming.server.model.Animal;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/** GET /api/livestock?userId= — danh sách vật nuôi kèm trạng thái TÍNH SẴN (đói/giai đoạn/sức khoẻ/có sản phẩm). */
public final class AnimalsHandler implements HttpHandler {
    private final AnimalDao animalDao;

    public AnimalsHandler(AnimalDao animalDao) {
        this.animalDao = animalDao;
    }

    record AnimalView(String id, String type, boolean hungry, int period, double health, boolean sick, boolean hasProduct) {
        static AnimalView of(Animal a, AnimalDef def) {
            return new AnimalView(a.id(), a.type(), AnimalService.isHungry(a), AnimalService.growthPeriod(a, def),
                    Math.round(AnimalService.currentHealth(a) * 10) / 10.0, a.sick(), AnimalService.hasProduct(a, def));
        }
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
            List<Animal> animals = animalDao.findAllByUser(userId);
            var views = animals.stream()
                    .map(a -> AnimalCatalog.find(a.type()).map(def -> AnimalView.of(a, def)).orElse(null))
                    .filter(v -> v != null)
                    .toList();
            JsonHttp.write(exchange, 200, views);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy danh sách vật nuôi: " + e.getMessage());
        }
    }
}
