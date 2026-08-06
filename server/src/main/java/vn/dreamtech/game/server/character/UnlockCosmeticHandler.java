package vn.dreamtech.game.server.character;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.PlayerCosmeticDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/cosmetics/unlock {userId, itemId} — cấp quyền sở hữu vật phẩm
 * làm đẹp. Đây là hook tạm đứng thay cho shop/thành tựu/gacha chưa xây,
 * giống {@code AddCurrencyHandler}/{@code AddExpHandler}.
 */
public final class UnlockCosmeticHandler implements HttpHandler {
    private final PlayerCosmeticDao playerCosmeticDao;

    public UnlockCosmeticHandler(PlayerCosmeticDao playerCosmeticDao) {
        this.playerCosmeticDao = playerCosmeticDao;
    }

    record Req(int userId, int itemId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        if (CosmeticCatalog.find(req.itemId()).isEmpty()) {
            JsonHttp.writeError(exchange, 400, "Vật phẩm không tồn tại");
            return;
        }
        try {
            playerCosmeticDao.unlock(req.userId(), req.itemId());
            JsonHttp.write(exchange, 200, new Object());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi mở khoá vật phẩm: " + e.getMessage());
        }
    }
}
