package vn.dreamtech.game.server.battle;

import vn.dreamtech.game.server.battle.adventure.AdventureLevelCatalog;
import vn.dreamtech.game.server.battle.adventure.AdventureLevelDef;
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
import vn.dreamtech.game.server.battle.eventpuzzle.EventPuzzleCatalog;
import vn.dreamtech.game.server.battle.eventpuzzle.EventPuzzleDef;
import vn.dreamtech.game.server.battle.tower.TowerCatalog;
import vn.dreamtech.game.server.battle.tower.TowerDef;
import vn.dreamtech.game.server.battle.tower.TowerLeaderboardEntry;
import vn.dreamtech.game.server.dao.ChallengeAttemptDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.TowerRecordDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.level.LevelService;

import java.sql.SQLException;
import java.util.ArrayList;
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
    private final TowerRecordDao towerRecordDao;

    public BattleService(LevelDao levelDao, WalletDao walletDao, ChallengeAttemptDao challengeAttemptDao,
                          TowerRecordDao towerRecordDao) {
        this.levelDao = levelDao;
        this.walletDao = walletDao;
        this.challengeAttemptDao = challengeAttemptDao;
        this.towerRecordDao = towerRecordDao;
    }

    public BattleStateView startStory(int userId, int levelId) {
        StoryLevelDef level = StoryLevelCatalog.find(levelId)
                .orElseThrow(() -> new BattleException(404, "Không tìm thấy màn chơi"));
        BattleSession session = createSession(userId, level, BattleMode.STORY, levelId, null, null);
        return toView(session, false, false, 0, 0, 0, false, false);
    }

    public BattleStateView startAdventure(int userId, int levelId) {
        AdventureLevelDef level = AdventureLevelCatalog.find(levelId)
                .orElseThrow(() -> new BattleException(404, "Không tìm thấy màn Adventure"));
        BattleSession session = createSession(userId, level, BattleMode.ADVENTURE, levelId, null, null);
        return toView(session, false, false, 0, 0, 0, false, false);
    }

    public BattleStateView startEventPuzzle(int userId, int eventId) {
        EventPuzzleDef event = EventPuzzleCatalog.find(eventId)
                .orElseThrow(() -> new BattleException(404, "Không tìm thấy sự kiện"));
        if (!event.isActiveAt(System.currentTimeMillis())) {
            throw new BattleException(409, "Sự kiện chưa bắt đầu hoặc đã kết thúc");
        }
        BattleSession session = createSession(userId, event, BattleMode.EVENT_PUZZLE, eventId, null, null);
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

    public BattleStateView startGuildWar(int userId, EnemyDef fight) {
        BattleSession session = createSession(userId, fight, BattleMode.GUILD_WAR, null, null, null);
        return toView(session, false, false, 0, 0, 0, false, false);
    }

    public BattleStateView startMarriageCoop(int userId, EnemyDef fight) {
        BattleSession session = createSession(userId, fight, BattleMode.MARRIAGE_COOP, null, null, null);
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

    private BattleSession createSession(int userId, EnemyDef level, BattleMode mode, Integer catalogLevelId,
                                         ChallengeType challengeType, FloorSource floorSource) {
        Random random = new Random();
        TileBoard board = BoardGenerator.generate(BOARD_ROWS, BOARD_COLS, COLOR_COUNT, random);
        String id = UUID.randomUUID().toString();
        BattleSession session = new BattleSession(id, userId, level, mode, catalogLevelId, challengeType, floorSource, board, random);
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

    /** Dùng cho endpoint HTTP công khai — xác nhận battleId thuộc về userId trước khi trả trạng thái. */
    public BattleStateView getState(int userId, String battleId) {
        requireOwnership(find(battleId), userId);
        return getState(battleId);
    }

    /** Dùng cho endpoint HTTP công khai — xác nhận battleId thuộc về userId trước khi cho đánh. */
    public BattleStateView swap(int userId, String battleId, int r1, int c1, int r2, int c2) {
        requireOwnership(find(battleId), userId);
        return swap(battleId, r1, c1, r2, c2);
    }

    /** Dùng cho endpoint HTTP công khai — xác nhận battleId thuộc về userId trước khi dùng chiêu cuối. */
    public BattleStateView useUltimate(int userId, String battleId) {
        requireOwnership(find(battleId), userId);
        return useUltimate(battleId);
    }

    public BattleStateView swap(String battleId, int r1, int c1, int r2, int c2) {
        BattleSession session = find(battleId);
        session.lock.lock();
        try {
            return doSwap(session, r1, c1, r2, c2);
        } finally {
            session.lock.unlock();
        }
    }

    private BattleStateView doSwap(BattleSession session, int r1, int c1, int r2, int c2) {
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
                // Ô hình L/T có thể nằm trong 2 group cùng lúc (xem MatchScanResult) — base damage tính
                // theo số ô vật lý duy nhất (uniqueTilesCleared), phần "bonus" của group lớn/critical vẫn
                // cộng riêng theo từng group để không mất thưởng cho hình dạng, nhưng không nhân đôi base.
                double stepDamage = BASE_DAMAGE_PER_TILE * step.uniqueTilesCleared();
                for (int groupSize : step.groupSizes()) {
                    double groupMult = groupSize >= CRITICAL_GROUP_SIZE ? 2.0 : groupSize == BONUS_GROUP_SIZE ? 1.5 : 1.0;
                    stepDamage += BASE_DAMAGE_PER_TILE * groupSize * (groupMult - 1.0);
                }
                stepDamage *= 1 + CHAIN_BONUS_PER_LEVEL * (step.level() - 1);
                rawDamage += stepDamage;
                tilesCleared += step.uniqueTilesCleared();
            }

            double comboMult = 1 + COMBO_BONUS_PER_STACK * Math.min(session.comboCount, COMBO_MAX_STACK);
            double buffMult = damageUp ? 1 + CRIT_BUFF_DAMAGE_MULT : 1.0;
            damageDealt = (int) Math.round(rawDamage * comboMult * buffMult);

            manaGained = (int) Math.round(tilesCleared * MANA_PER_TILE * (manaDown ? ENEMY_DEBUFF_MANA_MULT : 1.0));

            session.comboCount++;
            session.enemyHp = Math.max(0, session.enemyHp - damageDealt);
            session.mana = Math.min(MANA_MAX, session.mana + manaGained);
            session.totalDamageDealt += damageDealt;

            BoardGenerator.ensurePlayable(board, COLOR_COUNT, session.random);
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
        session.lock.lock();
        try {
            requireOngoing(session);
            if (session.mana < MANA_MAX) {
                throw new BattleException(400, "Chưa đủ mana để dùng chiêu cuối");
            }
            session.mana = 0;
            session.enemyHp = Math.max(0, session.enemyHp - ULTIMATE_DAMAGE);
            session.totalDamageDealt += ULTIMATE_DAMAGE;
            boolean floorCleared = resolveOutcome(session);
            return toView(session, false, false, 0, ULTIMATE_DAMAGE, 0, false, floorCleared);
        } finally {
            session.lock.unlock();
        }
    }

    /** @return true nếu vừa qua 1 tầng (Dungeon/Tower, còn tầng tiếp theo, trận vẫn ONGOING). */
    private boolean resolveOutcome(BattleSession session) {
        if (session.status != BattleStatus.ONGOING) return false;
        if (session.enemyHp <= 0) {
            int floorCleared1Based = session.floorIndex + 1; // floor vừa hạ gục, trước khi advanceFloor tăng floorIndex
            if (session.hasNextFloor()) {
                // Dungeon: thưởng tầng giữa là 0/0 (no-op). Tower: mỗi tầng đều có thưởng, phát ngay khi qua tầng.
                grantFloorReward(session, session.level);
                recordTowerBestFloor(session, floorCleared1Based);
                TileBoard nextBoard = BoardGenerator.generate(BOARD_ROWS, BOARD_COLS, COLOR_COUNT, session.random);
                session.advanceFloor(nextBoard);
                return true;
            }
            session.status = BattleStatus.WON;
            recordTowerBestFloor(session, floorCleared1Based);
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

    private void recordTowerBestFloor(BattleSession session, int floorReached) {
        if (session.mode != BattleMode.TOWER || !(session.floorSource instanceof TowerDef tower)) return;
        try {
            towerRecordDao.updateBestFloorIfHigher(session.userId, tower.id(), floorReached);
        } catch (SQLException e) {
            throw new BattleException(500, "Lỗi ghi nhận kỷ lục tháp: " + e.getMessage());
        }
    }

    public List<TowerLeaderboardEntry> towerLeaderboard(int towerId) {
        try {
            List<TowerRecordDao.Record> records = towerRecordDao.listByTower(towerId);
            List<TowerLeaderboardEntry> entries = new ArrayList<>();
            int rank = 1;
            for (TowerRecordDao.Record r : records) {
                entries.add(new TowerLeaderboardEntry(rank++, r.userId(), r.bestFloor()));
            }
            return entries;
        } catch (SQLException e) {
            throw new BattleException(500, "Lỗi đọc bảng xếp hạng tháp: " + e.getMessage());
        }
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

    private void requireOwnership(BattleSession session, int userId) {
        if (session.userId != userId) {
            throw new BattleException(403, "Trận đấu không thuộc về bạn");
        }
    }

    private BattleStateView toView(BattleSession s, boolean matched, boolean critical, int chainLevels,
                                    int damageDealt, int manaGained, boolean enemyCountered, boolean floorCleared) {
        List<BuffType> activeEffects = s.effects.stream().map(ActiveEffect::type).toList();
        Integer floorIndex = s.floorSource == null ? null : s.floorIndex + 1;
        Integer totalFloors = s.floorSource == null ? null : s.totalFloors();
        return new BattleStateView(
                s.id, s.userId, s.mode, s.catalogLevelId, s.status, s.board.toArray(),
                s.playerHp, PLAYER_HP_MAX, s.enemyHp, s.level.enemyHp(),
                s.mana, MANA_MAX, s.comboCount, activeEffects,
                matched, critical, chainLevels, damageDealt, manaGained,
                enemyCountered, s.level.enemyCounterDamage(),
                s.rewardGranted && s.status == BattleStatus.WON, s.level.rewardExp(), s.level.rewardGold(),
                floorIndex, totalFloors, floorCleared, s.totalDamageDealt
        );
    }
}
