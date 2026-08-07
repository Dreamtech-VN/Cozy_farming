package vn.dreamtech.game.server.admin;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.PlayerCosmeticDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/admin/cosmetics/revoke {userId, itemId} — GM thu hồi 1 vật
 * phẩm làm đẹp mà user đang sở hữu, dùng khi phát hiện gian lận (exploit
 * nhân bản item, lỗi mở khoá không qua thành tựu/shop thật). Cần header
 * X-Admin-Token.
 */
public final class AdminRevokeCosmeticHandler implements HttpHandler {
    private final UserDao userDao;
    private final PlayerCosmeticDao playerCosmeticDao;

    public AdminRevokeCosmeticHandler(UserDao userDao, PlayerCosmeticDao playerCosmeticDao) {
        this.userDao = userDao;
        this.playerCosmeticDao = playerCosmeticDao;
    }

    public record Req(int userId, int itemId) {
    }

    public record Res(boolean revoked) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        try {
            AdminAuth.requireAdmin(exchange);
            Req req = JsonHttp.readBody(exchange, Req.class);
            userDao.findById(req.userId()).orElseThrow(() -> new ItemException(404, "Không tìm thấy user"));
            if (!playerCosmeticDao.isOwned(req.userId(), req.itemId())) {
                throw new ItemException(404, "User không sở hữu vật phẩm này");
            }
            playerCosmeticDao.revoke(req.userId(), req.itemId());
            JsonHttp.write(exchange, 200, new Res(true));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi thu hồi vật phẩm làm đẹp: " + e.getMessage());
        }
    }
}
