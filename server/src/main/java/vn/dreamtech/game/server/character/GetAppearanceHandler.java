package vn.dreamtech.game.server.character;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.CharacterAppearanceDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;
import java.sql.SQLException;

/** GET /api/character/appearance?userId= — các ô trang bị/tuỳ chỉnh hiện tại (mắt/avatar/khung/danh hiệu/biểu cảm/trang bị). */
public final class GetAppearanceHandler implements HttpHandler {
    private final CharacterAppearanceDao appearanceDao;

    public GetAppearanceHandler(CharacterAppearanceDao appearanceDao) {
        this.appearanceDao = appearanceDao;
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
            JsonHttp.write(exchange, 200, appearanceDao.find(userId));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy tuỳ chỉnh nhân vật: " + e.getMessage());
        }
    }
}
