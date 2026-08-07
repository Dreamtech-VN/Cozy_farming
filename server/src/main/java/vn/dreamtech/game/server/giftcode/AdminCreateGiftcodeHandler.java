package vn.dreamtech.game.server.giftcode;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;
import vn.dreamtech.game.server.item.RewardEntry;

import java.io.IOException;
import java.util.List;

/** POST /api/admin/giftcode/create {code, title, rewards, maxUses, expiresAt} — cần header X-Admin-Token. */
public final class AdminCreateGiftcodeHandler implements HttpHandler {
    private final GiftcodeService giftcodeService;

    public AdminCreateGiftcodeHandler(GiftcodeService giftcodeService) {
        this.giftcodeService = giftcodeService;
    }

    record Req(String code, String title, List<RewardEntry> rewards, Integer maxUses, Long expiresAt) {
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
            JsonHttp.write(exchange, 201, giftcodeService.create(req.code(), req.title(), req.rewards(), req.maxUses(), req.expiresAt()));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
