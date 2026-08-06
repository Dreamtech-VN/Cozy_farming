package vn.dreamtech.game.server.social.friend;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.FriendshipDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;
import java.sql.SQLException;

/** GET /api/friends?userId= — danh sách bạn bè kèm tên nhân vật + điểm thân mật hiện tại. */
public final class FriendsListHandler implements HttpHandler {
    private final FriendshipDao friendshipDao;
    private final CharacterDao characterDao;

    public FriendsListHandler(FriendshipDao friendshipDao, CharacterDao characterDao) {
        this.friendshipDao = friendshipDao;
        this.characterDao = characterDao;
    }

    record FriendView(int userId, String name, int intimacyPoints) {
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
            var friendIds = friendshipDao.listFriendIds(userId);
            var views = friendIds.stream().map(friendId -> {
                try {
                    int points = friendshipDao.find(userId, friendId).map(f -> f.intimacyPoints()).orElse(0);
                    String name = characterDao.findByUserId(friendId).map(ch -> ch.name()).orElse(null);
                    return name == null ? null : new FriendView(friendId, name, points);
                } catch (SQLException e) {
                    return null;
                }
            }).filter(v -> v != null).toList();
            JsonHttp.write(exchange, 200, views);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy danh sách bạn bè: " + e.getMessage());
        }
    }
}
