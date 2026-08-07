package vn.dreamtech.game.server.admin;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;
import vn.dreamtech.game.server.model.LevelInfo;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/admin/level/set {userId, level, exp} — GM tool đặt thẳng
 * level/exp của 1 user (kẹp level về tối thiểu 1, exp về tối thiểu 0), dùng
 * để sửa tài khoản bị lỗi cộng exp hoặc report gian lận lên level bất
 * thường. Cần header X-Admin-Token.
 */
public final class AdminSetLevelHandler implements HttpHandler {
    private final UserDao userDao;
    private final LevelDao levelDao;

    public AdminSetLevelHandler(UserDao userDao, LevelDao levelDao) {
        this.userDao = userDao;
        this.levelDao = levelDao;
    }

    public record Req(int userId, int level, int exp) {
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
            userDao.findById(req.userId()).orElseThrow(() -> new ItemException(404, "Không tìm thấy user"));
            LevelInfo updated = new LevelInfo(req.userId(), Math.max(1, req.level()), Math.max(0, req.exp()));
            levelDao.save(updated);
            JsonHttp.write(exchange, 200, updated);
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi đặt level: " + e.getMessage());
        }
    }
}
