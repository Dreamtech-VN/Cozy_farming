package vn.dreamtech.game.server.admin;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/admin/users/wallet/adjust {userId, goldDelta, diamondDelta} —
 * GM tool cộng/trừ trực tiếp (delta âm = trừ), khác {@code /api/wallet/add}
 * (không cần xác thực, chỉ cộng) vì đây admin toàn quyền trừ luôn, kẹp về 0
 * thay vì chặn thao tác. Cần header X-Admin-Token.
 */
public final class AdminAdjustWalletHandler implements HttpHandler {
    private final UserDao userDao;
    private final WalletDao walletDao;

    public AdminAdjustWalletHandler(UserDao userDao, WalletDao walletDao) {
        this.userDao = userDao;
        this.walletDao = walletDao;
    }

    record Req(int userId, long goldDelta, long diamondDelta) {
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
            walletDao.adjustGold(req.userId(), req.goldDelta());
            var updated = walletDao.adjustDiamond(req.userId(), req.diamondDelta());
            JsonHttp.write(exchange, 200, updated);
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi chỉnh ví: " + e.getMessage());
        }
    }
}
