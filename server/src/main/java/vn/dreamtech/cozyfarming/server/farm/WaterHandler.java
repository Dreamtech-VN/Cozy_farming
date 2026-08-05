package vn.dreamtech.cozyfarming.server.farm;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.FarmPlotDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.FarmPlot;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

/** POST /api/farm/water {userId, index} — tưới cây đã trồng, khớp {@code water()} client (+20 sức khỏe, tối đa 100). */
public final class WaterHandler implements HttpHandler {
    private final FarmPlotDao plotDao;

    public WaterHandler(FarmPlotDao plotDao) {
        this.plotDao = plotDao;
    }

    record Req(int userId, int index) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            Optional<FarmPlot> found = plotDao.find(req.userId(), req.index());
            if (found.isEmpty() || !"planted".equals(found.get().state()) || found.get().watered()) {
                JsonHttp.writeError(exchange, 409, "Ô đất không thể tưới lúc này");
                return;
            }
            FarmPlot p = found.get();
            int newHealth = Math.min(100, FarmService.healthOf(p) + 20);
            FarmPlot watered = new FarmPlot(p.index(), p.state(), p.cropId(), p.plantedAt(),
                    true, System.currentTimeMillis(), p.fertilized(), newHealth);
            plotDao.upsert(req.userId(), watered);
            JsonHttp.write(exchange, 200, watered);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi tưới cây: " + e.getMessage());
        }
    }
}
