package vn.dreamtech.game.server.guild.war;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.guild.GuildException;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;

/** GET /api/guild/war/status?guildId= — trạng thái cuộc chiến gần nhất của guild. */
public final class WarStatusHandler implements HttpHandler {
    private final GuildWarService guildWarService;

    public WarStatusHandler(GuildWarService guildWarService) {
        this.guildWarService = guildWarService;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        Integer guildId = QueryParam.intParam(exchange.getRequestURI().getQuery(), "guildId");
        if (guildId == null) {
            JsonHttp.writeError(exchange, 400, "Thiếu tham số guildId");
            return;
        }
        try {
            JsonHttp.write(exchange, 200, guildWarService.status(guildId));
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
