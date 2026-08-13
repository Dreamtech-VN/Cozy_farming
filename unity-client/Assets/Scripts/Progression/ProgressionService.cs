using System.Threading.Tasks;

public static class ProgressionService
{
    public static Task<WalletResponse> GetWallet()
    {
        return ApiClient.GetAsync<WalletResponse>($"/api/wallet?userId={Session.UserId}");
    }

    public static Task<LevelInfoResponse> GetLevel()
    {
        return ApiClient.GetAsync<LevelInfoResponse>($"/api/level?userId={Session.UserId}");
    }
}
