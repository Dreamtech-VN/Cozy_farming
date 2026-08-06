package vn.dreamtech.game.server.pvp;

public record PvpMatchView(String matchId, int playerA, int playerB, Integer scoreA, Integer scoreB,
                            PvpMatchStatus status, Integer winnerUserId) {
}
