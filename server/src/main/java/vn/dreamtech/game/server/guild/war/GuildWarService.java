package vn.dreamtech.game.server.guild.war;

import vn.dreamtech.game.server.battle.BattleMode;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.battle.BattleStateView;
import vn.dreamtech.game.server.battle.BattleStatus;
import vn.dreamtech.game.server.dao.GuildDao;
import vn.dreamtech.game.server.dao.GuildMemberDao;
import vn.dreamtech.game.server.dao.GuildWarAttemptDao;
import vn.dreamtech.game.server.dao.GuildWarDao;
import vn.dreamtech.game.server.guild.GuildException;
import vn.dreamtech.game.server.model.Guild;
import vn.dreamtech.game.server.model.GuildMembership;
import vn.dreamtech.game.server.model.GuildRole;

import java.sql.SQLException;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import static vn.dreamtech.game.server.guild.war.GuildWarConstants.WAR_DURATION_MS;

/**
 * Guild War — 2 guild tuyên chiến, thành viên mỗi bên đánh 1 "bản sao" cá
 * nhân (giống Guild Boss/PvP), tổng sát thương cộng dồn vào điểm CHUNG của
 * guild mình. Hết {@value GuildWarConstants#WAR_DURATION_MS} ms, guild điểm
 * cao hơn thắng — không có reset chu kỳ như Guild Boss, mỗi cuộc chiến là
 * 1 sự kiện MỘT LẦN (muốn đánh nữa phải tuyên chiến mới).
 */
public final class GuildWarService {
    private final GuildDao guildDao;
    private final GuildMemberDao guildMemberDao;
    private final GuildWarDao warDao;
    private final GuildWarAttemptDao attemptDao;
    private final BattleService battleService;
    private final Set<String> reportedBattles = ConcurrentHashMap.newKeySet();

    public GuildWarService(GuildDao guildDao, GuildMemberDao guildMemberDao, GuildWarDao warDao,
                            GuildWarAttemptDao attemptDao, BattleService battleService) {
        this.guildDao = guildDao;
        this.guildMemberDao = guildMemberDao;
        this.warDao = warDao;
        this.attemptDao = attemptDao;
        this.battleService = battleService;
    }

    public GuildWarView declare(int userId, int targetGuildId) {
        try {
            GuildMembership membership = guildMemberDao.findByUserId(userId)
                    .orElseThrow(() -> new GuildException(404, "Chưa vào guild nào"));
            if (membership.role() == GuildRole.MEMBER) {
                throw new GuildException(403, "Chỉ hội trưởng/phó mới tuyên chiến được");
            }
            if (membership.guildId() == targetGuildId) {
                throw new GuildException(400, "Không thể tuyên chiến với chính guild mình");
            }
            Guild target = guildDao.findById(targetGuildId)
                    .orElseThrow(() -> new GuildException(404, "Không tìm thấy guild đối phương"));
            requireNoActiveWar(membership.guildId());
            requireNoActiveWar(target.id());

            long now = System.currentTimeMillis();
            String warId = UUID.randomUUID().toString();
            GuildWarDao.War war = new GuildWarDao.War(warId, membership.guildId(), target.id(), 0, 0,
                    "ONGOING", now, now + WAR_DURATION_MS, null);
            warDao.create(war);
            return toView(war);
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi tuyên chiến: " + e.getMessage());
        }
    }

    public BattleStateView attack(int userId) {
        try {
            GuildMembership membership = guildMemberDao.findByUserId(userId)
                    .orElseThrow(() -> new GuildException(404, "Chưa vào guild nào"));
            GuildWarDao.War war = activeWarOrThrow(membership.guildId());
            if (attemptDao.hasAttempted(userId, war.id())) {
                throw new GuildException(409, "Bạn đã đánh trong cuộc chiến này rồi");
            }
            attemptDao.recordAttempt(userId, war.id());
            return battleService.startGuildWar(userId, new GuildWarFightDef("Chiến trường Guild War"));
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi bắt đầu đánh Guild War: " + e.getMessage());
        }
    }

    public GuildWarView report(int userId, String battleId) {
        BattleStateView view = battleService.getState(battleId);
        if (view.userId() != userId) {
            throw new GuildException(403, "Trận đấu không thuộc về bạn");
        }
        if (view.mode() != BattleMode.GUILD_WAR) {
            throw new GuildException(400, "Không phải trận Guild War");
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
            GuildWarDao.War war = activeWarOrThrow(membership.guildId());
            int damage = view.totalDamageDealt();
            GuildWarDao.War updated = membership.guildId() == war.guildA()
                    ? new GuildWarDao.War(war.id(), war.guildA(), war.guildB(), war.scoreA() + damage, war.scoreB(), war.status(), war.startedAt(), war.endsAt(), war.winnerGuildId())
                    : new GuildWarDao.War(war.id(), war.guildA(), war.guildB(), war.scoreA(), war.scoreB() + damage, war.status(), war.startedAt(), war.endsAt(), war.winnerGuildId());
            warDao.save(updated);
            return toView(resolveIfExpired(updated));
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi báo cáo kết quả Guild War: " + e.getMessage());
        }
    }

    public GuildWarView status(int guildId) {
        try {
            GuildWarDao.War war = warDao.findLatestByGuild(guildId)
                    .orElseThrow(() -> new GuildException(404, "Guild này chưa từng tham gia Guild War"));
            return toView(resolveIfExpired(war));
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi lấy trạng thái Guild War: " + e.getMessage());
        }
    }

    public GuildWarView myWar(int userId) {
        try {
            GuildMembership membership = guildMemberDao.findByUserId(userId)
                    .orElseThrow(() -> new GuildException(404, "Chưa vào guild nào"));
            return status(membership.guildId());
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi lấy Guild War của guild bạn: " + e.getMessage());
        }
    }

    private void requireNoActiveWar(int guildId) throws SQLException {
        if (warDao.findActiveByGuild(guildId).isPresent()) {
            throw new GuildException(409, "Guild đang trong 1 cuộc chiến khác chưa kết thúc");
        }
    }

    private GuildWarDao.War activeWarOrThrow(int guildId) throws SQLException {
        GuildWarDao.War war = warDao.findActiveByGuild(guildId)
                .orElseThrow(() -> new GuildException(404, "Guild bạn không trong cuộc chiến nào"));
        GuildWarDao.War resolved = resolveIfExpired(war);
        if (!"ONGOING".equals(resolved.status())) {
            throw new GuildException(409, "Cuộc chiến đã kết thúc");
        }
        return resolved;
    }

    private GuildWarDao.War resolveIfExpired(GuildWarDao.War war) throws SQLException {
        if (!"ONGOING".equals(war.status()) || System.currentTimeMillis() < war.endsAt()) {
            return war;
        }
        Integer winner;
        if (war.scoreA() > war.scoreB()) winner = war.guildA();
        else if (war.scoreB() > war.scoreA()) winner = war.guildB();
        else winner = null;
        GuildWarDao.War resolved = new GuildWarDao.War(war.id(), war.guildA(), war.guildB(), war.scoreA(), war.scoreB(),
                "RESOLVED", war.startedAt(), war.endsAt(), winner);
        warDao.save(resolved);
        return resolved;
    }

    private GuildWarView toView(GuildWarDao.War war) {
        return new GuildWarView(war.id(), war.guildA(), war.guildB(), war.scoreA(), war.scoreB(),
                war.status(), war.startedAt(), war.endsAt(), war.winnerGuildId());
    }
}
