package vn.dreamtech.game.server.guild;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/guild/leave {userId} — hội trưởng phải chuyển quyền trước nếu còn thành viên khác. */
public final class LeaveGuildHandler implements HttpHandler {
    private final GuildService guildService;

    public LeaveGuildHandler(GuildService guildService) {
        this.guildService = guildService;
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
            guildService.leave(req.userId());
            JsonHttp.write(exchange, 200, new Object());
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
