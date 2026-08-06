package vn.dreamtech.game.server.character;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.PlayerCosmeticDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;
import java.sql.SQLException;

/** GET /api/cosmetics/owned?userId= — danh sách item id user đang sở hữu. */
public final class OwnedCosmeticsHandler implements HttpHandler {
    private final PlayerCosmeticDao playerCosmeticDao;

    public OwnedCosmeticsHandler(PlayerCosmeticDao playerCosmeticDao) {
        this.playerCosmeticDao = playerCosmeticDao;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        Integer userId = QueryParam.intParam(exchange.getRequestURI().getQuery(), "userId");
        if (userId == null) {
            JsonHttp.writeError(exchange, 400, "Thiếu tham số userId");
            return;
        }
        try {
            JsonHttp.write(exchange, 200, playerCosmeticDao.listOwned(userId));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy vật phẩm sở hữu: " + e.getMessage());
        }
    }
}
