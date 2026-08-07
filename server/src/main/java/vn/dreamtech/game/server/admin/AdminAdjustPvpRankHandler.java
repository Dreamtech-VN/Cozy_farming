package vn.dreamtech.game.server.admin;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.PvpRankDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/admin/pvp/rank/adjust {userId, ratingDelta, resetStats} —
 * GM tool sửa rating (delta âm = trừ, kẹp về 0) và/hoặc reset wins/losses/draws
 * về 0, dùng cho trường hợp người chơi bị report gian lận/exploit PvP.
 * Cần header X-Admin-Token.
 */
public final class AdminAdjustPvpRankHandler implements HttpHandler {
    private final UserDao userDao;
    private final PvpRankDao pvpRankDao;

    public AdminAdjustPvpRankHandler(UserDao userDao, PvpRankDao pvpRankDao) {
        this.userDao = userDao;
        this.pvpRankDao = pvpRankDao;
    }

    public record Req(int userId, int ratingDelta, boolean resetStats) {
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
            var current = pvpRankDao.find(req.userId());
            int newRating = Math.max(0, current.rating() + req.ratingDelta());
            var updated = new PvpRankDao.Rank(
                    req.userId(),
                    newRating,
                    req.resetStats() ? 0 : current.wins(),
                    req.resetStats() ? 0 : current.losses(),
                    req.resetStats() ? 0 : current.draws()
            );
            pvpRankDao.save(updated);
            JsonHttp.write(exchange, 200, updated);
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi chỉnh rank PvP: " + e.getMessage());
        }
    }
}
