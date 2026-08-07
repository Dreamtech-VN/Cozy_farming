package vn.dreamtech.game.server.chat;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.dao.ChatMessageDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;
import java.sql.SQLException;

/** POST /api/admin/chat/delete {messageId} — xoá 1 tin nhắn vi phạm khỏi chat sảnh. Cần header X-Admin-Token. */
public final class AdminDeleteMessageHandler implements HttpHandler {
    private final ChatMessageDao chatMessageDao;

    public AdminDeleteMessageHandler(ChatMessageDao chatMessageDao) {
        this.chatMessageDao = chatMessageDao;
    }

    record Req(long messageId) {
    }

    record Res(boolean deleted) {
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
            boolean found = chatMessageDao.delete(req.messageId());
            if (!found) {
                throw new ItemException(404, "Không tìm thấy tin nhắn");
            }
            JsonHttp.write(exchange, 200, new Res(true));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi xoá tin nhắn: " + e.getMessage());
        }
    }
}
