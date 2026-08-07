package vn.dreamtech.game.server.giftcode;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;

/** POST /api/giftcode/redeem {userId, code} — đổi thành công thì phần thưởng nằm trong hộp thư, tự vào thư nhận. */
public final class RedeemGiftcodeHandler implements HttpHandler {
    private final GiftcodeService giftcodeService;

    public RedeemGiftcodeHandler(GiftcodeService giftcodeService) {
        this.giftcodeService = giftcodeService;
    }

    record Req(int userId, String code) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            JsonHttp.write(exchange, 201, giftcodeService.redeem(req.userId(), req.code()));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
