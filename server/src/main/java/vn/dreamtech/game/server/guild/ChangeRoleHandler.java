package vn.dreamtech.game.server.guild;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.model.GuildRole;

import java.io.IOException;

/** POST /api/guild/role {actorUserId, targetUserId, role} ("OFFICER"/"MEMBER") — chỉ hội trưởng đổi được, dùng transfer-leader để đặt LEADER. */
public final class ChangeRoleHandler implements HttpHandler {
    private final GuildService guildService;

    public ChangeRoleHandler(GuildService guildService) {
        this.guildService = guildService;
    }

    record Req(int actorUserId, int targetUserId, String role) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        GuildRole role;
        try {
            role = GuildRole.valueOf(req.role() == null ? "" : req.role().toUpperCase());
        } catch (IllegalArgumentException e) {
            JsonHttp.writeError(exchange, 400, "Cấp bậc không hợp lệ (OFFICER/MEMBER)");
            return;
        }
        try {
            guildService.changeRole(req.actorUserId(), req.targetUserId(), role);
            JsonHttp.write(exchange, 200, new Object());
        } catch (GuildException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
