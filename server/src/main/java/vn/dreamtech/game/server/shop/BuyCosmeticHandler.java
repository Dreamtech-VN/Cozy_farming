package vn.dreamtech.game.server.shop;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.PlayerCosmeticDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.model.Wallet;

import java.io.IOException;
import java.sql.SQLException;

public final class BuyCosmeticHandler implements HttpHandler {
    private final UserDao userDao;
    private final WalletDao walletDao;
    private final PlayerCosmeticDao playerCosmeticDao;

    public BuyCosmeticHandler(UserDao userDao, WalletDao walletDao, PlayerCosmeticDao playerCosmeticDao) {
        this.userDao = userDao;
        this.walletDao = walletDao;
        this.playerCosmeticDao = playerCosmeticDao;
    }

    record Req(int userId, int itemId) {
    }

    record Res(int itemId, long paidGold, long goldRemaining) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        var item = ShopCatalog.find(req.itemId());
        if (item.isEmpty()) {
            JsonHttp.writeError(exchange, 404, "Vật phẩm không có trong shop");
            return;
        }
        try {
            if (userDao.findById(req.userId()).isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Không tìm thấy user");
                return;
            }
            if (playerCosmeticDao.isOwned(req.userId(), req.itemId())) {
                JsonHttp.writeError(exchange, 409, "Đã sở hữu vật phẩm này rồi");
                return;
            }
            long price = item.get().priceGold();
            if (price > 0 && !walletDao.spendGold(req.userId(), price)) {
                JsonHttp.writeError(exchange, 402, "Không đủ vàng (cần " + price + ")");
                return;
            }
            playerCosmeticDao.unlock(req.userId(), req.itemId());
            Wallet wallet = walletDao.find(req.userId());
            JsonHttp.write(exchange, 200, new Res(req.itemId(), price, wallet.gold()));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi mua vật phẩm: " + e.getMessage());
        }
    }
}
