package vn.dreamtech.game.server.pvp;

import vn.dreamtech.game.server.battle.BattleMode;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.battle.BattleStateView;
import vn.dreamtech.game.server.battle.BattleStatus;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.PvpMatchHistoryDao;
import vn.dreamtech.game.server.dao.PvpRankDao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import static vn.dreamtech.game.server.pvp.PvpConstants.*;

/**
 * PvP dạng "đấu song song không chung bàn cờ" (async score-attack) — server
 * này chỉ có REST polling, KHÔNG có WebSocket, nên 2 người chơi không thể
 * thao tác trên cùng 1 bàn cờ theo thời gian thực. Thay vào đó: ghép cặp,
 * mỗi bên tự chơi độc lập trong giới hạn {@value vn.dreamtech.game.server.battle.BattleConstants#PVP_MOVE_LIMIT}
 * lượt (địch gần như bất tử — xem {@code PvpFightDef}), ai tổng sát thương
 * cao hơn thắng. Ghép cặp CHỈ 1 vị trí chờ (MVP, chưa phải hàng đợi thật —
 * TODO nâng cấp khi cần ghép theo rating/nhiều người chờ cùng lúc).
 */
public final class PvpService {
    private final CharacterDao characterDao;
    private final BattleService battleService;
    private final PvpRankDao rankDao;
    private final PvpMatchHistoryDao historyDao;

    private final Map<String, PvpMatch> matches = new ConcurrentHashMap<>();
    private final Map<Integer, String> userActiveMatch = new ConcurrentHashMap<>();
    private final Set<String> reportedBattles = ConcurrentHashMap.newKeySet();
    private Integer waitingUserId;

    public PvpService(CharacterDao characterDao, BattleService battleService, PvpRankDao rankDao, PvpMatchHistoryDao historyDao) {
        this.characterDao = characterDao;
        this.battleService = battleService;
        this.rankDao = rankDao;
        this.historyDao = historyDao;
    }

    public synchronized QueueJoinView joinQueue(int userId) {
        try {
            if (characterDao.findByUserId(userId).isEmpty()) {
                throw new PvpException(404, "Chưa tạo nhân vật");
            }
        } catch (SQLException e) {
            throw new PvpException(500, "Lỗi kiểm tra nhân vật: " + e.getMessage());
        }
        PvpMatch existing = anyMatchOf(userId);
        if (existing != null && existing.status == PvpMatchStatus.ONGOING) {
            throw new PvpException(409, "Đang có trận PvP chưa xong");
        }
        if (waitingUserId != null && waitingUserId == userId) {
            throw new PvpException(409, "Đã trong hàng chờ rồi");
        }
        if (waitingUserId != null) {
            int opponent = waitingUserId;
            waitingUserId = null;
            String matchId = UUID.randomUUID().toString();
            PvpMatch match = new PvpMatch(matchId, opponent, userId);
            matches.put(matchId, match);
            userActiveMatch.put(opponent, matchId);
            userActiveMatch.put(userId, matchId);
            return new QueueJoinView(true, matchId, opponent);
        }
        waitingUserId = userId;
        return new QueueJoinView(false, null, null);
    }

    public synchronized void leaveQueue(int userId) {
        if (waitingUserId == null || waitingUserId != userId) {
            throw new PvpException(404, "Không trong hàng chờ");
        }
        waitingUserId = null;
    }

    public BattleStateView startMatch(int userId, String matchId) {
        PvpMatch match = find(matchId);
        requireParticipant(match, userId);
        if (match.status != PvpMatchStatus.ONGOING) {
            throw new PvpException(409, "Trận đã kết thúc");
        }
        boolean isA = userId == match.playerA;
        String existingBattleId = isA ? match.battleIdA : match.battleIdB;
        if (existingBattleId != null) {
            throw new PvpException(409, "Đã bắt đầu trận cá nhân rồi");
        }
        BattleStateView view = battleService.startPvp(userId, new PvpFightDef("Đấu trường"));
        if (isA) {
            match.battleIdA = view.battleId();
        } else {
            match.battleIdB = view.battleId();
        }
        return view;
    }

