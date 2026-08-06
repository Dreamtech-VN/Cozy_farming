package vn.dreamtech.game.server.guild;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;

/** GET /api/guild/info?guildId= — thông tin guild kèm danh sách thành viên. */
public final class GuildInfoHandler implements HttpHandler {
    private final GuildService guildService;

    public GuildInfoHandler(GuildService guildService) {
        this.guildService = guildService;
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
            JsonHttp.write(exchange, 200, guildService.info(guildId));
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
