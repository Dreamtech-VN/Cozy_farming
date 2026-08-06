package vn.dreamtech.game.server.social.friend;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.FriendRequestDao;
import vn.dreamtech.game.server.dao.FriendshipDao;
import vn.dreamtech.game.server.dao.UserSettingsDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/friends/request {fromUserId, toUserId} — gửi lời mời kết bạn.
 * Tôn trọng cài đặt "Privacy & Social" của người NHẬN (giai đoạn 6,
 * {@code friendRequestPrivacy}) — NOBODY thì chặn thẳng (403), không cho
 * gửi được.
 */
public final class SendFriendRequestHandler implements HttpHandler {
    private final FriendRequestDao friendRequestDao;
    private final FriendshipDao friendshipDao;
    private final UserSettingsDao settingsDao;

    public SendFriendRequestHandler(FriendRequestDao friendRequestDao, FriendshipDao friendshipDao, UserSettingsDao settingsDao) {
        this.friendRequestDao = friendRequestDao;
        this.friendshipDao = friendshipDao;
        this.settingsDao = settingsDao;
    }

    record Req(int fromUserId, int toUserId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        if (req.fromUserId() == req.toUserId()) {
            JsonHttp.writeError(exchange, 400, "Không thể tự kết bạn với chính mình");
            return;
        }
        try {
            if ("NOBODY".equals(settingsDao.find(req.toUserId()).friendRequestPrivacy())) {
                JsonHttp.writeError(exchange, 403, "Người này không nhận lời mời kết bạn");
                return;
            }
            if (friendshipDao.areFriends(req.fromUserId(), req.toUserId())) {
                JsonHttp.writeError(exchange, 409, "Đã là bạn bè");
                return;
            }
            if (friendRequestDao.exists(req.fromUserId(), req.toUserId())) {
                JsonHttp.writeError(exchange, 409, "Đã gửi lời mời trước đó, đang chờ phản hồi");
                return;
            }
            var request = friendRequestDao.create(req.fromUserId(), req.toUserId(), System.currentTimeMillis());
            JsonHttp.write(exchange, 201, request);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi gửi lời mời kết bạn: " + e.getMessage());
        }
    }
}
