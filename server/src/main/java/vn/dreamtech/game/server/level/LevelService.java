package vn.dreamtech.game.server.level;

import vn.dreamtech.game.server.model.LevelInfo;

/**
 * Đường cong exp — game mới, không có gốc thật để đối chiếu, tự đặt công
 * thức đơn giản: cần {@code level * 100} exp để lên level kế (level 1 cần
 * 100 exp lên 2, level 2 cần 200 exp lên 3...). TODO: tinh chỉnh lại khi có
 * hệ chiến đấu/nhiệm vụ thật để cân bằng tốc độ lên level.
 */
public final class LevelService {
    public static int expToNextLevel(int level) {
        return level * 100;
    }

    /** Cộng exp rồi lên level liên tục cho tới khi không đủ exp lên tiếp — không giới hạn số lần lên level trong 1 lần cộng. */
    public static LevelInfo addExp(LevelInfo current, int amount) {
        int level = current.level();
        int exp = current.exp() + amount;
        while (exp >= expToNextLevel(level)) {
            exp -= expToNextLevel(level);
            level++;
        }
        return new LevelInfo(current.userId(), level, exp);
    }

    private LevelService() {
    }
}
