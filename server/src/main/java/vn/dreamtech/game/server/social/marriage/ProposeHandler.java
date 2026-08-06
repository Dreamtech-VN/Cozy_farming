package vn.dreamtech.game.server.social.marriage;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.FriendshipDao;
import vn.dreamtech.game.server.dao.MarriageDao;
import vn.dreamtech.game.server.dao.MarriageProposalDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

import static vn.dreamtech.game.server.social.marriage.MarriageConstants.PROPOSAL_THRESHOLD;
import static vn.dreamtech.game.server.social.marriage.MarriageConstants.RING_COST;

/**
 * POST /api/marriage/propose {fromUserId, toUserId} — cầu hôn: phải đang là
 * bạn bè (404), đủ điểm thân mật ({@value MarriageConstants#PROPOSAL_THRESHOLD},
 * 409 nếu thiếu), cả hai chưa ai kết hôn (409). "Mua nhẫn" bằng cách TRỪ
 * {@value MarriageConstants#RING_COST} điểm thân mật chung của cặp NGAY khi
 * gửi lời cầu hôn — dù bị từ chối cũng KHÔNG hoàn lại (giống mua nhẫn thật
 * ngoài đời, tăng thêm sự cân nhắc trước khi cầu hôn).
 */
public final class ProposeHandler implements HttpHandler {
    private final FriendshipDao friendshipDao;
    private final MarriageDao marriageDao;
    private final MarriageProposalDao proposalDao;

    public ProposeHandler(FriendshipDao friendshipDao, MarriageDao marriageDao, MarriageProposalDao proposalDao) {
        this.friendshipDao = friendshipDao;
        this.marriageDao = marriageDao;
        this.proposalDao = proposalDao;
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
            JsonHttp.writeError(exchange, 400, "Không thể tự cầu hôn chính mình");
            return;
        }
        try {
            var friendship = friendshipDao.find(req.fromUserId(), req.toUserId());
            if (friendship.isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Chưa kết bạn, không cầu hôn được");
                return;
            }
            if (marriageDao.isMarried(req.fromUserId()) || marriageDao.isMarried(req.toUserId())) {
                JsonHttp.writeError(exchange, 409, "Một trong hai người đã kết hôn rồi");
                return;
            }
            if (proposalDao.exists(req.fromUserId(), req.toUserId())) {
                JsonHttp.writeError(exchange, 409, "Đã gửi lời cầu hôn trước đó, đang chờ phản hồi");
                return;
            }
            if (friendship.get().intimacyPoints() < PROPOSAL_THRESHOLD) {
                JsonHttp.writeError(exchange, 409, "Chưa đủ điểm thân mật để cầu hôn (cần " + PROPOSAL_THRESHOLD + ")");
                return;
            }
            friendshipDao.spendIntimacy(req.fromUserId(), req.toUserId(), RING_COST);
            var proposal = proposalDao.create(req.fromUserId(), req.toUserId(), System.currentTimeMillis());
            JsonHttp.write(exchange, 201, proposal);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi cầu hôn: " + e.getMessage());
        }
    }
}
