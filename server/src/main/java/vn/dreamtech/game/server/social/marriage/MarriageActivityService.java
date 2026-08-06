package vn.dreamtech.game.server.social.marriage;

import vn.dreamtech.game.server.battle.BattleMode;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.battle.BattleStateView;
import vn.dreamtech.game.server.battle.BattleStatus;
import vn.dreamtech.game.server.dao.FriendshipDao;
import vn.dreamtech.game.server.dao.MarriageActivityDao;
import vn.dreamtech.game.server.dao.MarriageDao;
import vn.dreamtech.game.server.dao.PresenceDao;
import vn.dreamtech.game.server.guild.GuildException;

import java.sql.SQLException;
import java.util.Optional;

import static vn.dreamtech.game.server.social.marriage.MarriageActivityConstants.COOP_BATTLE_INTIMACY;
import static vn.dreamtech.game.server.social.marriage.MarriageActivityConstants.COOP_BATTLE_WINDOW_MS;
import static vn.dreamtech.game.server.social.marriage.MarriageActivityConstants.DUO_QUEST_COOLDOWN_MS;
import static vn.dreamtech.game.server.social.marriage.MarriageActivityConstants.DUO_QUEST_INTIMACY;
import static vn.dreamtech.game.server.social.marriage.MarriageActivityConstants.ONLINE_TICK_COOLDOWN_MS;
import static vn.dreamtech.game.server.social.marriage.MarriageActivityConstants.ONLINE_TICK_INTIMACY;

/**
 * Nguồn điểm thân mật SAU KHI CƯỚI, ngoài quà tặng ({@code SendGiftHandler}):
 * online cùng nhau, nhiệm vụ đôi hàng ngày, và trận đánh hợp tác. Dùng
 * {@link GuildException} (400/403/404/409) để tái dùng {@code JsonHttp}
 * error-mapping sẵn có — không thêm exception type mới chỉ để đổi tên.
 */
public final class MarriageActivityService {
    private final MarriageDao marriageDao;
    private final MarriageActivityDao activityDao;
    private final FriendshipDao friendshipDao;
    private final PresenceDao presenceDao;
    private final BattleService battleService;

    public MarriageActivityService(MarriageDao marriageDao, MarriageActivityDao activityDao, FriendshipDao friendshipDao,
                                    PresenceDao presenceDao, BattleService battleService) {
        this.marriageDao = marriageDao;
        this.activityDao = activityDao;
        this.friendshipDao = friendshipDao;
        this.presenceDao = presenceDao;
        this.battleService = battleService;
    }

    public record ActivityResult(boolean awarded, int intimacyPoints, String reason) {
    }

    public record CoopReportResult(int damageDealt, boolean bonusAwarded, int intimacyPoints) {
    }

    public ActivityResult onlineTick(int userId) {
        try {
            int spouse = requireSpouse(userId);
            long now = System.currentTimeMillis();
            if (!bothOnline(userId, spouse, now)) {
                return new ActivityResult(false, currentIntimacy(userId, spouse), "Vợ/chồng chưa online");
            }
            activityDao.ensureRow(userId, spouse);
            var activity = activityDao.find(userId, spouse).orElseThrow();
            if (activity.lastOnlineTickAt() != null && now - activity.lastOnlineTickAt() < ONLINE_TICK_COOLDOWN_MS) {
                return new ActivityResult(false, currentIntimacy(userId, spouse), "Vừa cộng điểm gần đây rồi, chờ chút");
            }
            friendshipDao.addIntimacy(userId, spouse, ONLINE_TICK_INTIMACY, now);
            activityDao.updateOnlineTick(userId, spouse, now);
            return new ActivityResult(true, currentIntimacy(userId, spouse), null);
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi cộng điểm online cùng nhau: " + e.getMessage());
        }
    }

