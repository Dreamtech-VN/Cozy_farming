package vn.dreamtech.game.server.social.marriage;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.guild.GuildException;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/marriage/duo-quest/claim {userId} — nhiệm vụ đôi hàng ngày, cần cả 2 đang online. */
public final class ClaimDuoQuestHandler implements HttpHandler {
    private final MarriageActivityService activityService;

    public ClaimDuoQuestHandler(MarriageActivityService activityService) {
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
            JsonHttp.write(exchange, 200, activityService.claimDuoQuest(req.userId()));
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
