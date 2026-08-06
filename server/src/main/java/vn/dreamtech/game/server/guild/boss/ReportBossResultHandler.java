package vn.dreamtech.game.server.guild.boss;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.guild.GuildException;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/guild/boss/report {userId, battleId} — sau khi trận (WON/LOST) kết thúc, đồng bộ sát thương vào HP chung của guild + phát thưởng. */
public final class ReportBossResultHandler implements HttpHandler {
    private final GuildBossService guildBossService;

    public ReportBossResultHandler(GuildBossService guildBossService) {
        this.guildBossService = guildBossService;
    }

    record Req(int userId, String battleId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            JsonHttp.write(exchange, 200, guildBossService.report(req.userId(), req.battleId()));
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
