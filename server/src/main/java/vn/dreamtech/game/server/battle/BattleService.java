package vn.dreamtech.game.server.battle;

import vn.dreamtech.game.server.battle.engine.BoardGenerator;
import vn.dreamtech.game.server.battle.engine.CascadeResolver;
import vn.dreamtech.game.server.battle.engine.CascadeResult;
import vn.dreamtech.game.server.battle.engine.ChainStep;
import vn.dreamtech.game.server.battle.engine.MatchFinder;
import vn.dreamtech.game.server.battle.engine.TileBoard;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.level.LevelService;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
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

    public BattleService(LevelDao levelDao, WalletDao walletDao) {
        this.levelDao = levelDao;
        this.walletDao = walletDao;
    }

    public BattleStateView startStory(int userId, int levelId) {
        StoryLevelDef level = StoryLevelCatalog.find(levelId)
                .orElseThrow(() -> new BattleException(404, "Không tìm thấy màn chơi"));
        Random random = new Random();
        TileBoard board = BoardGenerator.generate(BOARD_ROWS, BOARD_COLS, COLOR_COUNT, random);
        String id = UUID.randomUUID().toString();
        BattleSession session = new BattleSession(id, userId, level, board, random);
        sessions.put(id, session);
        return toView(session, false, false, 0, 0, 0, false);
    }

    public BattleStateView getState(String battleId) {
        return toView(find(battleId), false, false, 0, 0, 0, false);
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

        resolveOutcome(session);
        return toView(session, matched, critical, chainLevels, damageDealt, manaGained, enemyCountered);
    }

    public BattleStateView useUltimate(String battleId) {
        BattleSession session = find(battleId);
        requireOngoing(session);
        if (session.mana < MANA_MAX) {
            throw new BattleException(400, "Chưa đủ mana để dùng chiêu cuối");
        }
        session.mana = 0;
        session.enemyHp = Math.max(0, session.enemyHp - ULTIMATE_DAMAGE);
        resolveOutcome(session);
        return toView(session, false, false, 0, ULTIMATE_DAMAGE, 0, false);
    }

    private void resolveOutcome(BattleSession session) {
        if (session.status != BattleStatus.ONGOING) return;
        if (session.enemyHp <= 0) {
            session.status = BattleStatus.WON;
            grantRewardOnce(session);
        } else if (session.playerHp <= 0) {
            session.status = BattleStatus.LOST;
        }
    }

    private void grantRewardOnce(BattleSession session) {
        if (session.rewardGranted) return;
        session.rewardGranted = true;
        try {
            var levelInfo = levelDao.find(session.userId);
            levelDao.save(LevelService.addExp(levelInfo, session.level.rewardExp()));
            walletDao.addGold(session.userId, session.level.rewardGold());
        } catch (SQLException e) {
            throw new BattleException(500, "Lỗi phát thưởng: " + e.getMessage());
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
                                    int damageDealt, int manaGained, boolean enemyCountered) {
        List<BuffType> activeEffects = s.effects.stream().map(ActiveEffect::type).toList();
        return new BattleStateView(
                s.id, s.level.id(), s.status, s.board.toArray(),
                s.playerHp, PLAYER_HP_MAX, s.enemyHp, s.level.enemyHp(),
                s.mana, MANA_MAX, s.comboCount, activeEffects,
                matched, critical, chainLevels, damageDealt, manaGained,
                enemyCountered, s.level.enemyCounterDamage(),
                s.rewardGranted && s.status == BattleStatus.WON, s.level.rewardExp(), s.level.rewardGold()
        );
    }
}
