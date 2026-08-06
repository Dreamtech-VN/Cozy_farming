package vn.dreamtech.game.server.chat;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.ChatMessageDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;
import java.sql.SQLException;

/**
 * GET /api/chat/recent?sinceId=&limit= — poll tin nhắn mới. Client giữ
 * {@code id} tin nhắn cuối cùng đã thấy, gọi lại định kỳ với {@code sinceId}
 * đó để lấy tin mới (khớp cơ chế polling đã dùng cho sảnh) — dùng id tăng
 * dần thay vì mốc thời gian để tránh lệch giờ máy giữa client/server.
 * {@code sinceId} bỏ trống = 0 (lấy từ đầu, dùng lúc mới vào chat).
 */
public final class RecentMessagesHandler implements HttpHandler {
    private static final int DEFAULT_LIMIT = 50;
    private static final int MAX_LIMIT = 200;

    private final ChatMessageDao chatMessageDao;

    public RecentMessagesHandler(ChatMessageDao chatMessageDao) {
        this.chatMessageDao = chatMessageDao;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        String query = exchange.getRequestURI().getQuery();
        Integer sinceId = QueryParam.intParam(query, "sinceId");
        Integer limit = QueryParam.intParam(query, "limit");
        int cappedLimit = Math.min(MAX_LIMIT, limit == null || limit < 1 ? DEFAULT_LIMIT : limit);
        try {
            var messages = chatMessageDao.findSince(sinceId == null ? 0 : sinceId, cappedLimit);
            JsonHttp.write(exchange, 200, messages);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy tin nhắn: " + e.getMessage());
        }
    }
}
