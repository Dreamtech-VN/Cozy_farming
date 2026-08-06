package vn.dreamtech.game.server.social.friend;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.FriendRequestDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;

import java.io.IOException;
import java.sql.SQLException;

/** GET /api/friends/requests?userId= — lời mời kết bạn ĐANG CHỜ userId phản hồi (người khác gửi tới). */
public final class PendingRequestsHandler implements HttpHandler {
    private final FriendRequestDao friendRequestDao;

    public PendingRequestsHandler(FriendRequestDao friendRequestDao) {
        this.friendRequestDao = friendRequestDao;
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
            JsonHttp.write(exchange, 200, friendRequestDao.findIncoming(userId));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy danh sách lời mời: " + e.getMessage());
        }
    }
}
