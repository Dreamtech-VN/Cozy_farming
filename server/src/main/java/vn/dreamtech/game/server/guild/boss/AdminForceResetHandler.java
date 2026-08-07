package vn.dreamtech.game.server.guild.boss;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.guild.GuildException;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;

/**
 * POST /api/admin/guild/boss/reset {guildId} — GM buộc kết thúc chu kỳ
 * trùm guild hiện tại và bắt đầu chu kỳ mới ngay lập tức, dùng khi chu kỳ
 * bị kẹt. Cần header X-Admin-Token.
 */
public final class AdminForceResetHandler implements HttpHandler {
    private final GuildBossService guildBossService;

    public AdminForceResetHandler(GuildBossService guildBossService) {
        this.guildBossService = guildBossService;
    }

    public record Req(int guildId) {
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
            JsonHttp.write(exchange, 200, guildBossService.adminForceReset(req.guildId()));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
