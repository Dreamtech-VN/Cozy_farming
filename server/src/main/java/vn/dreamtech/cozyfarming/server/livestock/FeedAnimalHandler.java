package vn.dreamtech.cozyfarming.server.livestock;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.AnimalDao;
import vn.dreamtech.cozyfarming.server.dao.BagDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.Animal;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

/**
 * POST /api/livestock/feed {userId, id} — khớp {@code feed()} client: trừ 1
 * item {@code feed} thật trong túi đồ qua {@link BagDao} trước khi cho ăn.
 */
public final class FeedAnimalHandler implements HttpHandler {
    private static final String FEED_ITEM = "feed";

    private final AnimalDao animalDao;
    private final BagDao bagDao;

    public FeedAnimalHandler(AnimalDao animalDao, BagDao bagDao) {
        this.animalDao = animalDao;
        this.bagDao = bagDao;
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
            if (!bagDao.takeFrom(req.userId(), FEED_ITEM, 1)) {
                JsonHttp.writeError(exchange, 409, "Hết thức ăn trong túi đồ");
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
