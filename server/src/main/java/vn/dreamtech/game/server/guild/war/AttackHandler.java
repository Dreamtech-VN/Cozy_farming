package vn.dreamtech.game.server.guild.war;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.guild.GuildException;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/guild/war/attack {userId} — bắt đầu lượt đánh Guild War cá nhân (1 lần/cuộc chiến). */
public final class AttackHandler implements HttpHandler {
    private final GuildWarService guildWarService;

    public AttackHandler(GuildWarService guildWarService) {
        this.guildWarService = guildWarService;
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
            JsonHttp.write(exchange, 201, guildWarService.attack(req.userId()));
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
