package vn.dreamtech.game.server.guild;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/guild/create {userId, name, tag, description} — tốn vàng, người tạo trở thành hội trưởng. */
public final class CreateGuildHandler implements HttpHandler {
    private final GuildService guildService;

    public CreateGuildHandler(GuildService guildService) {
        this.guildService = guildService;
    }

    record Req(int userId, String name, String tag, String description) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            JsonHttp.write(exchange, 201, guildService.create(req.userId(), req.name(), req.tag(), req.description()));
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
