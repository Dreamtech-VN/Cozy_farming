package vn.dreamtech.game.server.guild.boss;

import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.battle.BattleStateView;
import vn.dreamtech.game.server.battle.BattleMode;
import vn.dreamtech.game.server.battle.BattleStatus;
import vn.dreamtech.game.server.dao.GuildBossAttemptDao;
import vn.dreamtech.game.server.dao.GuildBossContributionDao;
import vn.dreamtech.game.server.dao.GuildBossCycleDao;
import vn.dreamtech.game.server.dao.GuildMemberDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.guild.GuildException;
import vn.dreamtech.game.server.level.LevelService;
import vn.dreamtech.game.server.model.GuildMembership;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import static vn.dreamtech.game.server.guild.boss.GuildBossConstants.*;

/**
 * Guild Boss: mỗi thành viên đánh 1 "bản sao" cá nhân của trùm
 * ({@link GuildBossFightDef}, HP cố định {@value GuildBossConstants#PERSONAL_ENGAGE_HP}),
 * sát thương gây ra chỉ áp dụng vào HP CHUNG của guild sau khi trận kết
 * thúc, qua {@link #report}. Mỗi thành viên chỉ đánh được 1 lần/chu kỳ
 * (24h, tự reset khi hết hạn — không cron). Thưởng phát ngay lúc report,
 * KHÔNG qua cơ chế thưởng của {@code BattleService}.
 */
public final class GuildBossService {
    private final GuildMemberDao guildMemberDao;
    private final GuildBossCycleDao cycleDao;
    private final GuildBossAttemptDao attemptDao;
    private final GuildBossContributionDao contributionDao;
    private final BattleService battleService;
    private final LevelDao levelDao;
    private final WalletDao walletDao;
    private final Set<String> reportedBattles = ConcurrentHashMap.newKeySet();

    public GuildBossService(GuildMemberDao guildMemberDao, GuildBossCycleDao cycleDao, GuildBossAttemptDao attemptDao,
                             GuildBossContributionDao contributionDao, BattleService battleService,
                             LevelDao levelDao, WalletDao walletDao) {
        this.guildMemberDao = guildMemberDao;
        this.cycleDao = cycleDao;
        this.attemptDao = attemptDao;
        this.contributionDao = contributionDao;
        this.battleService = battleService;
        this.levelDao = levelDao;
        this.walletDao = walletDao;
    }

    public BattleStateView attack(int userId) {
        try {
            GuildMembership membership = guildMemberDao.findByUserId(userId)
                    .orElseThrow(() -> new GuildException(404, "Chưa vào guild nào"));
            GuildBossCycleDao.Cycle cycle = getOrResetCycle(membership.guildId());
            if (cycle.remainingHp() <= 0) {
                throw new GuildException(409, "Trùm guild đã bị hạ gục trong chu kỳ này");
            }
            Optional<Long> attempted = attemptDao.findAttemptedCycle(userId);
            if (attempted.isPresent() && attempted.get() == cycle.cycleStartedAt()) {
                throw new GuildException(409, "Bạn đã đánh trong chu kỳ này rồi");
            }
            attemptDao.recordAttempt(userId, cycle.cycleStartedAt());
            return battleService.startGuildBoss(userId, new GuildBossFightDef("Trùm Guild"));
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi bắt đầu đánh trùm guild: " + e.getMessage());
        }
    }

