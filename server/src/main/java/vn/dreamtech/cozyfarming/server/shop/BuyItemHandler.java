package vn.dreamtech.cozyfarming.server.shop;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.BagDao;
import vn.dreamtech.cozyfarming.server.dao.FarmStoreDao;
import vn.dreamtech.cozyfarming.server.dao.WalletDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

/**
 * POST /api/shop/buy {userId, itemId, qty} — mua vật phẩm ở tiệm, trừ xu
 * thật rồi cộng thẳng vào ĐÚNG kho (nông trại hay túi đồ, xem
 * {@link ShopService#resolveSlot}). Hạt giống định giá theo
 * {@link vn.dreamtech.cozyfarming.server.farm.CropCatalog}, còn lại theo
 * {@link ShopCatalog}.
 */
public final class BuyItemHandler implements HttpHandler {
    private final FarmStoreDao farmStoreDao;
    private final BagDao bagDao;
    private final WalletDao walletDao;

    public BuyItemHandler(FarmStoreDao farmStoreDao, BagDao bagDao, WalletDao walletDao) {
        this.farmStoreDao = farmStoreDao;
        this.bagDao = bagDao;
        this.walletDao = walletDao;
    }

    record Req(int userId, String itemId, Integer qty) {
    }

    record Res(String itemId, int qty, int cost) {
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
        Optional<Integer> price = ShopService.buyPriceOf(req.itemId());
        if (price.isEmpty()) {
            JsonHttp.writeError(exchange, 400, "Vật phẩm không mua được ở tiệm");
            return;
        }
        int cost = price.get() * qty;
        try {
            if (!walletDao.spendCoins(req.userId(), cost)) {
                JsonHttp.writeError(exchange, 402, "Không đủ xu");
                return;
            }
            ShopService.StoreSlot slot = ShopService.resolveSlot(req.itemId());
            if (slot != null) {
                farmStoreDao.addTo(req.userId(), slot.kind(), slot.key(), qty);
            } else {
                bagDao.addTo(req.userId(), req.itemId(), qty);
            }
            JsonHttp.write(exchange, 200, new Res(req.itemId(), qty, cost));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi mua vật phẩm: " + e.getMessage());
        }
    }
}
