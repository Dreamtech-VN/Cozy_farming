package vn.dreamtech.game.server.social.marriage;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.guild.GuildException;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/marriage/battle/start {userId} — bắt đầu bản sao cá nhân của trận hợp tác vợ chồng. */
public final class StartCoopBattleHandler implements HttpHandler {
    private final MarriageActivityService activityService;

    public StartCoopBattleHandler(MarriageActivityService activityService) {
        this.activityService = activityService;
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
            JsonHttp.write(exchange, 201, activityService.startCoopBattle(req.userId()));
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