    public GuildBossReportView report(int userId, String battleId) {
        BattleStateView view = battleService.getState(battleId);
        if (view.userId() != userId) {
            throw new GuildException(403, "Trận đấu không thuộc về bạn");
        }
        if (view.mode() != BattleMode.GUILD_BOSS) {
            throw new GuildException(400, "Không phải trận đánh trùm guild");
        }
        if (view.status() == BattleStatus.ONGOING) {
            throw new GuildException(409, "Trận đấu chưa kết thúc");
        }
        if (!reportedBattles.add(battleId)) {
            throw new GuildException(409, "Trận đấu này đã được báo cáo rồi");
        }
        try {
            GuildMembership membership = guildMemberDao.findByUserId(userId)
                    .orElseThrow(() -> new GuildException(404, "Chưa vào guild nào"));
            GuildBossCycleDao.Cycle cycle = getOrResetCycle(membership.guildId());
            int damageApplied = Math.min(view.totalDamageDealt(), cycle.remainingHp());
            int newRemaining = cycle.remainingHp() - damageApplied;
            cycleDao.save(new GuildBossCycleDao.Cycle(cycle.guildId(), newRemaining, cycle.cycleStartedAt(), cycle.cycleEndsAt()));

            int rewardExp = 0;
            int rewardGold = 0;
            if (damageApplied > 0) {
                contributionDao.addDamage(membership.guildId(), userId, cycle.cycleStartedAt(), damageApplied);
                var levelInfo = levelDao.find(userId);
                levelDao.save(LevelService.addExp(levelInfo, REWARD_EXP));
                walletDao.addGold(userId, REWARD_GOLD);
                rewardExp = REWARD_EXP;
                rewardGold = REWARD_GOLD;
            }
            return new GuildBossReportView(damageApplied, newRemaining, newRemaining <= 0, rewardExp, rewardGold);
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi báo cáo kết quả: " + e.getMessage());
        }
    }

    public GuildBossStatusView status(int guildId) {
        try {
            GuildBossCycleDao.Cycle cycle = getOrResetCycle(guildId);
            return new GuildBossStatusView(guildId, cycle.remainingHp(), POOL_HP, cycle.cycleStartedAt(), cycle.cycleEndsAt());
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi lấy trạng thái trùm guild: " + e.getMessage());
        }
    }

    /** Bảng đóng góp sát thương của chu kỳ HIỆN TẠI (không phải lịch sử — chu kỳ cũ mất khỏi bảng khi chu kỳ mới bắt đầu). */
    public List<GuildBossLeaderboardEntry> leaderboard(int guildId) {
        try {
            GuildBossCycleDao.Cycle cycle = getOrResetCycle(guildId);
            List<GuildBossContributionDao.Contribution> contributions = contributionDao.listByCycle(guildId, cycle.cycleStartedAt());
            List<GuildBossLeaderboardEntry> entries = new ArrayList<>();
            int rank = 1;
            for (GuildBossContributionDao.Contribution c : contributions) {
                entries.add(new GuildBossLeaderboardEntry(rank++, c.userId(), c.totalDamage()));
            }
            return entries;
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi lấy bảng đóng góp: " + e.getMessage());
        }
    }

    public AttackStatusView attackStatus(int userId) {
        try {
            Optional<GuildMembership> membership = guildMemberDao.findByUserId(userId);
            if (membership.isEmpty()) {
                return new AttackStatusView(false, "Chưa vào guild nào");
            }
            GuildBossCycleDao.Cycle cycle = getOrResetCycle(membership.get().guildId());
            if (cycle.remainingHp() <= 0) {
                return new AttackStatusView(false, "Trùm guild đã bị hạ gục trong chu kỳ này");
            }
            Optional<Long> attempted = attemptDao.findAttemptedCycle(userId);
            if (attempted.isPresent() && attempted.get() == cycle.cycleStartedAt()) {
                return new AttackStatusView(false, "Đã đánh trong chu kỳ này rồi");
            }
            return new AttackStatusView(true, null);
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi kiểm tra lượt đánh: " + e.getMessage());
        }
    }

    private GuildBossCycleDao.Cycle getOrResetCycle(int guildId) throws SQLException {
        Optional<GuildBossCycleDao.Cycle> existing = cycleDao.find(guildId);
        long now = System.currentTimeMillis();
        if (existing.isEmpty() || now > existing.get().cycleEndsAt()) {
            GuildBossCycleDao.Cycle fresh = new GuildBossCycleDao.Cycle(guildId, POOL_HP, now, now + CYCLE_MS);
            cycleDao.save(fresh);
            return fresh;
        }
        return existing.get();
    }
}
