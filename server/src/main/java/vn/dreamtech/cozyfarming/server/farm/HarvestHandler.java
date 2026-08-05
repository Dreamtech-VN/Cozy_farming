package vn.dreamtech.cozyfarming.server.farm;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.FarmPlotDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.FarmPlot;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.util.Optional;

/**
 * POST /api/farm/harvest {userId, index} — thu hoạch cây chín, khớp {@code
 * harvest()} client: sản lượng ngẫu nhiên trong [yieldMin,yieldMax] rồi
 * nhân theo % sức khỏe (cây yếu thu ít hơn), ô đất reset về "empty" (Lttt
 * gốc: phải cuốc lại từ đầu, không giữ trạng thái đã cuốc).
 *
 * Giai đoạn này CHƯA cộng nông sản vào kho (hệ kho chưa lên server) — trả
 * số lượng thu được trong response để client tự cộng kho tạm thời, TODO nối
 * thẳng vào kho server khi có API kho.
 */
public final class HarvestHandler implements HttpHandler {
    private final FarmPlotDao plotDao;
    private final SecureRandom random = new SecureRandom();

    public HarvestHandler(FarmPlotDao plotDao) {
        this.plotDao = plotDao;
    }

    record Req(int userId, int index) {
    }

    record Res(String cropId, int qty, int health) {
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
            if (found.isEmpty() || !FarmService.isRipe(found.get())) {
                JsonHttp.writeError(exchange, 409, "Cây chưa chín hoặc ô đất không hợp lệ");
                return;
            }
            FarmPlot p = found.get();
            CropDef crop = CropCatalog.find(p.cropId())
                    .orElseThrow(() -> new IllegalStateException("cropId không có trong catalog: " + p.cropId()));
            int baseQty = crop.yieldMin() + random.nextInt(crop.yieldMax() - crop.yieldMin() + 1);
            int health = FarmService.healthOf(p);
            int qty = Math.max(1, Math.round(baseQty * health / 100f));

            plotDao.upsert(req.userId(), FarmPlot.empty(req.index()));
            JsonHttp.write(exchange, 200, new Res(crop.id(), qty, health));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi thu hoạch: " + e.getMessage());
        }
    }
}
