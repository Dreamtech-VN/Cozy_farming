package vn.dreamtech.game.server.battle;

import vn.dreamtech.game.server.battle.challenge.ChallengeCatalog;
import vn.dreamtech.game.server.battle.challenge.ChallengeDef;
import vn.dreamtech.game.server.battle.challenge.ChallengeType;
import vn.dreamtech.game.server.battle.engine.BoardGenerator;
import vn.dreamtech.game.server.battle.engine.CascadeResolver;
import vn.dreamtech.game.server.battle.engine.CascadeResult;
import vn.dreamtech.game.server.battle.engine.ChainStep;
import vn.dreamtech.game.server.battle.engine.MatchFinder;
import vn.dreamtech.game.server.battle.engine.TileBoard;
import vn.dreamtech.game.server.battle.dungeon.DungeonCatalog;
import vn.dreamtech.game.server.battle.dungeon.DungeonDef;
import vn.dreamtech.game.server.battle.tower.TowerCatalog;
import vn.dreamtech.game.server.battle.tower.TowerDef;
import vn.dreamtech.game.server.dao.ChallengeAttemptDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.level.LevelService;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Random;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import static vn.dreamtech.game.server.battle.BattleConstants.*;

/**
 * Lõi gameplay match-3: swap -> khớp -> dây chuyền (chain) -> sát thương
 * (combo/critical) -> mana -> ultimate -> buff/debuff -> địch phản đòn.
 * Phiên trận giữ trong bộ nhớ (xem {@link BattleSession}).
 */
public final class BattleService {
    private final Map<String, BattleSession> sessions = new ConcurrentHashMap<>();
    private final LevelDao levelDao;
    private final WalletDao walletDao;
    private final ChallengeAttemptDao challengeAttemptDao;

    public BattleService(LevelDao levelDao, WalletDao walletDao, ChallengeAttemptDao challengeAttemptDao) {
        this.levelDao = levelDao;
        this.walletDao = walletDao;
        this.challengeAttemptDao = challengeAttemptDao;
    }

    public BattleStateView startStory(int userId, int levelId) {
        StoryLevelDef level = StoryLevelCatalog.find(levelId)
                .orElseThrow(() -> new BattleException(404, "Không tìm thấy màn chơi"));
        BattleSession session = createSession(userId, level, BattleMode.STORY, levelId, null, null);
        return toView(session, false, false, 0, 0, 0, false, false);
    }

    public BattleStateView startDungeon(int userId, int dungeonId) {
        DungeonDef dungeon = DungeonCatalog.find(dungeonId)
                .orElseThrow(() -> new BattleException(404, "Không tìm thấy dungeon"));
        BattleSession session = createSession(userId, dungeon.floorEnemy(0), BattleMode.DUNGEON, null, null, dungeon);
        return toView(session, false, false, 0, 0, 0, false, false);
    }

    public BattleStateView startTower(int userId, int towerId) {
        TowerDef tower = TowerCatalog.find(towerId)
                .orElseThrow(() -> new BattleException(404, "Không tìm thấy tháp"));
        BattleSession session = createSession(userId, tower.floorEnemy(0), BattleMode.TOWER, null, null, tower);
        return toView(session, false, false, 0, 0, 0, false, false);
    }

    public BattleStateView startGuildBoss(int userId, EnemyDef bossFight) {
        BattleSession session = createSession(userId, bossFight, BattleMode.GUILD_BOSS, null, null, null);
        return toView(session, false, false, 0, 0, 0, false, false);
    }

    public BattleStateView startWorldBoss(int userId, EnemyDef bossFight) {
        BattleSession session = createSession(userId, bossFight, BattleMode.WORLD_BOSS, null, null, null);
        return toView(session, false, false, 0, 0, 0, false, false);
    }

    public BattleStateView startPvp(int userId, EnemyDef fight) {
        BattleSession session = createSession(userId, fight, BattleMode.PVP, null, null, null);
        return toView(session, false, false, 0, 0, 0, false, false);
    }

    public BattleStateView startChallenge(int userId, ChallengeType type) {
        ChallengeDef def = ChallengeCatalog.find(type);
        try {
            Optional<Long> lastCompleted = challengeAttemptDao.findLastCompletedAt(userId, type);
            if (lastCompleted.isPresent()) {
                long elapsed = System.currentTimeMillis() - lastCompleted.get();
                if (elapsed < type.cooldownMs) {
                    long remaining = type.cooldownMs - elapsed;
                    throw new BattleException(429, "Chưa hết thời gian chờ, còn " + remaining + " ms");
                }
            }
        } catch (SQLException e) {
            throw new BattleException(500, "Lỗi kiểm tra thời gian chờ: " + e.getMessage());
        }
        BattleSession session = createSession(userId, def, type == ChallengeType.DAILY ? BattleMode.DAILY : BattleMode.WEEKLY, null, type, null);
        return toView(session, false, false, 0, 0, 0, false, false);
    }

