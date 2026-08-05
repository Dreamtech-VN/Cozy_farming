package vn.dreamtech.cozyfarming.server.livestock;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.AnimalDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.Animal;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

/**
 * POST /api/livestock/sell {userId, id} — khớp {@code sellAnimal()} client:
 * hoàn 50% giá mua. ⚠️ CHƯA cộng thẳng vào ví server (hệ ví chưa lên
 * server) — trả số xu hoàn trong response.
 */
public final class SellAnimalHandler implements HttpHandler {
    private final AnimalDao animalDao;

    public SellAnimalHandler(AnimalDao animalDao) {
        this.animalDao = animalDao;
    }

    record Req(int userId, String id) {
    }

    record Res(int refund) {
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
            AnimalDef def = AnimalCatalog.find(found.get().type())
                    .orElseThrow(() -> new IllegalStateException("type không có trong catalog"));
            animalDao.delete(req.userId(), req.id());
            JsonHttp.write(exchange, 200, new Res(def.price() / 2));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi bán vật nuôi: " + e.getMessage());
        }
    }
}
