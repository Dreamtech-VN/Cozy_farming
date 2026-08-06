package vn.dreamtech.game.server.social.friend;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.FriendshipDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

/** POST /api/friends/remove {userId, friendUserId} — huỷ kết bạn, mất luôn điểm thân mật đã tích (không giữ lại nếu kết bạn lại). */
public final class RemoveFriendHandler implements HttpHandler {
    private final FriendshipDao friendshipDao;

    public RemoveFriendHandler(FriendshipDao friendshipDao) {
        this.friendshipDao = friendshipDao;
    }

    record Req(int userId, int friendUserId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            if (!friendshipDao.areFriends(req.userId(), req.friendUserId())) {
                JsonHttp.writeError(exchange, 404, "Không phải bạn bè");
                return;
            }
            friendshipDao.remove(req.userId(), req.friendUserId());
            JsonHttp.write(exchange, 200, new Object());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi huỷ kết bạn: " + e.getMessage());
        }
    }
}
