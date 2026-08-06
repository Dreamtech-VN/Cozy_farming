package vn.dreamtech.game.server.guild;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/guild/disband {userId} — chỉ hội trưởng giải tán được, xoá luôn toàn bộ thành viên. */
public final class DisbandGuildHandler implements HttpHandler {
    private final GuildService guildService;

    public DisbandGuildHandler(GuildService guildService) {
        this.guildService = guildService;
    }

    record Req(int userId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            guildService.disband(req.userId());
            JsonHttp.write(exchange, 200, new Object());
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
