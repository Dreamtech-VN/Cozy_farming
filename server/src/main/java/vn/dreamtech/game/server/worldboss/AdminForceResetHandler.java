package vn.dreamtech.game.server.worldboss;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;

/**
 * POST /api/admin/worldboss/reset — GM buộc kết thúc chu kỳ trùm thế giới
 * hiện tại và bắt đầu chu kỳ mới ngay lập tức, dùng khi chu kỳ bị kẹt
 * (VD: HP về 0 nhưng chưa tới giờ hết hạn tự nhiên). Cần header
 * X-Admin-Token.
 */
public final class AdminForceResetHandler implements HttpHandler {
    private final WorldBossService worldBossService;

    public AdminForceResetHandler(WorldBossService worldBossService) {
        this.worldBossService = worldBossService;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        try {
            AdminAuth.requireAdmin(exchange);
            JsonHttp.write(exchange, 200, worldBossService.adminForceReset());
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (WorldBossException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
