package vn.dreamtech.game.server.guild;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/guild/kick {actorUserId, targetUserId} — hội trưởng/phó đuổi thành viên (không đuổi được hội trưởng). */
public final class KickMemberHandler implements HttpHandler {
    private final GuildService guildService;

    public KickMemberHandler(GuildService guildService) {
        this.guildService = guildService;
    }

    record Req(int actorUserId, int targetUserId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            guildService.kick(req.actorUserId(), req.targetUserId());
            JsonHttp.write(exchange, 200, new Object());
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
