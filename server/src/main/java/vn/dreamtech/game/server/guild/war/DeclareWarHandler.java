package vn.dreamtech.game.server.guild.war;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.guild.GuildException;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/guild/war/declare {userId, targetGuildId} — hội trưởng/phó tuyên chiến với guild khác. */
public final class DeclareWarHandler implements HttpHandler {
    private final GuildWarService guildWarService;

    public DeclareWarHandler(GuildWarService guildWarService) {
        this.guildWarService = guildWarService;
    }

    record Req(int userId, int targetGuildId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            JsonHttp.write(exchange, 201, guildWarService.declare(req.userId(), req.targetGuildId()));
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
