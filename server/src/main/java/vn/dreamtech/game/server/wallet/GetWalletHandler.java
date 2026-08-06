package vn.dreamtech.game.server.wallet;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;
import java.sql.SQLException;

/** GET /api/wallet?userId= — chưa từng lưu thì trả 0 vàng/0 kim cương. */
public final class GetWalletHandler implements HttpHandler {
    private final WalletDao walletDao;

    public GetWalletHandler(WalletDao walletDao) {
        this.walletDao = walletDao;
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
            JsonHttp.write(exchange, 200, walletDao.find(userId));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy ví: " + e.getMessage());
        }
    }
}
