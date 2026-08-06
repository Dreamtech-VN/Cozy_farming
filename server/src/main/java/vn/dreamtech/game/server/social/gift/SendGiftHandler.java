package vn.dreamtech.game.server.social.gift;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.FriendshipDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

/**
 * POST /api/friends/gift {fromUserId, toUserId, giftId} — tặng quà cho bạn
 * bè, cộng điểm thân mật. Chỉ tặng được cho BẠN BÈ (404 nếu chưa kết bạn),
 * và tối đa 1 LẦN/CẶP BẠN/NGÀY ({@value #GIFT_COOLDOWN_MS} ms) để tránh gọi
 * API liên tục max điểm thân mật tức thì — vẫn tặng lại được sau khi hết hạn.
 */
public final class SendGiftHandler implements HttpHandler {
    static final long GIFT_COOLDOWN_MS = 24 * 3_600_000L;

    private final FriendshipDao friendshipDao;

    public SendGiftHandler(FriendshipDao friendshipDao) {
        this.friendshipDao = friendshipDao;
    }

    record Req(int fromUserId, int toUserId, String giftId) {
    }

    record Res(int intimacyPoints) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        Optional<GiftDef> gift = req.giftId() == null ? Optional.empty() : GiftCatalog.find(req.giftId());
        if (gift.isEmpty()) {
            JsonHttp.writeError(exchange, 400, "Quà tặng không hợp lệ");
            return;
        }
        try {
            var friendship = friendshipDao.find(req.fromUserId(), req.toUserId());
            if (friendship.isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Chưa kết bạn, không tặng quà được");
                return;
            }
            long now = System.currentTimeMillis();
            Long lastGiftAt = friendship.get().lastGiftAt();
            if (lastGiftAt != null && now - lastGiftAt < GIFT_COOLDOWN_MS) {
                JsonHttp.writeError(exchange, 429, "Hôm nay đã tặng quà cho người này rồi, mai quay lại nhé");
                return;
            }
            friendshipDao.addIntimacy(req.fromUserId(), req.toUserId(), gift.get().intimacyPoints(), now);
            int newPoints = friendshipDao.find(req.fromUserId(), req.toUserId()).orElseThrow().intimacyPoints();
            JsonHttp.write(exchange, 200, new Res(newPoints));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi tặng quà: " + e.getMessage());
        }
    }
}
