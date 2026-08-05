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
 * POST /api/livestock/feed {userId, id} — khớp {@code feed()} client.
 * ⚠️ CHƯA trừ item `feed` trong kho (hệ kho chưa lên server) — TODO giai đoạn sau.
 */
public final class FeedAnimalHandler implements HttpHandler {
    private final AnimalDao animalDao;

    public FeedAnimalHandler(AnimalDao animalDao) {
        this.animalDao = animalDao;
    }

    record Req(int userId, String id) {
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
            if (!AnimalService.isHungry(a)) {
                JsonHttp.writeError(exchange, 409, "Bé này no rồi");
                return;
            }
            long now = System.currentTimeMillis();
            Animal fed = new Animal(a.id(), a.type(), a.boughtAt(), now, now, a.health(), a.sick(), now);
            animalDao.upsert(req.userId(), fed);
            JsonHttp.write(exchange, 200, fed);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi cho ăn: " + e.getMessage());
        }
    }
}
