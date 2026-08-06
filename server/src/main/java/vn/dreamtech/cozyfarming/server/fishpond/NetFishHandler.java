package vn.dreamtech.cozyfarming.server.fishpond;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.FarmStoreDao;
import vn.dreamtech.cozyfarming.server.dao.PondFishDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.PondFish;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.util.Optional;

/**
 * POST /api/fishpond/net {userId, id} — khớp {@code netFish()} client: vớt
 * cá đã lớn (đủ tuổi VÀ không đói), cộng vào ngăn "produce" của kho nông
 * trại với id {@code fish_<loại>} (khớp {@code addTo('produce', `fish_${def.id}`, qty)}).
 */
public final class NetFishHandler implements HttpHandler {
    private final PondFishDao pondFishDao;
    private final FarmStoreDao farmStoreDao;
    private final SecureRandom random = new SecureRandom();

    public NetFishHandler(PondFishDao pondFishDao, FarmStoreDao farmStoreDao) {
        this.pondFishDao = pondFishDao;
        this.farmStoreDao = farmStoreDao;
    }

    record Req(int userId, String id) {
    }

    record Res(String product, int qty, int exp) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            Optional<PondFish> found = pondFishDao.find(req.userId(), req.id());
            if (found.isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Không tìm thấy cá trong ao");
                return;
            }
            PondFish f = found.get();
            FryDef def = FryCatalog.find(f.type())
                    .orElseThrow(() -> new IllegalStateException("type không có trong catalog: " + f.type()));
            if (!FishPondService.isGrown(f, def)) {
                JsonHttp.writeError(exchange, 409, "Cá chưa lớn hoặc đang đói, chưa vớt được");
                return;
            }
            int qty = def.qtyMin() + random.nextInt(def.qtyMax() - def.qtyMin() + 1);
            String productId = "fish_" + def.id();
            farmStoreDao.addTo(req.userId(), "produce", productId, qty);
            pondFishDao.delete(req.userId(), req.id());
            JsonHttp.write(exchange, 200, new Res(productId, qty, def.exp()));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi vớt cá: " + e.getMessage());
        }
    }
}
