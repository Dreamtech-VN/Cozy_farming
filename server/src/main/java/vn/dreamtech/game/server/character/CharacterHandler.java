package vn.dreamtech.game.server.character;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;
import java.sql.SQLException;

/** GET /api/character?userId= — thông tin nhân vật, 404 nếu chưa tạo (client biết để đưa qua màn tạo nhân vật). */
public final class CharacterHandler implements HttpHandler {
    private final CharacterDao characterDao;

    public CharacterHandler(CharacterDao characterDao) {
        this.characterDao = characterDao;
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
            var found = characterDao.findByUserId(userId);
            if (found.isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Chưa tạo nhân vật");
                return;
            }
            JsonHttp.write(exchange, 200, found.get());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy thông tin nhân vật: " + e.getMessage());
        }
    }
}
