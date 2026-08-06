package vn.dreamtech.game.server.lobby;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.PresenceDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.model.Presence;

import java.io.IOException;
import java.sql.SQLException;

/**
 * GET /api/lobby/players — danh sách người chơi ĐANG hoạt động trong sảnh
 * (heartbeat trong {@value PresenceDao#ONLINE_WINDOW_MS} ms gần nhất), kèm
 * thông tin nhân vật để client vẽ được (tên/giới tính/trang phục) + vị trí
 * hiện tại.
 */
public final class LobbyPlayersHandler implements HttpHandler {
    private final PresenceDao presenceDao;
    private final CharacterDao characterDao;

    public LobbyPlayersHandler(PresenceDao presenceDao, CharacterDao characterDao) {
        this.presenceDao = presenceDao;
        this.characterDao = characterDao;
    }

    record PlayerView(int userId, String name, int gender, int hairId, int topId, int bottomId, int x, int y) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        try {
            var active = presenceDao.listActive(System.currentTimeMillis(), PresenceDao.ONLINE_WINDOW_MS);
            var views = active.stream()
                    .map(this::toView)
                    .filter(v -> v != null)
                    .toList();
            JsonHttp.write(exchange, 200, views);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy danh sách sảnh: " + e.getMessage());
        }
    }

    private PlayerView toView(Presence p) {
        try {
            return characterDao.findByUserId(p.userId())
                    .map(ch -> new PlayerView(ch.userId(), ch.name(), ch.gender(), ch.hairId(), ch.topId(), ch.bottomId(), p.x(), p.y()))
                    .orElse(null);
        } catch (SQLException e) {
            return null;
        }
    }
}
