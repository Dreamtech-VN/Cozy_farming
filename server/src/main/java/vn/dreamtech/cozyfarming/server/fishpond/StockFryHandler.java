package vn.dreamtech.cozyfarming.server.fishpond;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.PondFishDao;
import vn.dreamtech.cozyfarming.server.dao.WalletDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.PondFish;

import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;

/**
 * POST /api/fishpond/stock {userId, type} — khớp {@code stockFry()} client:
 * kiểm tra sức chứa ao ({@link FishPondService#POND_CAP} = 6), trừ xu thật
 * qua {@link WalletDao} trước khi thả cá giống.
 */
public final class StockFryHandler implements HttpHandler {
    private final PondFishDao pondFishDao;
    private final WalletDao walletDao;

    public StockFryHandler(PondFishDao pondFishDao, WalletDao walletDao) {
        this.pondFishDao = pondFishDao;
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
        var def = req.type() == null ? java.util.Optional.<FryDef>empty() : FryCatalog.find(req.type());
        if (def.isEmpty()) {
            JsonHttp.writeError(exchange, 400, "Loại cá giống không hợp lệ");
            return;
        }
        try {
            if (pondFishDao.countByUser(req.userId()) >= FishPondService.POND_CAP) {
                JsonHttp.writeError(exchange, 409, "Ao chỉ nuôi được " + FishPondService.POND_CAP + " con");
                return;
            }
            if (!walletDao.spendCoins(req.userId(), def.get().price())) {
                JsonHttp.writeError(exchange, 402, "Không đủ xu");
                return;
            }
            PondFish f = new PondFish(UUID.randomUUID().toString(), req.type(), System.currentTimeMillis(), null);
            pondFishDao.upsert(req.userId(), f);
            JsonHttp.write(exchange, 201, f);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi thả cá giống: " + e.getMessage());
        }
    }
}
