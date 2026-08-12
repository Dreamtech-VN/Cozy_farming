package vn.dreamtech.game.server.battle;

import vn.dreamtech.game.server.battle.challenge.ChallengeType;
import vn.dreamtech.game.server.battle.engine.TileBoard;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.locks.ReentrantLock;

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
    final Integer catalogLevelId; // chỉ có ý nghĩa khi mode == STORY/ADVENTURE/EVENT_PUZZLE
    final ChallengeType challengeType; // chỉ có ý nghĩa khi mode == DAILY/WEEKLY
    final FloorSource floorSource; // chỉ có ý nghĩa khi mode == DUNGEON/TOWER
    final Random random;
    // Chặn 2 request cùng lúc (double-tap, retry, hoặc client cố tình gửi trùng) đè lên nhau
    // trong lúc sửa board/HP/mana/reward — mỗi trận 1 lock riêng, không khoá cả bảng sessions.
    final ReentrantLock lock = new ReentrantLock();

    EnemyDef level; // đổi được: sang tầng mới thì đổi sang địch tầng đó
    TileBoard board; // đổi được: sang tầng mới thì sinh bàn mới
    int floorIndex = 0; // 0-based, chỉ có ý nghĩa khi floorSource != null

    int playerHp = BattleConstants.PLAYER_HP_MAX;
    int enemyHp;
    int mana = 0;
    int comboCount = 0;
    int swapCount = 0;
    int totalDamageDealt = 0; // cộng dồn suốt trận — Guild Boss dùng để đồng bộ về HP chung của guild
    BattleStatus status = BattleStatus.ONGOING;
    boolean rewardGranted = false;
    List<ActiveEffect> effects = new ArrayList<>();

    BattleSession(String id, int userId, EnemyDef level, BattleMode mode, Integer catalogLevelId,
                  ChallengeType challengeType, FloorSource floorSource, TileBoard board, Random random) {
        this.id = id;
        this.userId = userId;
        this.level = level;
        this.mode = mode;
        this.catalogLevelId = catalogLevelId;
        this.challengeType = challengeType;
        this.floorSource = floorSource;
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
        return floorSource != null && floorSource.hasNextFloor(floorIndex);
    }

    int totalFloors() {
        return floorSource == null ? 0 : floorSource.totalFloors();
    }

    /** Sang tầng kế — máu người chơi/hiệu ứng KHÔNG hồi lại, chỉ mana/combo/lượt bàn cờ reset theo tầng mới. */
    void advanceFloor(TileBoard newBoard) {
        floorIndex++;
        level = floorSource.floorEnemy(floorIndex);
        enemyHp = level.enemyHp();
        mana = 0;
        comboCount = 0;
        swapCount = 0;
        board = newBoard;
    }
}
