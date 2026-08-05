package vn.dreamtech.cozyfarming.server.livestock;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.AnimalDao;
import vn.dreamtech.cozyfarming.server.dao.WalletDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.Animal;

import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;

/**
 * POST /api/livestock/buy {userId, type} — khớp {@code buyAnimal()} client:
 * trừ xu thật qua {@link WalletDao} trước khi tạo vật nuôi.
 * ⚠️ CHƯA kiểm tra sức chứa chuồng thật (hệ chuồng/nâng cấp chưa lên server)
 * — TODO giai đoạn sau.
 */
public final class BuyAnimalHandler implements HttpHandler {
    private final AnimalDao animalDao;
    private final WalletDao walletDao;

    public BuyAnimalHandler(AnimalDao animalDao, WalletDao walletDao) {
        this.animalDao = animalDao;
        this.walletDao = walletDao;
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
        var def = req.type() == null ? java.util.Optional.<AnimalDef>empty() : AnimalCatalog.find(req.type());
        if (def.isEmpty()) {
            JsonHttp.writeError(exchange, 400, "Loại vật nuôi không hợp lệ");
            return;
        }
        try {
            if (!walletDao.spendCoins(req.userId(), def.get().price())) {
                JsonHttp.writeError(exchange, 402, "Không đủ xu");
                return;
            }
            long now = System.currentTimeMillis();
            Animal a = new Animal(UUID.randomUUID().toString(), req.type(), now, 0, now, 100, false, now);
            animalDao.upsert(req.userId(), a);
            JsonHttp.write(exchange, 201, a);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi mua vật nuôi: " + e.getMessage());
        }
    }
}
