package vn.dreamtech.cozyfarming.server.fishpond;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.BagDao;
import vn.dreamtech.cozyfarming.server.dao.PondFishDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.PondFish;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

/**
 * POST /api/fishpond/feed {userId, id} — khớp {@code feedFish()} client:
 * dùng CHUNG item {@code feed} trong túi đồ với vật nuôi trên cạn (Lttt gốc
 * không có thức ăn cá riêng — xem comment trong {@code fishfarm.ts}).
 */
public final class FeedFishHandler implements HttpHandler {
    private static final String FEED_ITEM = "feed";

    private final PondFishDao pondFishDao;
    private final BagDao bagDao;

    public FeedFishHandler(PondFishDao pondFishDao, BagDao bagDao) {
        this.pondFishDao = pondFishDao;
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
            Optional<PondFish> found = pondFishDao.find(req.userId(), req.id());
            if (found.isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Không tìm thấy cá trong ao");
                return;
            }
            PondFish f = found.get();
            if (!FishPondService.isHungry(f)) {
                JsonHttp.writeError(exchange, 409, "Cá này no rồi");
                return;
            }
            if (!bagDao.takeFrom(req.userId(), FEED_ITEM, 1)) {
                JsonHttp.writeError(exchange, 409, "Hết thức ăn trong túi đồ");
                return;
            }
            PondFish fed = new PondFish(f.id(), f.type(), f.at(), System.currentTimeMillis());
            pondFishDao.upsert(req.userId(), fed);
            JsonHttp.write(exchange, 200, fed);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi cho cá ăn: " + e.getMessage());
        }
    }
}
