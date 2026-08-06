package vn.dreamtech.game.server.social.friend;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.FriendRequestDao;
import vn.dreamtech.game.server.dao.FriendshipDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/friends/respond {requestId, userId, accept} — {@code userId}
 * PHẢI là người NHẬN lời mời (chặn người gửi tự duyệt lời mời của mình,
 * hoặc người thứ 3 không liên quan duyệt hộ). Chấp nhận thì tạo tình bạn +
 * xoá lời mời; từ chối chỉ xoá lời mời.
 */
public final class RespondFriendRequestHandler implements HttpHandler {
    private final FriendRequestDao friendRequestDao;
    private final FriendshipDao friendshipDao;

    public RespondFriendRequestHandler(FriendRequestDao friendRequestDao, FriendshipDao friendshipDao) {
        this.friendRequestDao = friendRequestDao;
        this.friendshipDao = friendshipDao;
    }

    record Req(long requestId, int userId, boolean accept) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            var found = friendRequestDao.find(req.requestId());
            if (found.isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Không tìm thấy lời mời");
                return;
            }
            if (found.get().toUserId() != req.userId()) {
                JsonHttp.writeError(exchange, 403, "Không phải lời mời gửi cho bạn");
                return;
            }
            if (req.accept()) {
                friendshipDao.create(found.get().fromUserId(), found.get().toUserId(), System.currentTimeMillis());
            }
            friendRequestDao.delete(req.requestId());
            JsonHttp.write(exchange, 200, new Object());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi phản hồi lời mời: " + e.getMessage());
        }
    }
}
