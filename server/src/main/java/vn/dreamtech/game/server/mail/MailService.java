package vn.dreamtech.game.server.mail;

import vn.dreamtech.game.server.dao.MailBroadcastReceiptDao;
import vn.dreamtech.game.server.dao.MailDao;
import vn.dreamtech.game.server.dao.MailTemplateDao;
import vn.dreamtech.game.server.item.ItemException;
import vn.dreamtech.game.server.item.RewardEntry;
import vn.dreamtech.game.server.item.RewardGrantService;

import java.sql.SQLException;
import java.util.List;

/**
 * Hộp thư — nguồn DUY NHẤT để nhận thưởng giftcode/sự kiện/admin gửi (đúng
 * yêu cầu "tất cả đều xem thư"): các nguồn khác chỉ TẠO thư qua
 * {@link #sendToUser}, còn thật sự cấp phần thưởng chỉ xảy ra khi user bấm
 * nhận ({@link #claim}, gọi {@code RewardGrantService}).
 */
public final class MailService {
    private final MailDao mailDao;
    private final MailTemplateDao mailTemplateDao;
    private final MailBroadcastReceiptDao broadcastReceiptDao;
    private final RewardGrantService rewardGrantService;

    public MailService(MailDao mailDao, MailTemplateDao mailTemplateDao, MailBroadcastReceiptDao broadcastReceiptDao,
                        RewardGrantService rewardGrantService) {
        this.mailDao = mailDao;
        this.mailTemplateDao = mailTemplateDao;
        this.broadcastReceiptDao = broadcastReceiptDao;
        this.rewardGrantService = rewardGrantService;
    }

    /** Nguồn khác (giftcode, sự kiện,...) gửi thư cho 1 user cụ thể. */
    public MailView sendToUser(int userId, String title, String body, List<RewardEntry> rewards, String source, Long expiresAt) {
        try {
            var mail = mailDao.create(userId, title, body, rewards, source, System.currentTimeMillis(), expiresAt);
            return toView(mail);
        } catch (SQLException e) {
            throw new ItemException(500, "Lỗi gửi thư: " + e.getMessage());
        }
    }

    /** Admin gửi thư cho TOÀN SERVER — chỉ tạo template, "vật chất hoá" lazy khi từng user mở hộp thư (xem {@link #list}). */
    public void broadcast(String title, String body, List<RewardEntry> rewards, Long expiresAt) {
        try {
            mailTemplateDao.create(title, body, rewards, System.currentTimeMillis(), expiresAt);
        } catch (SQLException e) {
            throw new ItemException(500, "Lỗi gửi thư quảng bá: " + e.getMessage());
        }
    }

    public List<MailView> list(int userId) {
        try {
            long now = System.currentTimeMillis();
            for (var template : mailTemplateDao.findActive(now)) {
                if (!broadcastReceiptDao.hasReceived(userId, template.id())) {
                    mailDao.create(userId, template.title(), template.body(), template.rewards(), "BROADCAST",
                            now, template.expiresAt());
                    broadcastReceiptDao.markReceived(userId, template.id());
                }
            }
            return mailDao.listByUser(userId).stream().map(MailService::toView).toList();
        } catch (SQLException e) {
            throw new ItemException(500, "Lỗi lấy hộp thư: " + e.getMessage());
        }
    }

    public void markRead(int userId, String mailId) {
        try {
            var mail = mailDao.find(mailId).orElseThrow(() -> new ItemException(404, "Không tìm thấy thư"));
            if (mail.userId() != userId) {
                throw new ItemException(403, "Thư không thuộc về bạn");
            }
            mailDao.markRead(mailId, System.currentTimeMillis());
        } catch (SQLException e) {
            throw new ItemException(500, "Lỗi đánh dấu đã đọc: " + e.getMessage());
        }
    }

    public MailClaimResult claim(int userId, String mailId) {
        try {
            var mail = mailDao.find(mailId).orElseThrow(() -> new ItemException(404, "Không tìm thấy thư"));
            if (mail.userId() != userId) {
                throw new ItemException(403, "Thư không thuộc về bạn");
            }
            if (mail.claimedAt() != null) {
                throw new ItemException(409, "Thư này đã nhận thưởng rồi");
            }
            if (mail.expiresAt() != null && System.currentTimeMillis() > mail.expiresAt()) {
                throw new ItemException(410, "Thư đã hết hạn");
            }
            var granted = rewardGrantService.grant(userId, mail.rewards());
            long now = System.currentTimeMillis();
            mailDao.markRead(mailId, now);
            mailDao.markClaimed(mailId, now);
            return new MailClaimResult(mailId, granted);
        } catch (SQLException e) {
            throw new ItemException(500, "Lỗi nhận thưởng thư: " + e.getMessage());
        }
    }

    private static MailView toView(MailDao.Mail mail) {
        return new MailView(mail.id(), mail.title(), mail.body(), mail.rewards(), mail.source(), mail.createdAt(),
                mail.expiresAt(), mail.readAt(), mail.claimedAt());
    }
}
