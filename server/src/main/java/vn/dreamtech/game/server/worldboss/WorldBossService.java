package vn.dreamtech.game.server.worldboss;

import vn.dreamtech.game.server.battle.BattleMode;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.battle.BattleStateView;
import vn.dreamtech.game.server.battle.BattleStatus;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.dao.WorldBossAttemptDao;
import vn.dreamtech.game.server.dao.WorldBossContributionDao;
import vn.dreamtech.game.server.dao.WorldBossCycleDao;
import vn.dreamtech.game.server.guild.boss.AttackStatusView;
import vn.dreamtech.game.server.guild.boss.GuildBossLeaderboardEntry;
import vn.dreamtech.game.server.guild.boss.GuildBossReportView;
import vn.dreamtech.game.server.level.LevelService;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import static vn.dreamtech.game.server.worldboss.WorldBossConstants.*;

/**
 * World Boss — cùng cơ chế "bản sao cá nhân + report đồng bộ" như
 * {@code GuildBossService}, nhưng HP CHUNG dùng cho TOÀN SERVER (1 dòng
 * duy nhất, không theo guild) và KHÔNG yêu cầu ở guild nào — chỉ cần đã
 * tạo nhân vật. Dùng lại {@code GuildBossReportView}/
 * {@code GuildBossLeaderboardEntry}/{@code AttackStatusView} từ
 * {@code guild.boss} vì hình dạng dữ liệu giống hệt, tránh trùng lặp record.
 */
public final class WorldBossService {
    private final CharacterDao characterDao;
    private final WorldBossCycleDao cycleDao;
    private final WorldBossAttemptDao attemptDao;
    private final WorldBossContributionDao contributionDao;
    private final BattleService battleService;
    private final LevelDao levelDao;
    private final WalletDao walletDao;
    private final Set<String> reportedBattles = ConcurrentHashMap.newKeySet();

    public WorldBossService(CharacterDao characterDao, WorldBossCycleDao cycleDao, WorldBossAttemptDao attemptDao,
                             WorldBossContributionDao contributionDao, BattleService battleService,
                             LevelDao levelDao, WalletDao walletDao) {
        this.characterDao = characterDao;
        this.cycleDao = cycleDao;
        this.attemptDao = attemptDao;
        this.contributionDao = contributionDao;
        this.battleService = battleService;
        this.levelDao = levelDao;
        this.walletDao = walletDao;
    }

    public BattleStateView attack(int userId) {
        try {
            if (characterDao.findByUserId(userId).isEmpty()) {
                throw new WorldBossException(404, "Chưa tạo nhân vật");
            }
            WorldBossCycleDao.Cycle cycle = getOrResetCycle();
            if (cycle.remainingHp() <= 0) {
                throw new WorldBossException(409, "Trùm thế giới đã bị hạ gục trong chu kỳ này");
            }
            Optional<Long> attempted = attemptDao.findAttemptedCycle(userId);
            if (attempted.isPresent() && attempted.get() == cycle.cycleStartedAt()) {
                throw new WorldBossException(409, "Bạn đã đánh trong chu kỳ này rồi");
            }
            attemptDao.recordAttempt(userId, cycle.cycleStartedAt());
            return battleService.startWorldBoss(userId, new WorldBossFightDef("Trùm Thế Giới"));
        } catch (SQLException e) {
            throw new WorldBossException(500, "Lỗi bắt đầu đánh trùm thế giới: " + e.getMessage());
        }
    }

