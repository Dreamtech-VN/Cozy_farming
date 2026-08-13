using System.Collections.Generic;
using System.Threading.Tasks;

public static class MailService
{
    public static Task<List<MailViewResponse>> List()
    {
        return ApiClient.GetAsync<List<MailViewResponse>>($"/api/mail/list?userId={Session.UserId}");
    }

    public static Task MarkRead(string mailId)
    {
        return ApiClient.PostAsync<object>("/api/mail/read", new { userId = Session.UserId, mailId });
    }

    public static Task<MailClaimResponse> Claim(string mailId)
    {
        return ApiClient.PostAsync<MailClaimResponse>("/api/mail/claim", new { userId = Session.UserId, mailId });
    }

    public static Task<List<ItemDefResponse>> GetItemCatalog()
    {
        return ApiClient.GetAsync<List<ItemDefResponse>>("/api/items/catalog");
    }
}
