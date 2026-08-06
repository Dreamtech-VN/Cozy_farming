package vn.dreamtech.cozyfarming.server.fishing;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.BagDao;
import vn.dreamtech.cozyfarming.server.dao.WalletDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

/**
 * POST /api/fishing/cast {userId} — khớp {@code handleQuangCau()}/{@code onCanCau()}/
 * {@code CauThanhCong()} thật: trừ 1 mồi câu (item {@value FishCatalog#BAIT_ITEM_ID})
 * trong túi đồ, rồi quay trọng số thật. Câu được thì TỰ BÁN NGAY (cộng thẳng
 * xu theo giá {@code coin} thật của cá, không giữ trong túi — khớp
 * {@code AvatarService.sellFish()}); riêng cá mập còn thưởng thêm 1 mảnh
 * ghép. ⚠️ CHƯA kiểm tra cần câu đang trang bị (item 446) — hệ "đang mặc gì"
 * chưa lên server, TODO giai đoạn sau khi tủ đồ có trạng thái trang bị thật.
 */
public final class CastHandler implements HttpHandler {
    private final BagDao bagDao;
    private final WalletDao walletDao;

    public CastHandler(BagDao bagDao, WalletDao walletDao) {
        this.bagDao = bagDao;
        this.walletDao = walletDao;
    }

    record Req(int userId) {
    }

    record Res(boolean caught, Integer itemId, int coin) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            if (!bagDao.takeFrom(req.userId(), FishCatalog.BAIT_ITEM_ID, 1)) {
                JsonHttp.writeError(exchange, 409, "Hết mồi câu");
                return;
            }
            Optional<FishDef> caught = FishingService.rollCatch();
            if (caught.isEmpty()) {
                JsonHttp.write(exchange, 200, new Res(false, null, 0));
                return;
            }
            FishDef def = caught.get();
            walletDao.addCoins(req.userId(), def.coin());
            if (def.itemId() == FishCatalog.SHARK_FISH_ID) {
                bagDao.addTo(req.userId(), FishCatalog.SHARK_BONUS_ITEM_ID, 1);
            }
            JsonHttp.write(exchange, 200, new Res(true, def.itemId(), def.coin()));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi câu cá: " + e.getMessage());
        }
    }
}
