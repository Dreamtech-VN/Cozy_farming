package vn.dreamtech.game.server.guild;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;

/** POST /api/guild/transfer-leader {actorUserId, targetUserId} — hội trưởng cũ tự động xuống OFFICER. */
public final class TransferLeaderHandler implements HttpHandler {
    private final GuildService guildService;

    public TransferLeaderHandler(GuildService guildService) {
        this.guildService = guildService;
    }

    record Req(int actorUserId, int targetUserId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            guildService.transferLeader(req.actorUserId(), req.targetUserId());
            JsonHttp.write(exchange, 200, new Object());
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
