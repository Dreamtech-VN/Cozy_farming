package vn.dreamtech.game.server.guild;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/guild/join {userId, guildId} — vào guild trực tiếp (chưa có duyệt đơn — MVP, TODO khi cần). */
public final class JoinGuildHandler implements HttpHandler {
    private final GuildService guildService;

    public JoinGuildHandler(GuildService guildService) {
        this.guildService = guildService;
    }

    record Req(int userId, int guildId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            JsonHttp.write(exchange, 200, guildService.join(req.userId(), req.guildId()));
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