    public GuildBossReportView report(int userId, String battleId) {
        BattleStateView view = battleService.getState(battleId);
        if (view.userId() != userId) {
            throw new WorldBossException(403, "Trận đấu không thuộc về bạn");
        }
        if (view.mode() != BattleMode.WORLD_BOSS) {
            throw new WorldBossException(400, "Không phải trận đánh trùm thế giới");
        }
        if (view.status() == BattleStatus.ONGOING) {
            throw new WorldBossException(409, "Trận đấu chưa kết thúc");
        }
        if (!reportedBattles.add(battleId)) {
            throw new WorldBossException(409, "Trận đấu này đã được báo cáo rồi");
        }
        try {
            WorldBossCycleDao.Cycle cycle = getOrResetCycle();
            int damageApplied = Math.min(view.totalDamageDealt(), cycle.remainingHp());
            int newRemaining = cycle.remainingHp() - damageApplied;
            cycleDao.save(new WorldBossCycleDao.Cycle(newRemaining, cycle.cycleStartedAt(), cycle.cycleEndsAt()));

            int rewardExp = 0;
            int rewardGold = 0;
            if (damageApplied > 0) {
                contributionDao.addDamage(userId, cycle.cycleStartedAt(), damageApplied);
                var levelInfo = levelDao.find(userId);
                levelDao.save(LevelService.addExp(levelInfo, REWARD_EXP));
                walletDao.addGold(userId, REWARD_GOLD);
                rewardExp = REWARD_EXP;
                rewardGold = REWARD_GOLD;
            }
            return new GuildBossReportView(damageApplied, newRemaining, newRemaining <= 0, rewardExp, rewardGold);
        } catch (SQLException e) {
            throw new WorldBossException(500, "Lỗi báo cáo kết quả: " + e.getMessage());
        }
    }

    public WorldBossStatusView status() {
        try {
            WorldBossCycleDao.Cycle cycle = getOrResetCycle();
            return new WorldBossStatusView(cycle.remainingHp(), POOL_HP, cycle.cycleStartedAt(), cycle.cycleEndsAt());
        } catch (SQLException e) {
            throw new WorldBossException(500, "Lỗi lấy trạng thái trùm thế giới: " + e.getMessage());
        }
    }

    public AttackStatusView attackStatus(int userId) {
        try {
            if (characterDao.findByUserId(userId).isEmpty()) {
                return new AttackStatusView(false, "Chưa tạo nhân vật");
            }
            WorldBossCycleDao.Cycle cycle = getOrResetCycle();
            if (cycle.remainingHp() <= 0) {
                return new AttackStatusView(false, "Trùm thế giới đã bị hạ gục trong chu kỳ này");
            }
            Optional<Long> attempted = attemptDao.findAttemptedCycle(userId);
            if (attempted.isPresent() && attempted.get() == cycle.cycleStartedAt()) {
                return new AttackStatusView(false, "Đã đánh trong chu kỳ này rồi");
            }
            return new AttackStatusView(true, null);
        } catch (SQLException e) {
            throw new WorldBossException(500, "Lỗi kiểm tra lượt đánh: " + e.getMessage());
        }
    }

    public List<GuildBossLeaderboardEntry> leaderboard() {
        try {
            WorldBossCycleDao.Cycle cycle = getOrResetCycle();
            List<WorldBossContributionDao.Contribution> contributions = contributionDao.listByCycle(cycle.cycleStartedAt());
            List<GuildBossLeaderboardEntry> entries = new ArrayList<>();
            int rank = 1;
            for (WorldBossContributionDao.Contribution c : contributions) {
                entries.add(new GuildBossLeaderboardEntry(rank++, c.userId(), c.totalDamage()));
            }
            return entries;
        } catch (SQLException e) {
            throw new WorldBossException(500, "Lỗi lấy bảng đóng góp: " + e.getMessage());
        }
    }

    /** GM buộc kết thúc chu kỳ hiện tại và bắt đầu chu kỳ mới ngay lập tức (VD: chu kỳ bị kẹt do lỗi). */
    public WorldBossStatusView adminForceReset() {
        try {
            long now = System.currentTimeMillis();
            WorldBossCycleDao.Cycle fresh = new WorldBossCycleDao.Cycle(POOL_HP, now, now + CYCLE_MS);
            cycleDao.save(fresh);
            return new WorldBossStatusView(fresh.remainingHp(), POOL_HP, fresh.cycleStartedAt(), fresh.cycleEndsAt());
        } catch (SQLException e) {
            throw new WorldBossException(500, "Lỗi reset chu kỳ trùm thế giới: " + e.getMessage());
        }
    }

    private WorldBossCycleDao.Cycle getOrResetCycle() throws SQLException {
        Optional<WorldBossCycleDao.Cycle> existing = cycleDao.find();
        long now = System.currentTimeMillis();
        if (existing.isEmpty() || now > existing.get().cycleEndsAt()) {
            WorldBossCycleDao.Cycle fresh = new WorldBossCycleDao.Cycle(POOL_HP, now, now + CYCLE_MS);
            cycleDao.save(fresh);
            return fresh;
        }
        return existing.get();
    }
}
