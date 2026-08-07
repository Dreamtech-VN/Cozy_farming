package vn.dreamtech.game.server.giftcode;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;

/** POST /api/admin/giftcode/delete {code} — cần header X-Admin-Token. */
public final class AdminDeleteGiftcodeHandler implements HttpHandler {
    private final GiftcodeService giftcodeService;

    public AdminDeleteGiftcodeHandler(GiftcodeService giftcodeService) {
        this.giftcodeService = giftcodeService;
    }

    record Req(String code) {
    }

    record Res(boolean deleted) {
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
            giftcodeService.delete(req.code());
            JsonHttp.write(exchange, 200, new Res(true));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
