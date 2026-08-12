using System.Collections.Generic;
using System.Threading.Tasks;

public static class CosmeticService
{
    public static Task<List<CosmeticDefResponse>> GetCatalog()
    {
        return ApiClient.GetAsync<List<CosmeticDefResponse>>("/api/cosmetics/catalog");
    }

    public static Task<List<int>> GetOwned()
    {
        return ApiClient.GetAsync<List<int>>($"/api/cosmetics/owned?userId={Session.UserId}");
    }

    public static Task Unlock(int itemId)
    {
        return ApiClient.PostAsync<object>("/api/cosmetics/unlock", new
        {
            userId = Session.UserId,
            itemId,
        });
    }

    // itemId = null/0 để tháo ra (về mặc định).
    public static Task<CharacterAppearanceResponse> Equip(string slot, int? itemId)
    {
        return ApiClient.PostAsync<CharacterAppearanceResponse>("/api/character/appearance/equip", new
        {
            userId = Session.UserId,
            slot,
            itemId,
        });
    }

    public static Task<CharacterAppearanceResponse> GetAppearance()
    {
        return ApiClient.GetAsync<CharacterAppearanceResponse>($"/api/character/appearance?userId={Session.UserId}");
    }
}
