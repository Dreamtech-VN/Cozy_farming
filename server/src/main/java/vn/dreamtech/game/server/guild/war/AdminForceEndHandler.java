package vn.dreamtech.game.server.guild.war;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.guild.GuildException;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;

/**
 * POST /api/admin/guild/war/force-end {warId} — GM buộc kết thúc ngay 1
 * cuộc Guild War đang diễn ra, phân thắng thua theo điểm hiện tại (dùng khi
 * report bị kẹt hoặc 1 bên bỏ cuộc). Cần header X-Admin-Token.
 */
public final class AdminForceEndHandler implements HttpHandler {
    private final GuildWarService guildWarService;

    public AdminForceEndHandler(GuildWarService guildWarService) {
        this.guildWarService = guildWarService;
    }

    public record Req(String warId) {
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
            JsonHttp.write(exchange, 200, guildWarService.adminForceEnd(req.warId()));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
