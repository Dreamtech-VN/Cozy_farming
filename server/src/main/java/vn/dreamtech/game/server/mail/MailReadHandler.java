package vn.dreamtech.game.server.mail;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;

/** POST /api/mail/read {userId, mailId} — đánh dấu đã đọc (không nhận thưởng). */
public final class MailReadHandler implements HttpHandler {
    private final MailService mailService;

    public MailReadHandler(MailService mailService) {
        this.mailService = mailService;
    }

    record Req(int userId, String mailId) {
    }

    record Res(boolean read) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            mailService.markRead(req.userId(), req.mailId());
            JsonHttp.write(exchange, 200, new Res(true));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
