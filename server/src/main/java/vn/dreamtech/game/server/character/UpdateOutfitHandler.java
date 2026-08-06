package vn.dreamtech.game.server.character;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

/** POST /api/character/outfit {userId, hairId, topId, bottomId} — đổi trang phục sau khi đã tạo nhân vật. */
public final class UpdateOutfitHandler implements HttpHandler {
    private final CharacterDao characterDao;

    public UpdateOutfitHandler(CharacterDao characterDao) {
        this.characterDao = characterDao;
    }

    record Req(int userId, int hairId, int topId, int bottomId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            if (characterDao.findByUserId(req.userId()).isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Chưa tạo nhân vật");
                return;
            }
            characterDao.updateOutfit(req.userId(), req.hairId(), req.topId(), req.bottomId());
            JsonHttp.write(exchange, 200, characterDao.findByUserId(req.userId()).orElseThrow());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi đổi trang phục: " + e.getMessage());
        }
    }
}
