package vn.dreamtech.game.server.admin;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.TowerRecordDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/admin/tower/record/reset {userId, towerId} — GM reset kỷ lục
 * (best_floor) của 1 user trong 1 tháp về 0, dùng khi phát hiện gian lận
 * leo tháp làm sai lệch bảng xếp hạng. Cần header X-Admin-Token.
 */
public final class AdminResetTowerRecordHandler implements HttpHandler {
    private final UserDao userDao;
    private final TowerRecordDao towerRecordDao;

    public AdminResetTowerRecordHandler(UserDao userDao, TowerRecordDao towerRecordDao) {
        this.userDao = userDao;
        this.towerRecordDao = towerRecordDao;
    }

    public record Req(int userId, int towerId) {
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
            towerRecordDao.resetRecord(req.userId(), req.towerId());
            JsonHttp.write(exchange, 200, new TowerRecordDao.Record(req.userId(), req.towerId(), 0));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi reset kỷ lục tháp: " + e.getMessage());
        }
    }
}
