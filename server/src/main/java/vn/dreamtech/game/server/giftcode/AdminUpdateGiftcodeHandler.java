package vn.dreamtech.game.server.giftcode;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;
import vn.dreamtech.game.server.item.RewardEntry;

import java.io.IOException;
import java.util.List;

/** POST /api/admin/giftcode/update {code, title, rewards, maxUses, expiresAt, active} — cần header X-Admin-Token. */
public final class AdminUpdateGiftcodeHandler implements HttpHandler {
    private final GiftcodeService giftcodeService;

    public AdminUpdateGiftcodeHandler(GiftcodeService giftcodeService) {
        this.giftcodeService = giftcodeService;
    }

    record Req(String code, String title, List<RewardEntry> rewards, Integer maxUses, Long expiresAt, boolean active) {
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
            JsonHttp.write(exchange, 200, giftcodeService.update(req.code(), req.title(), req.rewards(), req.maxUses(),
                    req.expiresAt(), req.active()));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
