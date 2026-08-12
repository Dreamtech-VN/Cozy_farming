using System.Collections.Generic;
using System.Threading.Tasks;

public static class PvpService
{
    public static Task<QueueJoinResponse> JoinQueue()
    {
        return ApiClient.PostAsync<QueueJoinResponse>("/api/pvp/queue/join", new { userId = Session.UserId });
    }

    public static Task LeaveQueue()
    {
        return ApiClient.PostAsync<object>("/api/pvp/queue/leave", new { userId = Session.UserId });
    }

    public static Task<BattleStateView> StartMatch(string matchId)
    {
        return ApiClient.PostAsync<BattleStateView>("/api/pvp/match/start", new
        {
            userId = Session.UserId,
            matchId,
        });
    }

    public static Task<PvpMatchResponse> ReportScore(string matchId, string battleId)
    {
        return ApiClient.PostAsync<PvpMatchResponse>("/api/pvp/match/report", new
        {
            userId = Session.UserId,
            matchId,
            battleId,
        });
    }

    public static async Task<PvpMatchResponse> GetMyMatchOrNull()
    {
        try
        {
            return await ApiClient.GetAsync<PvpMatchResponse>($"/api/pvp/match/my?userId={Session.UserId}");
        }
        catch (ApiException e) when (e.StatusCode == 404)
        {
            return null;
        }
    }

    public static Task<PvpMatchResponse> GetMatchStatus(string matchId)
    {
        return ApiClient.GetAsync<PvpMatchResponse>($"/api/pvp/match/status?matchId={matchId}");
    }

    public static Task<PvpRankResponse> GetRank()
    {
        return ApiClient.GetAsync<PvpRankResponse>($"/api/pvp/rank?userId={Session.UserId}");
    }

    public static Task<List<PvpLeaderboardEntryResponse>> GetLeaderboard()
    {
        return ApiClient.GetAsync<List<PvpLeaderboardEntryResponse>>("/api/pvp/leaderboard");
    }
}
