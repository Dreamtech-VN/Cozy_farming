using System.Threading.Tasks;

public static class MarriageService
{
    // currency: "GOLD" hoặc "DIAMOND" (mua nhẫn cầu hôn)
    public static Task<MarriageProposalResponse> Propose(int toUserId, string currency)
    {
        return ApiClient.PostAsync<MarriageProposalResponse>("/api/marriage/propose", new
        {
            fromUserId = Session.UserId,
            toUserId,
            currency,
        });
    }

    public static Task Respond(long proposalId, bool accept)
    {
        return ApiClient.PostAsync<object>("/api/marriage/respond", new
        {
            proposalId,
            userId = Session.UserId,
            accept,
        });
    }

    public static Task<MarriageStatusResponse> Status()
    {
        return ApiClient.GetAsync<MarriageStatusResponse>($"/api/marriage/status?userId={Session.UserId}");
    }

    public static Task Divorce()
    {
        return ApiClient.PostAsync<object>("/api/marriage/divorce", new { userId = Session.UserId });
    }

    public static Task<MarriageActivityResponse> OnlineTick()
    {
        return ApiClient.PostAsync<MarriageActivityResponse>("/api/marriage/online-tick", new { userId = Session.UserId });
    }

    public static Task<MarriageActivityResponse> ClaimDuoQuest()
    {
        return ApiClient.PostAsync<MarriageActivityResponse>("/api/marriage/duo-quest/claim", new { userId = Session.UserId });
    }

    public static Task<BattleStateView> StartCoopBattle()
    {
        return ApiClient.PostAsync<BattleStateView>("/api/marriage/battle/start", new { userId = Session.UserId });
    }

    public static Task<CoopReportResponse> ReportCoopBattle(string battleId)
    {
        return ApiClient.PostAsync<CoopReportResponse>("/api/marriage/battle/report", new
        {
            userId = Session.UserId,
            battleId,
        });
    }
}
