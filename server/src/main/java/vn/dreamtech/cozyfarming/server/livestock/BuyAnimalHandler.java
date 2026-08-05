package vn.dreamtech.cozyfarming.server.livestock;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.AnimalDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.Animal;

import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;

/**
 * POST /api/livestock/buy {userId, type} — khớp {@code buyAnimal()} client.
 * ⚠️ CHƯA trừ xu/kiểm tra sức chứa chuồng thật (hệ ví + chuồng chưa lên
 * server) — chỉ tạo bản ghi vật nuôi, TODO nối ví/chuồng ở giai đoạn sau.
 */
public final class BuyAnimalHandler implements HttpHandler {
    private final AnimalDao animalDao;

    public BuyAnimalHandler(AnimalDao animalDao) {
        this.animalDao = animalDao;
    }

    record Req(int userId, String type) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        if (req.type() == null || AnimalCatalog.find(req.type()).isEmpty()) {
            JsonHttp.writeError(exchange, 400, "Loại vật nuôi không hợp lệ");
            return;
        }
        try {
            long now = System.currentTimeMillis();
            Animal a = new Animal(UUID.randomUUID().toString(), req.type(), now, 0, now, 100, false, now);
            animalDao.upsert(req.userId(), a);
            JsonHttp.write(exchange, 201, a);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi mua vật nuôi: " + e.getMessage());
        }
    }
}
