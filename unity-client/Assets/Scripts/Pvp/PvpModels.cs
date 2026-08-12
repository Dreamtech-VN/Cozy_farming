using System;

[Serializable]
public class QueueJoinResponse
{
    public bool matched;
    public string matchId;
    public int? opponentUserId;
}

[Serializable]
public class PvpMatchResponse
{
    public string matchId;
    public int playerA;
    public int playerB;
    public int? scoreA;
    public int? scoreB;
    public string status; // "ONGOING", "RESOLVED"
    public int? winnerUserId; // null = hoà (chỉ có ý nghĩa khi status == RESOLVED)
}

[Serializable]
public class PvpRankResponse
{
    public int userId;
    public int rating;
    public int wins;
    public int losses;
    public int draws;
}

[Serializable]
public class PvpLeaderboardEntryResponse
{
    public int rank;
    public int userId;
    public int rating;
    public int wins;
    public int losses;
    public int draws;
}
