package vn.dreamtech.game.server.admin;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.DivorceCooldownDao;
import vn.dreamtech.game.server.dao.MarriageDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.item.ItemException;

import java.io.IOException;
import java.sql.SQLException;

import static vn.dreamtech.game.server.social.marriage.MarriageConstants.DIVORCE_COOLDOWN_MS;

/**
 * POST /api/admin/marriage/annul {userId} — GM buộc huỷ hôn nhân của
 * {@code userId} (VD: hôn nhân gian lận/exploit tiền nhẫn), không cần
 * người kia đồng ý — khác {@code DivorceHandler} chỉ ở chỗ không yêu cầu
 * chính chủ gọi. Vẫn áp cooldown tái hôn cho cả hai như ly hôn thường.
 * Cần header X-Admin-Token.
 */
public final class AdminAnnulMarriageHandler implements HttpHandler {
    private final MarriageDao marriageDao;
    private final DivorceCooldownDao divorceCooldownDao;

    public AdminAnnulMarriageHandler(MarriageDao marriageDao, DivorceCooldownDao divorceCooldownDao) {
        this.marriageDao = marriageDao;
        this.divorceCooldownDao = divorceCooldownDao;
    }

    public record Req(int userId) {
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
            var spouse = marriageDao.findSpouse(req.userId())
                    .orElseThrow(() -> new ItemException(404, "Người này chưa kết hôn"));
            marriageDao.deleteByUser(req.userId());
            long cooldownUntil = System.currentTimeMillis() + DIVORCE_COOLDOWN_MS;
            divorceCooldownDao.setCooldown(req.userId(), cooldownUntil);
            divorceCooldownDao.setCooldown(spouse, cooldownUntil);
            JsonHttp.write(exchange, 200, new Object());
        } catch (ItemException e) {
            JsonHttp.writeError(exchange, e.status(), e.getMessage());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi huỷ hôn nhân: " + e.getMessage());
        }
    }
}
