package vn.dreamtech.cozyfarming.server.fishpond;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.PondFishDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.http.QueryParam;
import vn.dreamtech.cozyfarming.server.model.PondFish;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/** GET /api/fishpond?userId= — danh sách cá trong ao kèm trạng thái TÍNH SẴN (đói/lớn chưa/còn mấy phút). */
public final class PondHandler implements HttpHandler {
    private final PondFishDao pondFishDao;

    public PondHandler(PondFishDao pondFishDao) {
        this.pondFishDao = pondFishDao;
    }

    record FishView(String id, String type, boolean hungry, boolean grown, int remainMin) {
        static FishView of(PondFish f, FryDef def) {
            return new FishView(f.id(), f.type(), FishPondService.isHungry(f),
                    FishPondService.isGrown(f, def), FishPondService.remainMin(f, def));
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
            List<PondFish> fishes = pondFishDao.findAllByUser(userId);
            var views = fishes.stream()
                    .map(f -> FryCatalog.find(f.type()).map(def -> FishView.of(f, def)).orElse(null))
                    .filter(v -> v != null)
                    .toList();
            JsonHttp.write(exchange, 200, views);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy danh sách ao cá: " + e.getMessage());
        }
    }
}
