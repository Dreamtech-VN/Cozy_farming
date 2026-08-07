package vn.dreamtech.game.server.character;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.admin.AdminAuth;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;
import java.sql.SQLException;

/** POST /api/admin/character/rename {userId, newName} — đổi tên nhân vật vi phạm (chưa có cách nào tự đổi tên). Cần header X-Admin-Token. */
public final class AdminRenameCharacterHandler implements HttpHandler {
    private final CharacterDao characterDao;

    public AdminRenameCharacterHandler(CharacterDao characterDao) {
        this.characterDao = characterDao;
    }

    record Req(int userId, String newName) {
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
            String name = req.newName() == null ? "" : req.newName().strip();
            if (name.length() < 2 || name.length() > 20) {
                throw new ItemException(400, "Tên phải từ 2-20 ký tự");
            }
            var current = characterDao.findByUserId(req.userId())
                    .orElseThrow(() -> new ItemException(404, "Người này chưa tạo nhân vật"));
            if (!name.equals(current.name()) && characterDao.nameTaken(name)) {
                throw new ItemException(409, "Tên đã có người dùng");
            }
            characterDao.rename(req.userId(), name);
            JsonHttp.write(exchange, 200, characterDao.findByUserId(req.userId()).orElseThrow());
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi đổi tên: " + e.getMessage());
        }
    }
}
