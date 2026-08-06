package vn.dreamtech.game.server.character;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.model.Character;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/character/create {userId, name, gender, hairId, topId, bottomId}
 * — tạo nhân vật cho user. 1 user chỉ tạo được 1 lần (409 nếu đã có), tên
 * phải duy nhất toàn server (409 nếu trùng), 2-20 ký tự.
 */
public final class CreateCharacterHandler implements HttpHandler {
    private final UserDao userDao;
    private final CharacterDao characterDao;

    public CreateCharacterHandler(UserDao userDao, CharacterDao characterDao) {
        this.userDao = userDao;
        this.characterDao = characterDao;
    }

    record Req(int userId, String name, int gender, int hairId, int topId, int bottomId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        String name = req.name() == null ? "" : req.name().trim();
        if (name.length() < 2 || name.length() > 20) {
            JsonHttp.writeError(exchange, 400, "Tên nhân vật phải từ 2-20 ký tự");
            return;
        }
        if (req.gender() != 0 && req.gender() != 1) {
            JsonHttp.writeError(exchange, 400, "Giới tính không hợp lệ");
            return;
        }
        try {
            if (userDao.findById(req.userId()).isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Không tìm thấy tài khoản");
                return;
            }
            if (characterDao.findByUserId(req.userId()).isPresent()) {
                JsonHttp.writeError(exchange, 409, "Tài khoản này đã có nhân vật rồi");
                return;
            }
            if (characterDao.nameTaken(name)) {
                JsonHttp.writeError(exchange, 409, "Tên nhân vật đã có người dùng");
                return;
            }
            Character ch = new Character(req.userId(), name, req.gender(), req.hairId(), req.topId(), req.bottomId());
            characterDao.create(ch);
            JsonHttp.write(exchange, 201, ch);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi tạo nhân vật: " + e.getMessage());
        }
    }
}
