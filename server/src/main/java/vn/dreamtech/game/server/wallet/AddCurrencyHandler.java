package vn.dreamtech.game.server.wallet;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/wallet/add {userId, gold?, diamond?} — cộng vàng/kim cương.
 * ⚠️ CHƯA có hệ kiếm tiền thật (shop bán vật phẩm, thưởng nhiệm vụ/trận đấu)
 * — đây là HOOK sẵn cho các hệ đó gọi vào sau, tạm thời chỉ dùng để test.
 */
public final class AddCurrencyHandler implements HttpHandler {
    private final WalletDao walletDao;

    public AddCurrencyHandler(WalletDao walletDao) {
        this.walletDao = walletDao;
    }

    record Req(int userId, Long gold, Long diamond) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        if ((req.gold() == null || req.gold() <= 0) && (req.diamond() == null || req.diamond() <= 0)) {
            JsonHttp.writeError(exchange, 400, "Phải cộng ít nhất 1 loại tiền, giá trị lớn hơn 0");
            return;
        }
        try {
            if (req.gold() != null && req.gold() > 0) walletDao.addGold(req.userId(), req.gold());
            if (req.diamond() != null && req.diamond() > 0) walletDao.addDiamond(req.userId(), req.diamond());
            JsonHttp.write(exchange, 200, walletDao.find(req.userId()));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi cộng tiền: " + e.getMessage());
        }
    }
}
