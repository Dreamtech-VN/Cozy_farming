package vn.dreamtech.game.server.social.marriage;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.MarriageDao;
import vn.dreamtech.game.server.dao.MarriageProposalDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/marriage/respond {proposalId, userId, accept} — {@code userId}
 * PHẢI là người ĐƯỢC cầu hôn (chặn tự chấp nhận lời cầu hôn của mình). Chấp
 * nhận = ĐÁM CƯỚI hoàn tất ngay (tạo hôn nhân + xoá lời cầu hôn) — phiên bản
 * này chưa có hệ sự kiện/lễ cưới riêng, "chấp nhận cầu hôn" chính là đám
 * cưới. Từ chối chỉ xoá lời cầu hôn, tiền nhẫn đã trừ không hoàn lại.
 */
public final class RespondProposalHandler implements HttpHandler {
    private final MarriageProposalDao proposalDao;
    private final MarriageDao marriageDao;

    public RespondProposalHandler(MarriageProposalDao proposalDao, MarriageDao marriageDao) {
        this.proposalDao = proposalDao;
        this.marriageDao = marriageDao;
    }

    record Req(long proposalId, int userId, boolean accept) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            var found = proposalDao.find(req.proposalId());
            if (found.isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Không tìm thấy lời cầu hôn");
                return;
            }
            if (found.get().toUserId() != req.userId()) {
                JsonHttp.writeError(exchange, 403, "Không phải lời cầu hôn gửi cho bạn");
                return;
            }
            if (req.accept()) {
                var marriage = marriageDao.create(found.get().fromUserId(), found.get().toUserId(), System.currentTimeMillis());
                proposalDao.delete(req.proposalId());
                JsonHttp.write(exchange, 200, marriage);
                return;
            }
            proposalDao.delete(req.proposalId());
            JsonHttp.write(exchange, 200, new Object());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi phản hồi lời cầu hôn: " + e.getMessage());
        }
    }
}