    private BattleSession createSession(int userId, EnemyDef level, BattleMode mode, Integer storyLevelId,
                                         ChallengeType challengeType, FloorSource floorSource) {
        Random random = new Random();
        TileBoard board = BoardGenerator.generate(BOARD_ROWS, BOARD_COLS, COLOR_COUNT, random);
        String id = UUID.randomUUID().toString();
        BattleSession session = new BattleSession(id, userId, level, mode, storyLevelId, challengeType, floorSource, board, random);
        sessions.put(id, session);
        return session;
    }

    public ChallengeStatusView challengeStatus(int userId, ChallengeType type) {
        try {
            Optional<Long> lastCompleted = challengeAttemptDao.findLastCompletedAt(userId, type);
            if (lastCompleted.isEmpty()) {
                return new ChallengeStatusView(type, true, 0);
            }
            long elapsed = System.currentTimeMillis() - lastCompleted.get();
            long remaining = Math.max(0, type.cooldownMs - elapsed);
            return new ChallengeStatusView(type, remaining == 0, remaining);
        } catch (SQLException e) {
            throw new BattleException(500, "Lỗi kiểm tra thời gian chờ: " + e.getMessage());
        }
    }

    public BattleStateView getState(String battleId) {
        return toView(find(battleId), false, false, 0, 0, 0, false, false);
    }

    public BattleStateView swap(String battleId, int r1, int c1, int r2, int c2) {
        BattleSession session = find(battleId);
        requireOngoing(session);
        TileBoard board = session.board;
        if (!board.inBounds(r1, c1) || !board.inBounds(r2, c2)) {
            throw new BattleException(400, "Toạ độ ngoài bàn cờ");
        }
        if (Math.abs(r1 - r2) + Math.abs(c1 - c2) != 1) {
            throw new BattleException(400, "Chỉ được đổi 2 ô liền kề");
        }

        TileBoard trial = board.copy();
        trial.swapCells(r1, c1, r2, c2);
        boolean wouldMatch = !MatchFinder.find(trial).isEmpty();

        boolean manaDown = session.hasEffect(BuffType.PLAYER_MANA_DOWN);
        boolean damageUp = session.hasEffect(BuffType.PLAYER_DAMAGE_UP);

        boolean matched = false;
        boolean critical = false;
        int chainLevels = 0;
        int damageDealt = 0;
        int manaGained = 0;

        if (wouldMatch) {
            board.swapCells(r1, c1, r2, c2);
            CascadeResult cascade = CascadeResolver.resolve(board, session.random, COLOR_COUNT);
            matched = true;
            chainLevels = cascade.chainLevels();
            critical = cascade.steps().stream().anyMatch(s -> s.hasCritical(CRITICAL_GROUP_SIZE));

            double rawDamage = 0;
            int tilesCleared = 0;
            for (ChainStep step : cascade.steps()) {
                double stepDamage = 0;
                for (int groupSize : step.groupSizes()) {
                    double groupMult = groupSize >= CRITICAL_GROUP_SIZE ? 2.0 : groupSize == BONUS_GROUP_SIZE ? 1.5 : 1.0;
                    stepDamage += BASE_DAMAGE_PER_TILE * groupSize * groupMult;
                }
                stepDamage *= 1 + CHAIN_BONUS_PER_LEVEL * (step.level() - 1);
                rawDamage += stepDamage;
                tilesCleared += step.tilesCleared();
            }

            double comboMult = 1 + COMBO_BONUS_PER_STACK * Math.min(session.comboCount, COMBO_MAX_STACK);
            double buffMult = damageUp ? 1 + CRIT_BUFF_DAMAGE_MULT : 1.0;
            damageDealt = (int) Math.round(rawDamage * comboMult * buffMult);

            manaGained = (int) Math.round(tilesCleared * MANA_PER_TILE * (manaDown ? ENEMY_DEBUFF_MANA_MULT : 1.0));

            session.comboCount++;
            session.enemyHp = Math.max(0, session.enemyHp - damageDealt);
            session.mana = Math.min(MANA_MAX, session.mana + manaGained);
            session.totalDamageDealt += damageDealt;
        } else {
            session.comboCount = 0;
        }

        session.tickEffects();
        if (critical) {
            session.refreshEffect(BuffType.PLAYER_DAMAGE_UP, CRIT_BUFF_DURATION_SWAPS);
        }

        session.swapCount++;
        boolean enemyCountered = false;
        if (session.status == BattleStatus.ONGOING && session.enemyHp > 0
                && session.swapCount % ENEMY_COUNTER_EVERY_N_SWAPS == 0) {
            enemyCountered = true;
            session.playerHp = Math.max(0, session.playerHp - session.level.enemyCounterDamage());
            session.refreshEffect(BuffType.PLAYER_MANA_DOWN, ENEMY_DEBUFF_DURATION_SWAPS);
        }

        boolean floorCleared = resolveOutcome(session);
        return toView(session, matched, critical, chainLevels, damageDealt, manaGained, enemyCountered, floorCleared);
    }

