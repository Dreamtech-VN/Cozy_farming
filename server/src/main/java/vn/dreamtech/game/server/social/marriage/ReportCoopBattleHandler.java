package vn.dreamtech.game.server.social.marriage;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.guild.GuildException;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/marriage/battle/report {userId, battleId} — sau khi trận kết thúc; nếu vợ/chồng cũng đã đánh trong khung thời gian cho phép thì cả 2 nhận thêm điểm thân mật. */
public final class ReportCoopBattleHandler implements HttpHandler {
    private final MarriageActivityService activityService;

    public ReportCoopBattleHandler(MarriageActivityService activityService) {
        this.activityService = activityService;
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
            JsonHttp.write(exchange, 200, activityService.reportCoopBattle(req.userId(), req.battleId()));
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
