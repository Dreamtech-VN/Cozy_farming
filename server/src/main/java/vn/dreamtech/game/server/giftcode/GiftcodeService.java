package vn.dreamtech.game.server.giftcode;

import vn.dreamtech.game.server.dao.GiftcodeDao;
import vn.dreamtech.game.server.dao.GiftcodeRedemptionDao;
import vn.dreamtech.game.server.item.ItemException;
import vn.dreamtech.game.server.item.RewardEntry;
import vn.dreamtech.game.server.item.RewardGrantService;
import vn.dreamtech.game.server.mail.MailService;
import vn.dreamtech.game.server.mail.MailView;

import java.sql.SQLException;
import java.util.List;

/**
 * Đổi giftcode KHÔNG cấp thưởng ngay — tạo 1 thư ({@code MailService}) rồi
 * user tự vào hộp thư nhận, khớp yêu cầu "tất cả đều xem thư". 2 giới hạn
 * độc lập: {@code max_uses} tổng của cả server ({@code GiftcodeDao}) và mỗi
 * user chỉ đổi 1 lần/code ({@code GiftcodeRedemptionDao}).
 */
public final class GiftcodeService {
    private final GiftcodeDao giftcodeDao;
    private final GiftcodeRedemptionDao redemptionDao;
    private final RewardGrantService rewardGrantService;
    private final MailService mailService;

    public GiftcodeService(GiftcodeDao giftcodeDao, GiftcodeRedemptionDao redemptionDao,
                            RewardGrantService rewardGrantService, MailService mailService) {
        this.giftcodeDao = giftcodeDao;
        this.redemptionDao = redemptionDao;
        this.rewardGrantService = rewardGrantService;
        this.mailService = mailService;
    }

    public GiftcodeDao.Giftcode create(String code, String title, List<RewardEntry> rewards, Integer maxUses, Long expiresAt) {
        try {
            if (code == null || code.isBlank()) {
                throw new ItemException(400, "Thiếu code");
            }
            if (giftcodeDao.find(code).isPresent()) {
                throw new ItemException(409, "Code này đã tồn tại rồi");
            }
            rewardGrantService.validateRewards(rewards);
            return giftcodeDao.create(code, title, rewards, maxUses, expiresAt);
        } catch (SQLException e) {
            throw new ItemException(500, "Lỗi tạo giftcode: " + e.getMessage());
        }
    }

    public GiftcodeDao.Giftcode update(String code, String title, List<RewardEntry> rewards, Integer maxUses,
                                        Long expiresAt, boolean active) {
        try {
            giftcodeDao.find(code).orElseThrow(() -> new ItemException(404, "Không tìm thấy giftcode"));
            rewardGrantService.validateRewards(rewards);
            giftcodeDao.update(code, title, rewards, maxUses, expiresAt, active);
            return giftcodeDao.find(code).orElseThrow();
        } catch (SQLException e) {
            throw new ItemException(500, "Lỗi cập nhật giftcode: " + e.getMessage());
        }
    }

    public void delete(String code) {
        try {
            giftcodeDao.find(code).orElseThrow(() -> new ItemException(404, "Không tìm thấy giftcode"));
            giftcodeDao.delete(code);
        } catch (SQLException e) {
            throw new ItemException(500, "Lỗi xoá giftcode: " + e.getMessage());
        }
    }

    public List<GiftcodeDao.Giftcode> listAll() {
        try {
            return giftcodeDao.findAll();
        } catch (SQLException e) {
            throw new ItemException(500, "Lỗi lấy danh sách giftcode: " + e.getMessage());
        }
    }

    public MailView redeem(int userId, String code) {
        try {
            var giftcode = giftcodeDao.find(code).orElseThrow(() -> new ItemException(404, "Giftcode không tồn tại"));
            if (!giftcode.active()) {
                throw new ItemException(409, "Giftcode đã bị tắt");
            }
            if (giftcode.expiresAt() != null && System.currentTimeMillis() > giftcode.expiresAt()) {
                throw new ItemException(410, "Giftcode đã hết hạn");
            }
            if (giftcode.maxUses() != null && giftcode.usedCount() >= giftcode.maxUses()) {
                throw new ItemException(409, "Giftcode đã hết lượt đổi");
            }
            if (redemptionDao.hasRedeemed(userId, code)) {
                throw new ItemException(409, "Bạn đã đổi code này rồi");
            }
            redemptionDao.recordRedemption(userId, code);
            giftcodeDao.incrementUsedCount(code);
            return mailService.sendToUser(userId, "Giftcode: " + code, giftcode.title(), giftcode.rewards(),
                    "GIFTCODE", null);
        } catch (SQLException e) {
            throw new ItemException(500, "Lỗi đổi giftcode: " + e.getMessage());
        }
    }
}
