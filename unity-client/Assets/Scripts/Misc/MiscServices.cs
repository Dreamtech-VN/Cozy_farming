using System.Collections.Generic;
using System.Threading.Tasks;

public static class GiftcodeService
{
    // Thành công trả về MailViewResponse — phần thưởng giftcode gửi qua hộp thư, vào MailPanel nhận.
    public static Task<MailViewResponse> Redeem(string code)
    {
        return ApiClient.PostAsync<MailViewResponse>("/api/giftcode/redeem", new { userId = Session.UserId, code });
    }
}

public static class EventBoardService
{
    public static Task<List<EventEntryResponse>> GetBoard()
    {
        return ApiClient.GetAsync<List<EventEntryResponse>>("/api/events/board");
    }
}

public static class SettingsService
{
    public static Task<UserSettingsResponse> Get()
    {
        return ApiClient.GetAsync<UserSettingsResponse>($"/api/settings?userId={Session.UserId}");
    }

    // Field nào null thì giữ nguyên giá trị cũ (server chỉ cập nhật field gửi lên).
    public static Task<UserSettingsResponse> Update(bool? pushNotifications = null,
        string friendRequestPrivacy = null, string messagePrivacy = null, string language = null)
    {
        return ApiClient.PostAsync<UserSettingsResponse>("/api/settings/update", new
        {
            userId = Session.UserId,
            pushNotifications,
            friendRequestPrivacy,
            messagePrivacy,
            language,
        });
    }
}

public static class SupportService
{
    public static Task<SupportTicketResponse> Report(string category, string message)
    {
        return ApiClient.PostAsync<SupportTicketResponse>("/api/support/report", new
        {
            userId = Session.UserId,
            category,
            message,
        });
    }

    public static Task<List<SupportTicketResponse>> MyTickets()
    {
        return ApiClient.GetAsync<List<SupportTicketResponse>>($"/api/support/tickets?userId={Session.UserId}");
    }
}
