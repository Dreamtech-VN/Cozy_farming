package vn.dreamtech.game.server.lobby;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.PresenceDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

/** POST /api/lobby/leave {userId} — thoát sảnh chủ động (đóng app/đổi màn hình khác), gỡ khỏi danh sách ngay thay vì chờ hết hạn heartbeat. */
public final class LeaveLobbyHandler implements HttpHandler {
    private final PresenceDao presenceDao;

    public LeaveLobbyHandler(PresenceDao presenceDao) {
        this.presenceDao = presenceDao;
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
            presenceDao.remove(req.userId());
            JsonHttp.write(exchange, 200, new Object());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi thoát sảnh: " + e.getMessage());
        }
    }
}
