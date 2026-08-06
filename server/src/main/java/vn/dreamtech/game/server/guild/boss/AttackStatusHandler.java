package vn.dreamtech.game.server.guild.boss;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.guild.GuildException;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;

/** GET /api/guild/boss/attack-status?userId= — còn lượt đánh trùm guild trong chu kỳ này không. */
public final class AttackStatusHandler implements HttpHandler {
    private final GuildBossService guildBossService;

    public AttackStatusHandler(GuildBossService guildBossService) {
        this.guildBossService = guildBossService;
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
            JsonHttp.write(exchange, 200, guildBossService.attackStatus(userId));
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
