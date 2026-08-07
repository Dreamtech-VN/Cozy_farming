package vn.dreamtech.game.server.admin;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.FriendshipDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/admin/friend/remove {userIdA, userIdB} — GM buộc huỷ kết bạn
 * giữa 2 user, dùng khi xử lý report quấy rối/lạm dụng hệ bạn bè. Cần
 * header X-Admin-Token.
 */
public final class AdminRemoveFriendshipHandler implements HttpHandler {
    private final UserDao userDao;
    private final FriendshipDao friendshipDao;

    public AdminRemoveFriendshipHandler(UserDao userDao, FriendshipDao friendshipDao) {
        this.userDao = userDao;
        this.friendshipDao = friendshipDao;
    }

    public record Req(int userIdA, int userIdB) {
    }

    public record Res(boolean removed) {
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
            userDao.findById(req.userIdA()).orElseThrow(() -> new ItemException(404, "Không tìm thấy user A"));
            userDao.findById(req.userIdB()).orElseThrow(() -> new ItemException(404, "Không tìm thấy user B"));
            boolean wasFriend = friendshipDao.areFriends(req.userIdA(), req.userIdB());
            if (!wasFriend) {
                throw new ItemException(404, "2 user này không phải bạn bè");
            }
            friendshipDao.remove(req.userIdA(), req.userIdB());
            JsonHttp.write(exchange, 200, new Res(true));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi huỷ kết bạn: " + e.getMessage());
        }
    }
}
