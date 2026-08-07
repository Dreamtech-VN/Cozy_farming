package vn.dreamtech.game.server.giftcode;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;

/** GET /api/admin/giftcode/list — cần header X-Admin-Token (không public, tránh lộ danh sách code). */
public final class AdminListGiftcodesHandler implements HttpHandler {
    private final GiftcodeService giftcodeService;

    public AdminListGiftcodesHandler(GiftcodeService giftcodeService) {
        this.giftcodeService = giftcodeService;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        try {
            AdminAuth.requireAdmin(exchange);
            JsonHttp.write(exchange, 200, giftcodeService.listAll());
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
