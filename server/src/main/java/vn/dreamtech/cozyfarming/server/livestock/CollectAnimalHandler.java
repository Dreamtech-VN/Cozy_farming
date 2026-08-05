package vn.dreamtech.cozyfarming.server.livestock;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.AnimalDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.Animal;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.util.Optional;

/**
 * POST /api/livestock/collect {userId, id} — khớp {@code collect()} client:
 * trả sản phẩm (trứng/sữa/thịt/len) + exp. ⚠️ CHƯA cộng thẳng vào kho server
 * (hệ kho chưa lên server) — trả trong response, client tự cộng kho tạm.
 */
public final class CollectAnimalHandler implements HttpHandler {
    private final AnimalDao animalDao;
    private final SecureRandom random = new SecureRandom();

    public CollectAnimalHandler(AnimalDao animalDao) {
        this.animalDao = animalDao;
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
            Optional<Animal> found = animalDao.find(req.userId(), req.id());
            if (found.isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Không tìm thấy vật nuôi");
                return;
            }
            Animal a = found.get();
            AnimalDef def = AnimalCatalog.find(a.type())
                    .orElseThrow(() -> new IllegalStateException("type không có trong catalog: " + a.type()));
            if (!AnimalService.hasProduct(a, def)) {
                JsonHttp.writeError(exchange, 409, "Vật nuôi chưa có sản phẩm để thu");
                return;
            }
            int qty = def.productQtyMin() + random.nextInt(def.productQtyMax() - def.productQtyMin() + 1);
            long now = System.currentTimeMillis();
            Animal collected = new Animal(a.id(), a.type(), a.boughtAt(), a.fedAt(), now, a.health(), a.sick(), a.healthAt());
            animalDao.upsert(req.userId(), collected);
            JsonHttp.write(exchange, 200, new Res(def.product(), qty, def.exp()));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi thu sản phẩm: " + e.getMessage());
        }
    }
}
