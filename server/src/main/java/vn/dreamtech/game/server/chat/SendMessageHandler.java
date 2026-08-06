package vn.dreamtech.game.server.chat;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.ChatMessageDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/chat/send {userId, text} — gửi tin nhắn vào kênh chat sảnh
 * chung. Bắt buộc đã tạo nhân vật (404 nếu chưa, khớp yêu cầu của sảnh) —
 * tên hiện trong chat lấy từ tên nhân vật, không phải username tài khoản.
 */
public final class SendMessageHandler implements HttpHandler {
    private static final int MAX_LENGTH = 500;

    private final CharacterDao characterDao;
    private final ChatMessageDao chatMessageDao;

    public SendMessageHandler(CharacterDao characterDao, ChatMessageDao chatMessageDao) {
        this.characterDao = characterDao;
        this.chatMessageDao = chatMessageDao;
    }

    record Req(int userId, String text) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        String text = req.text() == null ? "" : req.text().strip();
        if (text.isEmpty() || text.length() > MAX_LENGTH) {
            JsonHttp.writeError(exchange, 400, "Nội dung tin nhắn không hợp lệ (tối đa " + MAX_LENGTH + " ký tự)");
            return;
        }
        try {
            var character = characterDao.findByUserId(req.userId());
            if (character.isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Chưa tạo nhân vật");
                return;
            }
            var message = chatMessageDao.send(req.userId(), character.get().name(), text, System.currentTimeMillis());
            JsonHttp.write(exchange, 201, message);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi gửi tin nhắn: " + e.getMessage());
        }
    }
}
