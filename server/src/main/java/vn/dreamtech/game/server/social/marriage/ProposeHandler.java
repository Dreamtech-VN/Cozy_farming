package vn.dreamtech.game.server.social.marriage;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.DivorceCooldownDao;
import vn.dreamtech.game.server.dao.FriendshipDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.MarriageDao;
import vn.dreamtech.game.server.dao.MarriageProposalDao;
import vn.dreamtech.game.server.dao.PresenceDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.http.JsonHttp;

import java.io.IOException;
import java.sql.SQLException;

import static vn.dreamtech.game.server.social.marriage.MarriageConstants.MIN_FRIENDSHIP_DURATION_MS;
import static vn.dreamtech.game.server.social.marriage.MarriageConstants.MIN_LEVEL;
import static vn.dreamtech.game.server.social.marriage.MarriageConstants.PROPOSAL_THRESHOLD;
import static vn.dreamtech.game.server.social.marriage.MarriageConstants.RING_COST_DIAMOND;
import static vn.dreamtech.game.server.social.marriage.MarriageConstants.RING_COST_GOLD;

/**
 * POST /api/marriage/propose {fromUserId, toUserId, currency} — cầu hôn,
 * kiểm tra ĐỦ điều kiện theo đúng thứ tự (dừng ở điều kiện đầu tiên không
 * đạt, không kiểm tra tiếp): bạn bè, đủ {@value MarriageConstants#MIN_LEVEL}
 * level cả hai, kết bạn đủ {@value MarriageConstants#MIN_FRIENDSHIP_DURATION_MS}
 * ms, đủ {@value MarriageConstants#PROPOSAL_THRESHOLD} điểm thân mật, cả hai
 * đang online, chưa ai kết hôn, không ai đang trong thời gian chờ sau ly
 * hôn. {@code currency} là "gold" hoặc "diamond" — "mua nhẫn" trừ THẬT vào
 * ví người cầu hôn ({@value MarriageConstants#RING_COST_GOLD} vàng hoặc
 * {@value MarriageConstants#RING_COST_DIAMOND} kim cương), KHÔNG hoàn lại
 * nếu bị từ chối.
 */
public final class ProposeHandler implements HttpHandler {
    private final FriendshipDao friendshipDao;
    private final MarriageDao marriageDao;
    private final MarriageProposalDao proposalDao;
    private final LevelDao levelDao;
    private final PresenceDao presenceDao;
    private final WalletDao walletDao;
    private final DivorceCooldownDao divorceCooldownDao;

    public ProposeHandler(FriendshipDao friendshipDao, MarriageDao marriageDao, MarriageProposalDao proposalDao,
                           LevelDao levelDao, PresenceDao presenceDao, WalletDao walletDao, DivorceCooldownDao divorceCooldownDao) {
        this.friendshipDao = friendshipDao;
        this.marriageDao = marriageDao;
        this.proposalDao = proposalDao;
        this.levelDao = levelDao;
        this.presenceDao = presenceDao;
        this.walletDao = walletDao;
        this.divorceCooldownDao = divorceCooldownDao;
    }

    record Req(int fromUserId, int toUserId, String currency) {
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
        boolean useGold = "gold".equals(req.currency());
        boolean useDiamond = "diamond".equals(req.currency());
        if (!useGold && !useDiamond) {
            JsonHttp.writeError(exchange, 400, "currency phải là \"gold\" hoặc \"diamond\"");
            return;
        }
        try {
            var friendship = friendshipDao.find(req.fromUserId(), req.toUserId());
            if (friendship.isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Chưa kết bạn, không cầu hôn được");
                return;
            }
            if (levelDao.find(req.fromUserId()).level() < MIN_LEVEL || levelDao.find(req.toUserId()).level() < MIN_LEVEL) {
                JsonHttp.writeError(exchange, 409, "Cả hai phải đạt level " + MIN_LEVEL + " trở lên");
                return;
            }
            long now = System.currentTimeMillis();
            if (now - friendship.get().createdAt() < MIN_FRIENDSHIP_DURATION_MS) {
                JsonHttp.writeError(exchange, 409, "Phải làm bạn đủ lâu hơn mới cầu hôn được");
                return;
            }
            if (friendship.get().intimacyPoints() < PROPOSAL_THRESHOLD) {
                JsonHttp.writeError(exchange, 409, "Chưa đủ điểm thân mật để cầu hôn (cần " + PROPOSAL_THRESHOLD + ")");
                return;
            }
            if (!presenceDao.isOnline(req.fromUserId(), now, PresenceDao.ONLINE_WINDOW_MS)
                    || !presenceDao.isOnline(req.toUserId(), now, PresenceDao.ONLINE_WINDOW_MS)) {
                JsonHttp.writeError(exchange, 409, "Cả hai phải đang online để cầu hôn");
                return;
            }
            if (marriageDao.isMarried(req.fromUserId()) || marriageDao.isMarried(req.toUserId())) {
                JsonHttp.writeError(exchange, 409, "Một trong hai người đã kết hôn rồi");
                return;
            }
            if (divorceCooldownDao.isInCooldown(req.fromUserId(), now) || divorceCooldownDao.isInCooldown(req.toUserId(), now)) {
                JsonHttp.writeError(exchange, 409, "Một trong hai người vừa ly hôn, đang trong thời gian chờ");
                return;
            }
            if (proposalDao.exists(req.fromUserId(), req.toUserId())) {
                JsonHttp.writeError(exchange, 409, "Đã gửi lời cầu hôn trước đó, đang chờ phản hồi");
                return;
            }
            boolean paid = useGold ? walletDao.spendGold(req.fromUserId(), RING_COST_GOLD)
                    : walletDao.spendDiamond(req.fromUserId(), RING_COST_DIAMOND);
            if (!paid) {
                JsonHttp.writeError(exchange, 402, "Không đủ " + (useGold ? "vàng" : "kim cương") + " để mua nhẫn cầu hôn");
                return;
            }
            var proposal = proposalDao.create(req.fromUserId(), req.toUserId(), now);
            JsonHttp.write(exchange, 201, proposal);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi cầu hôn: " + e.getMessage());
        }
    }
}