    public PvpMatchView reportScore(int userId, String matchId, String battleId) {
        PvpMatch match = find(matchId);
        requireParticipant(match, userId);
        BattleStateView view = battleService.getState(battleId);
        if (view.userId() != userId) {
            throw new PvpException(403, "Trận đấu không thuộc về bạn");
        }
        if (view.mode() != BattleMode.PVP) {
            throw new PvpException(400, "Không phải trận PvP");
        }
        if (view.status() == BattleStatus.ONGOING) {
            throw new PvpException(409, "Trận cá nhân chưa xong (chưa hết lượt)");
        }
        if (!reportedBattles.add(battleId)) {
            throw new PvpException(409, "Trận đấu này đã được báo cáo rồi");
        }
        synchronized (match) {
            boolean isA = userId == match.playerA;
            if (isA) {
                match.scoreA = view.totalDamageDealt();
            } else {
                match.scoreB = view.totalDamageDealt();
            }
            if (match.bothScored() && match.status == PvpMatchStatus.ONGOING) {
                resolveMatch(match);
            }
        }
        return toView(match);
    }

    public PvpMatchView matchStatus(String matchId) {
        return toView(find(matchId));
    }

    public Optional<PvpMatchView> myMatch(int userId) {
        PvpMatch match = anyMatchOf(userId);
        return match == null ? Optional.empty() : Optional.of(toView(match));
    }

    public PvpRankView rank(int userId) {
        try {
            var r = rankDao.find(userId);
            return new PvpRankView(r.userId(), r.rating(), r.wins(), r.losses(), r.draws());
        } catch (SQLException e) {
            throw new PvpException(500, "Lỗi lấy điểm rank: " + e.getMessage());
        }
    }

    public List<PvpLeaderboardEntry> leaderboard() {
        try {
            List<PvpLeaderboardEntry> entries = new ArrayList<>();
            int rank = 1;
            for (var r : rankDao.topByRating(20)) {
                entries.add(new PvpLeaderboardEntry(rank++, r.userId(), r.rating(), r.wins(), r.losses(), r.draws()));
            }
            return entries;
        } catch (SQLException e) {
            throw new PvpException(500, "Lỗi lấy bảng xếp hạng: " + e.getMessage());
        }
    }

    private void resolveMatch(PvpMatch match) {
        Integer winner;
        if (match.scoreA > match.scoreB) winner = match.playerA;
        else if (match.scoreB > match.scoreA) winner = match.playerB;
        else winner = null;

        try {
            if (winner == null) {
                applyResult(match.playerA, RATING_DRAW, "DRAW");
                applyResult(match.playerB, RATING_DRAW, "DRAW");
            } else {
                int loser = winner == match.playerA ? match.playerB : match.playerA;
                applyResult(winner, RATING_WIN, "WIN");
                applyResult(loser, RATING_LOSS, "LOSS");
            }
            historyDao.record(match.id, match.playerA, match.playerB, match.scoreA, match.scoreB, winner);
        } catch (SQLException e) {
            throw new PvpException(500, "Lỗi lưu kết quả PvP: " + e.getMessage());
        }
        match.status = PvpMatchStatus.RESOLVED;
        match.winnerUserId = winner;
    }

    private void applyResult(int userId, int ratingDelta, String outcome) throws SQLException {
        var r = rankDao.find(userId);
        int newRating = Math.max(MIN_RATING, r.rating() + ratingDelta);
        int wins = r.wins() + (outcome.equals("WIN") ? 1 : 0);
        int losses = r.losses() + (outcome.equals("LOSS") ? 1 : 0);
        int draws = r.draws() + (outcome.equals("DRAW") ? 1 : 0);
        rankDao.save(new PvpRankDao.Rank(userId, newRating, wins, losses, draws));
    }

    private PvpMatch anyMatchOf(int userId) {
        String matchId = userActiveMatch.get(userId);
        if (matchId == null) return null;
        return matches.get(matchId);
    }

    private PvpMatch find(String matchId) {
        PvpMatch match = matches.get(matchId);
        if (match == null) throw new PvpException(404, "Không tìm thấy trận PvP");
        return match;
    }

    private void requireParticipant(PvpMatch match, int userId) {
        if (!match.isParticipant(userId)) {
            throw new PvpException(403, "Không phải trận của bạn");
        }
    }

    private PvpMatchView toView(PvpMatch m) {
        return new PvpMatchView(m.id, m.playerA, m.playerB, m.scoreA, m.scoreB, m.status, m.winnerUserId);
    }
}
