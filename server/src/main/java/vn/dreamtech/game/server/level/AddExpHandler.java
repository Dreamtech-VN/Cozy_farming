package vn.dreamtech.game.server.level;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/level/add-exp {userId, amount} — cộng exp, tự lên level nếu đủ.
 * ⚠️ CHƯA có hệ chiến đấu/nhiệm vụ thật để gọi endpoint này — đây là HOOK
 * sẵn cho các hệ đó gọi vào sau (thắng trận, hoàn thành nhiệm vụ...), tạm
 * thời chỉ test được bằng cách gọi thẳng API.
 */
public final class AddExpHandler implements HttpHandler {
    private final LevelDao levelDao;

    public AddExpHandler(LevelDao levelDao) {
        this.levelDao = levelDao;
    }

    record Req(int userId, int amount) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        if (req.amount() <= 0) {
            JsonHttp.writeError(exchange, 400, "amount phải lớn hơn 0");
            return;
        }
        try {
            var current = levelDao.find(req.userId());
            var updated = LevelService.addExp(current, req.amount());
            levelDao.save(updated);
            JsonHttp.write(exchange, 200, updated);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi cộng exp: " + e.getMessage());
        }
    }
}
