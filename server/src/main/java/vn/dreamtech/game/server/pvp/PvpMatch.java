package vn.dreamtech.game.server.pvp;

/** Trạng thái 1 trận PvP đang diễn ra — giữ trong bộ nhớ, giống {@code BattleSession}. Chỉ kết quả cuối mới ghi DB (xem {@code PvpMatchHistoryDao}). */
final class PvpMatch {
    final String id;
    final int playerA;
    final int playerB;

    String battleIdA;
    String battleIdB;
    Integer scoreA;
    Integer scoreB;
    PvpMatchStatus status = PvpMatchStatus.ONGOING;
    Integer winnerUserId; // null nếu chưa xong HOẶC hoà

    PvpMatch(String id, int playerA, int playerB) {
        this.id = id;
        this.playerA = playerA;
        this.playerB = playerB;
    }

    boolean isParticipant(int userId) {
        return userId == playerA || userId == playerB;
    }

    boolean bothScored() {
        return scoreA != null && scoreB != null;
    }
}
