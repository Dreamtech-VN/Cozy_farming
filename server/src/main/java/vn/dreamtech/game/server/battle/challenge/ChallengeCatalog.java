package vn.dreamtech.game.server.battle.challenge;

import java.util.Map;

/**
 * MVP: mỗi loại (Daily/Weekly) chỉ có ĐÚNG 1 con trùm cố định, không xoay
 * vòng nội dung theo ngày/tuần thật. TODO: khi có hệ nội dung thật, đổi
 * sang chọn ngẫu nhiên/luân phiên trong 1 pool theo mốc ngày/tuần.
 */
public final class ChallengeCatalog {
    private static final Map<ChallengeType, ChallengeDef> DEFS = Map.of(
            ChallengeType.DAILY, new ChallengeDef(ChallengeType.DAILY, "Thử thách hằng ngày", 300, 10, 40, 100),
            ChallengeType.WEEKLY, new ChallengeDef(ChallengeType.WEEKLY, "Thử thách hằng tuần", 800, 20, 150, 500)
    );

    public static ChallengeDef find(ChallengeType type) {
        return DEFS.get(type);
    }

    private ChallengeCatalog() {
    }
}
