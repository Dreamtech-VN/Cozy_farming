package vn.dreamtech.game.server.mail;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;

/** POST /api/mail/claim {userId, mailId} — nhận thưởng trong thư (chỉ nhận được 1 lần/thư). */
public final class MailClaimHandler implements HttpHandler {
    private final MailService mailService;

    public MailClaimHandler(MailService mailService) {
        this.mailService = mailService;
    }

    record Req(int userId, String mailId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            JsonHttp.write(exchange, 200, mailService.claim(req.userId(), req.mailId()));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
