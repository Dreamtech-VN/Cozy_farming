package vn.dreamtech.game.server.settings;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.UserSettingsDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.model.UserSettings;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Set;

/**
 * POST /api/settings/update {userId, pushNotifications?, friendRequestPrivacy?,
 * messagePrivacy?, language?} — CẬP NHẬT MỘT PHẦN: field nào null (không
 * gửi) thì giữ nguyên giá trị cũ, chỉ field có gửi mới đổi.
 */
public final class UpdateSettingsHandler implements HttpHandler {
    private static final Set<String> VALID_PRIVACY = Set.of("EVERYONE", "NOBODY");

    private final UserSettingsDao settingsDao;

    public UpdateSettingsHandler(UserSettingsDao settingsDao) {
        this.settingsDao = settingsDao;
    }

    record Req(int userId, Boolean pushNotifications, String friendRequestPrivacy, String messagePrivacy, String language) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        if (req.friendRequestPrivacy() != null && !VALID_PRIVACY.contains(req.friendRequestPrivacy())
                || req.messagePrivacy() != null && !VALID_PRIVACY.contains(req.messagePrivacy())) {
            JsonHttp.writeError(exchange, 400, "Giá trị riêng tư không hợp lệ (chỉ nhận EVERYONE/NOBODY)");
            return;
        }
        try {
            UserSettings current = settingsDao.find(req.userId());
            UserSettings updated = new UserSettings(
                    req.userId(),
                    req.pushNotifications() != null ? req.pushNotifications() : current.pushNotifications(),
                    req.friendRequestPrivacy() != null ? req.friendRequestPrivacy() : current.friendRequestPrivacy(),
                    req.messagePrivacy() != null ? req.messagePrivacy() : current.messagePrivacy(),
                    req.language() != null ? req.language() : current.language()
            );
            settingsDao.save(updated);
            JsonHttp.write(exchange, 200, updated);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi cập nhật cài đặt: " + e.getMessage());
        }
    }
}
