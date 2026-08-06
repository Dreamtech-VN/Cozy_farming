package vn.dreamtech.game.server.settings;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.UserSettingsDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;
import java.sql.SQLException;

/** GET /api/settings?userId= — chưa từng lưu thì trả về giá trị mặc định (chưa tạo dòng trong DB). */
public final class GetSettingsHandler implements HttpHandler {
    private final UserSettingsDao settingsDao;

    public GetSettingsHandler(UserSettingsDao settingsDao) {
        this.settingsDao = settingsDao;
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
            JsonHttp.write(exchange, 200, settingsDao.find(userId));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy cài đặt: " + e.getMessage());
        }
    }
}
