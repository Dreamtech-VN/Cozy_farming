package vn.dreamtech.game.server.guild;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** GET /api/guild/list — danh sách guild kèm số thành viên hiện tại/tối đa. */
public final class GuildListHandler implements HttpHandler {
    private final GuildService guildService;

    public GuildListHandler(GuildService guildService) {
        this.guildService = guildService;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        try {
            JsonHttp.write(exchange, 200, guildService.list());
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
