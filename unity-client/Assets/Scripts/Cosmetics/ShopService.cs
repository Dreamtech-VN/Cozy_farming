using System.Collections.Generic;
using System.Threading.Tasks;

public static class ShopService
{
    public static Task<List<ShopItemResponse>> GetShop()
    {
        return ApiClient.GetAsync<List<ShopItemResponse>>("/api/shop/cosmetics");
    }

    public static Task<BuyCosmeticResponse> Buy(int itemId)
    {
        return ApiClient.PostAsync<BuyCosmeticResponse>("/api/shop/cosmetics/buy", new
        {
            userId = Session.UserId,
            itemId,
        });
    }
}
