package vn.dreamtech.cozyfarming.server.shop;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.BagDao;
import vn.dreamtech.cozyfarming.server.dao.FarmStoreDao;
import vn.dreamtech.cozyfarming.server.dao.WalletDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/shop/sell {userId, itemId, qty} — bán vật phẩm cho tiệm, trừ
 * ĐÚNG kho (nông trại hay túi đồ) rồi cộng xu thật. Định giá khớp
 * {@code produceSell()} client qua {@link ShopService#sellPriceOf}.
 */
public final class SellItemHandler implements HttpHandler {
    private final FarmStoreDao farmStoreDao;
    private final BagDao bagDao;
    private final WalletDao walletDao;

    public SellItemHandler(FarmStoreDao farmStoreDao, BagDao bagDao, WalletDao walletDao) {
        this.farmStoreDao = farmStoreDao;
        this.bagDao = bagDao;
        this.walletDao = walletDao;
    }

    record Req(int userId, String itemId, Integer qty) {
    }

    record Res(String itemId, int qty, int revenue) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        int qty = req.qty() == null ? 1 : req.qty();
        if (req.itemId() == null || qty < 1) {
            JsonHttp.writeError(exchange, 400, "itemId/qty không hợp lệ");
            return;
        }
        int price = ShopService.sellPriceOf(req.itemId());
        if (price <= 0) {
            JsonHttp.writeError(exchange, 400, "Vật phẩm không bán được");
            return;
        }
        try {
            ShopService.StoreSlot slot = ShopService.resolveSlot(req.itemId());
            boolean taken = slot != null
                    ? farmStoreDao.takeFrom(req.userId(), slot.kind(), slot.key(), qty)
                    : bagDao.takeFrom(req.userId(), req.itemId(), qty);
            if (!taken) {
                JsonHttp.writeError(exchange, 409, "Không đủ số lượng trong kho");
                return;
            }
            int revenue = price * qty;
            walletDao.addCoins(req.userId(), revenue);
            JsonHttp.write(exchange, 200, new Res(req.itemId(), qty, revenue));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi bán vật phẩm: " + e.getMessage());
        }
    }
}
