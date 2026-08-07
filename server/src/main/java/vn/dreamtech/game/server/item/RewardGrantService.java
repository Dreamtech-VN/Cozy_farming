package vn.dreamtech.game.server.item;

import vn.dreamtech.game.server.dao.ItemDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.PlayerCosmeticDao;
import vn.dreamtech.game.server.dao.PlayerItemDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.level.LevelService;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Nơi DUY NHẤT thật sự cấp phần thưởng (gold/diamond/exp/cosmetic/material)
 * — giftcode/thư/sự kiện chỉ tạo {@link RewardEntry} (itemId + số lượng)
 * trỏ vào "kho item" ({@code ItemDao}), còn cấp phát thật luôn đi qua đây,
 * tránh lặp logic ở nhiều nơi.
 */
public final class RewardGrantService {
    private final ItemDao itemDao;
    private final WalletDao walletDao;
    private final LevelDao levelDao;
    private final PlayerCosmeticDao playerCosmeticDao;
    private final PlayerItemDao playerItemDao;

    public RewardGrantService(ItemDao itemDao, WalletDao walletDao, LevelDao levelDao,
                               PlayerCosmeticDao playerCosmeticDao, PlayerItemDao playerItemDao) {
        this.itemDao = itemDao;
        this.walletDao = walletDao;
        this.levelDao = levelDao;
        this.playerCosmeticDao = playerCosmeticDao;
        this.playerItemDao = playerItemDao;
    }

    public List<GrantedReward> grant(int userId, List<RewardEntry> rewards) throws SQLException {
        List<GrantedReward> out = new ArrayList<>();
        for (RewardEntry entry : rewards) {
            ItemDao.Item item = itemDao.find(entry.itemId())
                    .orElseThrow(() -> new ItemException(404, "Không tìm thấy item id=" + entry.itemId()));
            switch (item.category()) {
                case GOLD -> walletDao.addGold(userId, entry.quantity());
                case DIAMOND -> walletDao.addDiamond(userId, entry.quantity());
                case EXP -> levelDao.save(LevelService.addExp(levelDao.find(userId), entry.quantity()));
                case COSMETIC -> {
                    if (item.refId() == null) {
                        throw new ItemException(500, "Item cosmetic id=" + item.id() + " thiếu refId");
                    }
                    playerCosmeticDao.unlock(userId, item.refId());
                }
                case MATERIAL -> playerItemDao.addQuantity(userId, item.id(), entry.quantity());
            }
            out.add(new GrantedReward(item.id(), item.name(), item.category(), entry.quantity()));
        }
        return out;
    }

    /** Kiểm tra danh sách reward hợp lệ (item tồn tại, số lượng > 0) trước khi cho gắn vào giftcode/thư/sự kiện. */
    public void validateRewards(List<RewardEntry> rewards) throws SQLException {
        if (rewards == null || rewards.isEmpty()) {
            throw new ItemException(400, "Phải có ít nhất 1 phần thưởng");
        }
        for (RewardEntry entry : rewards) {
            if (entry.quantity() <= 0) {
                throw new ItemException(400, "Số lượng phải > 0 (itemId=" + entry.itemId() + ")");
            }
            itemDao.find(entry.itemId())
                    .orElseThrow(() -> new ItemException(404, "Không tìm thấy item id=" + entry.itemId()));
        }
    }
}
