package vn.dreamtech.game.server.social.marriage;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.MarriageDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;
import java.sql.SQLException;

/** GET /api/marriage/status?userId= — {married, spouseUserId (null nếu độc thân)}. */
public final class MarriageStatusHandler implements HttpHandler {
    private final MarriageDao marriageDao;

    public MarriageStatusHandler(MarriageDao marriageDao) {
        this.marriageDao = marriageDao;
    }

    record Res(boolean married, Integer spouseUserId) {
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
            var spouse = marriageDao.findSpouse(userId);
            JsonHttp.write(exchange, 200, new Res(spouse.isPresent(), spouse.orElse(null)));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy trạng thái hôn nhân: " + e.getMessage());
        }
    }
}
