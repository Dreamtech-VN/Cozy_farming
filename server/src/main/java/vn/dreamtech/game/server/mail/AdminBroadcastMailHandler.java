package vn.dreamtech.game.server.mail;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;
import vn.dreamtech.game.server.item.RewardEntry;
import vn.dreamtech.game.server.item.RewardGrantService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/** POST /api/admin/mail/broadcast {title, body, rewards, expiresAt} — gửi thư cho TOÀN SERVER. Cần header X-Admin-Token. */
public final class AdminBroadcastMailHandler implements HttpHandler {
    private final MailService mailService;
    private final RewardGrantService rewardGrantService;

    public AdminBroadcastMailHandler(MailService mailService, RewardGrantService rewardGrantService) {
        this.mailService = mailService;
        this.rewardGrantService = rewardGrantService;
    }

    record Req(String title, String body, List<RewardEntry> rewards, Long expiresAt) {
    }

    record Res(boolean sent) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        try {
            AdminAuth.requireAdmin(exchange);
            Req req = JsonHttp.readBody(exchange, Req.class);
            if (req.title() == null || req.title().isBlank()) {
                JsonHttp.writeError(exchange, 400, "Thiếu title");
                return;
            }
            rewardGrantService.validateRewards(req.rewards());
            mailService.broadcast(req.title(), req.body(), req.rewards(), req.expiresAt());
            JsonHttp.write(exchange, 201, new Res(true));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi gửi thư quảng bá: " + e.getMessage());
        }
    }
}
