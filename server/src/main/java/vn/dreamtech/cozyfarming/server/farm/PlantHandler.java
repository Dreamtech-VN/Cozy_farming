package vn.dreamtech.cozyfarming.server.farm;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.FarmPlotDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.FarmPlot;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

/**
 * POST /api/farm/plant {userId, index, cropId} — gieo hạt lên ô đã cuốc,
 * khớp {@code plant()} client. Giai đoạn này CHƯA trừ hạt giống trong kho
 * (hệ kho/inventory chưa lên server) — chỉ kiểm tra cropId có thật trong
 * `CropCatalog`, TODO trừ kho khi có API kho ở giai đoạn sau.
 */
public final class PlantHandler implements HttpHandler {
    private final FarmPlotDao plotDao;

    public PlantHandler(FarmPlotDao plotDao) {
        this.plotDao = plotDao;
    }

    record Req(int userId, int index, String cropId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        if (req.cropId() == null || CropCatalog.find(req.cropId()).isEmpty()) {
            JsonHttp.writeError(exchange, 400, "cropId không hợp lệ");
            return;
        }
        try {
            Optional<FarmPlot> found = plotDao.find(req.userId(), req.index());
            if (found.isEmpty() || !"tilled".equals(found.get().state())) {
                JsonHttp.writeError(exchange, 409, "Ô đất chưa được cuốc");
                return;
            }
            FarmPlot planted = new FarmPlot(req.index(), "planted", req.cropId(),
                    System.currentTimeMillis(), false, null, false, 100);
            plotDao.upsert(req.userId(), planted);
            JsonHttp.write(exchange, 200, planted);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi gieo hạt: " + e.getMessage());
        }
    }
}
