package vn.dreamtech.game.server.pvp;

public record PvpLeaderboardEntry(int rank, int userId, int rating, int wins, int losses, int draws) {
}
