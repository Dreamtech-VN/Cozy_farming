package vn.dreamtech.game.server.guild;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;

/** GET /api/guild/my?userId= — guild của user hiện tại, 404 nếu chưa vào guild nào. */
public final class MyGuildHandler implements HttpHandler {
    private final GuildService guildService;

    public MyGuildHandler(GuildService guildService) {
        this.guildService = guildService;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        Integer userId = QueryParam.intParam(exchange.getRequestURI().getQuery(), "userId");
        if (userId == null) {
            JsonHttp.writeError(exchange, 400, "Thiếu tham số userId");
            return;
        }
        try {
            var found = guildService.myGuild(userId);
            if (found.isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Chưa ở trong guild nào");
                return;
            }
            JsonHttp.write(exchange, 200, found.get());
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
