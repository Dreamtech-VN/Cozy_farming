package vn.dreamtech.cozyfarming.server.inventory;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.BagDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.http.QueryParam;

import java.io.IOException;
import java.sql.SQLException;

/** GET /api/inventory/bag?userId= — túi đồ (đồ dùng/quà/nguyên liệu, khớp {@code S.inventory} client). */
public final class BagHandler implements HttpHandler {
    private final BagDao bagDao;

    public BagHandler(BagDao bagDao) {
        this.bagDao = bagDao;
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
            JsonHttp.write(exchange, 200, bagDao.listAll(userId));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy túi đồ: " + e.getMessage());
        }
    }
}