    public ActivityResult claimDuoQuest(int userId) {
        try {
            int spouse = requireSpouse(userId);
            long now = System.currentTimeMillis();
            if (!bothOnline(userId, spouse, now)) {
                throw new GuildException(409, "Cả 2 vợ chồng phải đang online mới nhận nhiệm vụ đôi được");
            }
            activityDao.ensureRow(userId, spouse);
            var activity = activityDao.find(userId, spouse).orElseThrow();
            if (activity.lastDuoQuestAt() != null && now - activity.lastDuoQuestAt() < DUO_QUEST_COOLDOWN_MS) {
                throw new GuildException(409, "Hôm nay đã nhận nhiệm vụ đôi rồi");
            }
            friendshipDao.addIntimacy(userId, spouse, DUO_QUEST_INTIMACY, now);
            activityDao.updateDuoQuest(userId, spouse, now);
            return new ActivityResult(true, currentIntimacy(userId, spouse), null);
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi nhận nhiệm vụ đôi: " + e.getMessage());
        }
    }

    public BattleStateView startCoopBattle(int userId) {
        requireSpouse(userId);
        return battleService.startMarriageCoop(userId, new MarriageCoopFightDef("Trận hợp tác vợ chồng"));
    }

    public CoopReportResult reportCoopBattle(int userId, String battleId) {
        BattleStateView view = battleService.getState(battleId);
        if (view.userId() != userId) {
            throw new GuildException(403, "Trận đấu không thuộc về bạn");
        }
        if (view.mode() != BattleMode.MARRIAGE_COOP) {
            throw new GuildException(400, "Không phải trận hợp tác vợ chồng");
        }
        if (view.status() == BattleStatus.ONGOING) {
            throw new GuildException(409, "Trận đấu chưa kết thúc");
        }
        try {
            int spouse = requireSpouse(userId);
            long now = System.currentTimeMillis();
            activityDao.ensureRow(userId, spouse);
            activityDao.updateCoopCompleted(userId, spouse, userId, now);
            var activity = activityDao.find(userId, spouse).orElseThrow();

            Long myCompletedAt = now;
            Long spouseCompletedAt = spouseCompletedAt(activity, userId, spouse);
            boolean bothWithinWindow = spouseCompletedAt != null && Math.abs(myCompletedAt - spouseCompletedAt) <= COOP_BATTLE_WINDOW_MS;
            boolean alreadyAwardedThisRound = activity.coopLastAwardedAt() != null && spouseCompletedAt != null
                    && activity.coopLastAwardedAt() >= spouseCompletedAt;

            boolean bonusAwarded = bothWithinWindow && !alreadyAwardedThisRound;
            if (bonusAwarded) {
                friendshipDao.addIntimacy(userId, spouse, COOP_BATTLE_INTIMACY, now);
                activityDao.updateCoopAwarded(userId, spouse, now);
            }
            return new CoopReportResult(view.totalDamageDealt(), bonusAwarded, currentIntimacy(userId, spouse));
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi báo cáo trận hợp tác: " + e.getMessage());
        }
    }

    private Long spouseCompletedAt(MarriageActivityDao.Activity activity, int userId, int spouse) {
        int[] pair = userId < spouse ? new int[]{userId, spouse} : new int[]{spouse, userId};
        boolean userIsA = userId == pair[0];
        return userIsA ? activity.coopBCompletedAt() : activity.coopACompletedAt();
    }

    private int requireSpouse(int userId) {
        try {
            Optional<Integer> spouse = marriageDao.findSpouse(userId);
            return spouse.orElseThrow(() -> new GuildException(404, "Chưa kết hôn"));
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi kiểm tra hôn nhân: " + e.getMessage());
        }
    }

    private boolean bothOnline(int userId, int spouse, long now) throws SQLException {
        var active = presenceDao.listActive(now, PresenceDao.ONLINE_WINDOW_MS);
        boolean userOnline = active.stream().anyMatch(p -> p.userId() == userId);
        boolean spouseOnline = active.stream().anyMatch(p -> p.userId() == spouse);
        return userOnline && spouseOnline;
    }

    private int currentIntimacy(int userA, int userB) throws SQLException {
        return friendshipDao.find(userA, userB).map(f -> f.intimacyPoints()).orElse(0);
    }
}
