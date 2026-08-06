package vn.dreamtech.game.server.guild.boss;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.guild.GuildException;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;

/** GET /api/guild/boss/status?guildId= — HP còn lại của trùm guild trong chu kỳ hiện tại. */
public final class BossStatusHandler implements HttpHandler {
    private final GuildBossService guildBossService;

    public BossStatusHandler(GuildBossService guildBossService) {
        this.guildBossService = guildBossService;
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
            JsonHttp.write(exchange, 200, guildBossService.status(guildId));
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
