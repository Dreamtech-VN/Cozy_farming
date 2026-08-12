using System.Collections.Generic;
using System.Threading.Tasks;

public static class ChatService
{
    public static Task<ChatMessageResponse> Send(string text)
    {
        return ApiClient.PostAsync<ChatMessageResponse>("/api/chat/send", new
        {
            userId = Session.UserId,
            text,
        });
    }

    public static Task<List<ChatMessageResponse>> GetRecent(long sinceId, int limit = 50)
    {
        return ApiClient.GetAsync<List<ChatMessageResponse>>($"/api/chat/recent?sinceId={sinceId}&limit={limit}");
    }
}
