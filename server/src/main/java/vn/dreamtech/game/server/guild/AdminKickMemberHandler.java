package vn.dreamtech.game.server.guild;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;

/** POST /api/admin/guild/kick {guildId, targetUserId} — đuổi BẤT KỲ thành viên nào (kể cả hội trưởng). Cần header X-Admin-Token. */
public final class AdminKickMemberHandler implements HttpHandler {
    private final GuildService guildService;

    public AdminKickMemberHandler(GuildService guildService) {
        this.guildService = guildService;
    }

    record Req(int guildId, int targetUserId) {
    }

    record Res(boolean kicked) {
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
            guildService.adminKick(req.guildId(), req.targetUserId());
            JsonHttp.write(exchange, 200, new Res(true));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
