package vn.dreamtech.game.server.admin;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.BannedUserDao;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.http.QueryParam;
import vn.dreamtech.game.server.item.ItemException;
import vn.dreamtech.game.server.model.Character;
import vn.dreamtech.game.server.model.LevelInfo;
import vn.dreamtech.game.server.model.User;
import vn.dreamtech.game.server.model.Wallet;

import java.io.IOException;
import java.sql.SQLException;

/** GET /api/admin/users/lookup?userId= — tổng hợp thông tin 1 user để hỗ trợ/kiểm duyệt. Cần header X-Admin-Token. */
public final class AdminLookupUserHandler implements HttpHandler {
    private final UserDao userDao;
    private final CharacterDao characterDao;
    private final WalletDao walletDao;
    private final LevelDao levelDao;
    private final BannedUserDao bannedUserDao;

    public AdminLookupUserHandler(UserDao userDao, CharacterDao characterDao, WalletDao walletDao, LevelDao levelDao,
                                   BannedUserDao bannedUserDao) {
        this.userDao = userDao;
        this.characterDao = characterDao;
        this.walletDao = walletDao;
        this.levelDao = levelDao;
        this.bannedUserDao = bannedUserDao;
    }

    record Res(User user, Character character, Wallet wallet, LevelInfo level, boolean banned, String banReason) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        try {
            AdminAuth.requireAdmin(exchange);
            Integer userId = QueryParam.intParam(exchange.getRequestURI().getQuery(), "userId");
            if (userId == null) {
                JsonHttp.writeError(exchange, 400, "Thiếu tham số userId");
                return;
            }
            User user = userDao.findById(userId).orElseThrow(() -> new ItemException(404, "Không tìm thấy user"));
            Character character = characterDao.findByUserId(userId).orElse(null);
            Wallet wallet = walletDao.find(userId);
            LevelInfo level = levelDao.find(userId);
            var ban = bannedUserDao.find(userId);
            JsonHttp.write(exchange, 200, new Res(user, character, wallet, level, ban.isPresent(),
                    ban.map(BannedUserDao.Ban::reason).orElse(null)));
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi tra cứu user: " + e.getMessage());
        }
    }
}
