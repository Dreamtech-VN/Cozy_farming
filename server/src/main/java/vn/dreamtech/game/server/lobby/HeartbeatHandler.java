package vn.dreamtech.game.server.lobby;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.PresenceDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/lobby/heartbeat {userId, x, y} — client gọi định kỳ (khuyến
 * nghị mỗi 1-2 giây) khi đang ở sảnh để báo còn hoạt động + cập nhật vị trí.
 * Bắt buộc đã tạo nhân vật (404 nếu chưa) — sảnh chỉ hiện người có nhân vật.
 */
public final class HeartbeatHandler implements HttpHandler {
    private final CharacterDao characterDao;
    private final PresenceDao presenceDao;

    public HeartbeatHandler(CharacterDao characterDao, PresenceDao presenceDao) {
        this.characterDao = characterDao;
        this.presenceDao = presenceDao;
    }

    record Req(int userId, int x, int y) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            if (characterDao.findByUserId(req.userId()).isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Chưa tạo nhân vật");
                return;
            }
            presenceDao.heartbeat(req.userId(), req.x(), req.y(), System.currentTimeMillis());
            JsonHttp.write(exchange, 200, new Object());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi cập nhật sảnh: " + e.getMessage());
        }
    }
}
