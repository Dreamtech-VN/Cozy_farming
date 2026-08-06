package vn.dreamtech.game.server.social.marriage;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.DivorceCooldownDao;
import vn.dreamtech.game.server.dao.MarriageDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

import static vn.dreamtech.game.server.social.marriage.MarriageConstants.DIVORCE_COOLDOWN_MS;

/**
 * POST /api/marriage/divorce {userId} — ly hôn. Không cần vợ/chồng đồng ý
 * (đơn phương ly hôn được, giống nhiều game khác — tránh 1 người "giam" đối
 * phương mãi không cho ly hôn). Cả HAI người đều bị áp thời gian chờ
 * {@value MarriageConstants#DIVORCE_COOLDOWN_MS} ms trước khi cưới lại được
 * (với bất kỳ ai, không riêng người vừa ly hôn).
 */
public final class DivorceHandler implements HttpHandler {
    private final MarriageDao marriageDao;
    private final DivorceCooldownDao divorceCooldownDao;

    public DivorceHandler(MarriageDao marriageDao, DivorceCooldownDao divorceCooldownDao) {
        this.marriageDao = marriageDao;
        this.divorceCooldownDao = divorceCooldownDao;
    }

    record Req(int userId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            var spouse = marriageDao.findSpouse(req.userId());
            if (spouse.isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Chưa kết hôn, không ly hôn được");
                return;
            }
            marriageDao.deleteByUser(req.userId());
            long cooldownUntil = System.currentTimeMillis() + DIVORCE_COOLDOWN_MS;
            divorceCooldownDao.setCooldown(req.userId(), cooldownUntil);
            divorceCooldownDao.setCooldown(spouse.get(), cooldownUntil);
            JsonHttp.write(exchange, 200, new Object());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi ly hôn: " + e.getMessage());
        }
    }
}
