package vn.dreamtech.game.server.battle;

import vn.dreamtech.game.server.battle.challenge.ChallengeType;
import vn.dreamtech.game.server.battle.dungeon.DungeonDef;
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
    final BattleMode mode;
    final Integer storyLevelId; // chỉ có ý nghĩa khi mode == STORY
    final ChallengeType challengeType; // chỉ có ý nghĩa khi mode == DAILY/WEEKLY
    final DungeonDef dungeonDef; // chỉ có ý nghĩa khi mode == DUNGEON
    final Random random;

    EnemyDef level; // đổi được: Dungeon sang tầng mới thì đổi sang địch tầng đó
    TileBoard board; // đổi được: Dungeon sang tầng mới thì sinh bàn mới
    int floorIndex = 0; // 0-based, chỉ có ý nghĩa khi mode == DUNGEON

    int playerHp = BattleConstants.PLAYER_HP_MAX;
    int enemyHp;
    int mana = 0;
    int comboCount = 0;
    int swapCount = 0;
    BattleStatus status = BattleStatus.ONGOING;
    boolean rewardGranted = false;
    List<ActiveEffect> effects = new ArrayList<>();

    BattleSession(String id, int userId, EnemyDef level, BattleMode mode, Integer storyLevelId,
                  ChallengeType challengeType, DungeonDef dungeonDef, TileBoard board, Random random) {
        this.id = id;
        this.userId = userId;
        this.level = level;
        this.mode = mode;
        this.storyLevelId = storyLevelId;
        this.challengeType = challengeType;
        this.dungeonDef = dungeonDef;
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

    boolean hasNextFloor() {
        return dungeonDef != null && floorIndex + 1 < dungeonDef.floors().size();
    }

    int totalFloors() {
        return dungeonDef == null ? 0 : dungeonDef.floors().size();
    }

    /** Sang tầng kế — máu người chơi/hiệu ứng KHÔNG hồi lại, chỉ mana/combo/lượt bàn cờ reset theo tầng mới. */
    void advanceFloor(TileBoard newBoard) {
        floorIndex++;
        level = dungeonDef.floorEnemy(floorIndex);
        enemyHp = level.enemyHp();
        mana = 0;
        comboCount = 0;
        swapCount = 0;
        board = newBoard;
    }
}
