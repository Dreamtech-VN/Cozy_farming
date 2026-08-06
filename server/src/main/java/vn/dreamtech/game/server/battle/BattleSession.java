package vn.dreamtech.game.server.battle;

import vn.dreamtech.game.server.battle.engine.TileBoard;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * Trạng thái 1 trận đấu đang diễn ra — giữ trong bộ nhớ (không lưu DB), vì
 * đây là phiên chơi thời gian thực, không phải dữ liệu cần bền vững.
 * TODO: khi có PvP/leaderboard cần lịch sử trận, cân nhắc lưu kết quả cuối
 * (không phải từng lượt) vào DB.
 */
public final class BattleSession {
    final String id;
    final int userId;
    final StoryLevelDef level;
    final TileBoard board;
    final Random random;

    int playerHp = BattleConstants.PLAYER_HP_MAX;
    int enemyHp;
    int mana = 0;
    int comboCount = 0;
    int swapCount = 0;
    BattleStatus status = BattleStatus.ONGOING;
    boolean rewardGranted = false;
    List<ActiveEffect> effects = new ArrayList<>();

    BattleSession(String id, int userId, StoryLevelDef level, TileBoard board, Random random) {
        this.id = id;
        this.userId = userId;
        this.level = level;
        this.board = board;
        this.random = random;
        this.enemyHp = level.enemyHp();
    }

    boolean hasEffect(BuffType type) {
        return effects.stream().anyMatch(e -> e.type() == type);
    }

    void tickEffects() {
        effects = effects.stream().map(ActiveEffect::tick).filter(e -> !e.expired()).toList();
    }

    void refreshEffect(BuffType type, int durationSwaps) {
        effects = effects.stream().filter(e -> e.type() != type).toList();
        List<ActiveEffect> next = new ArrayList<>(effects);
        next.add(new ActiveEffect(type, durationSwaps));
        effects = next;
    }
}
