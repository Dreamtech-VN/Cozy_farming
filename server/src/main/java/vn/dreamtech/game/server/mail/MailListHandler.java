package vn.dreamtech.game.server.mail;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;

/** GET /api/mail/list?userId= — hộp thư (giftcode/sự kiện/admin gửi đều nằm ở đây). */
public final class MailListHandler implements HttpHandler {
    private final MailService mailService;

    public MailListHandler(MailService mailService) {
        this.mailService = mailService;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        Integer userId = QueryParam.intParam(exchange.getRequestURI().getQuery(), "userId");
        if (userId == null) {
            JsonHttp.writeError(exchange, 400, "Thiếu tham số userId");
            return;
        }
        try {
            JsonHttp.write(exchange, 200, mailService.list(userId));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        }
    }
}