    public BattleStateView useUltimate(String battleId) {
        BattleSession session = find(battleId);
        requireOngoing(session);
        if (session.mana < MANA_MAX) {
            throw new BattleException(400, "Chưa đủ mana để dùng chiêu cuối");
        }
        session.mana = 0;
        session.enemyHp = Math.max(0, session.enemyHp - ULTIMATE_DAMAGE);
        session.totalDamageDealt += ULTIMATE_DAMAGE;
        boolean floorCleared = resolveOutcome(session);
        return toView(session, false, false, 0, ULTIMATE_DAMAGE, 0, false, floorCleared);
    }

    /** @return true nếu vừa qua 1 tầng (Dungeon/Tower, còn tầng tiếp theo, trận vẫn ONGOING). */
    private boolean resolveOutcome(BattleSession session) {
        if (session.status != BattleStatus.ONGOING) return false;
        if (session.enemyHp <= 0) {
            if (session.hasNextFloor()) {
                // Dungeon: thưởng tầng giữa là 0/0 (no-op). Tower: mỗi tầng đều có thưởng, phát ngay khi qua tầng.
                grantFloorReward(session, session.level);
                TileBoard nextBoard = BoardGenerator.generate(BOARD_ROWS, BOARD_COLS, COLOR_COUNT, session.random);
                session.advanceFloor(nextBoard);
                return true;
            }
            session.status = BattleStatus.WON;
            grantRewardOnce(session);
        } else if (session.playerHp <= 0) {
            session.status = BattleStatus.LOST;
        } else if (session.mode == BattleMode.PVP && session.swapCount >= PVP_MOVE_LIMIT) {
            // PvP không đấu tới khi 1 bên hết máu (địch HP gần như vô hạn) — hết lượt là dừng,
            // PvpService chỉ đọc totalDamageDealt để so điểm, KHÔNG coi LOST là "thua" thật.
            session.status = BattleStatus.LOST;
        }
        return false;
    }

    private void grantFloorReward(BattleSession session, EnemyDef floor) {
        if (floor.rewardExp() == 0 && floor.rewardGold() == 0) return;
        try {
            var levelInfo = levelDao.find(session.userId);
            levelDao.save(LevelService.addExp(levelInfo, floor.rewardExp()));
            walletDao.addGold(session.userId, floor.rewardGold());
        } catch (SQLException e) {
            throw new BattleException(500, "Lỗi phát thưởng: " + e.getMessage());
        }
    }

    private void grantRewardOnce(BattleSession session) {
        if (session.rewardGranted) return;
        session.rewardGranted = true;
        grantFloorReward(session, session.level);
        if (session.challengeType != null) {
            try {
                challengeAttemptDao.recordCompletion(session.userId, session.challengeType, System.currentTimeMillis());
            } catch (SQLException e) {
                throw new BattleException(500, "Lỗi ghi nhận hoàn thành: " + e.getMessage());
            }
        }
    }

    private BattleSession find(String battleId) {
        BattleSession session = sessions.get(battleId);
        if (session == null) throw new BattleException(404, "Không tìm thấy trận đấu");
        return session;
    }

    private void requireOngoing(BattleSession session) {
        if (session.status != BattleStatus.ONGOING) {
            throw new BattleException(409, "Trận đấu đã kết thúc");
        }
    }

    private BattleStateView toView(BattleSession s, boolean matched, boolean critical, int chainLevels,
                                    int damageDealt, int manaGained, boolean enemyCountered, boolean floorCleared) {
        List<BuffType> activeEffects = s.effects.stream().map(ActiveEffect::type).toList();
        Integer floorIndex = s.floorSource == null ? null : s.floorIndex + 1;
        Integer totalFloors = s.floorSource == null ? null : s.totalFloors();
        return new BattleStateView(
                s.id, s.userId, s.mode, s.storyLevelId, s.status, s.board.toArray(),
                s.playerHp, PLAYER_HP_MAX, s.enemyHp, s.level.enemyHp(),
                s.mana, MANA_MAX, s.comboCount, activeEffects,
                matched, critical, chainLevels, damageDealt, manaGained,
                enemyCountered, s.level.enemyCounterDamage(),
                s.rewardGranted && s.status == BattleStatus.WON, s.level.rewardExp(), s.level.rewardGold(),
                floorIndex, totalFloors, floorCleared, s.totalDamageDealt
        );
    }
}
