using System.Collections.Generic;
using System.Threading.Tasks;

public static class FriendService
{
    public static Task<FriendRequestResponse> SendRequest(int toUserId)
    {
        return ApiClient.PostAsync<FriendRequestResponse>("/api/friends/request", new
        {
            fromUserId = Session.UserId,
            toUserId,
        });
    }

    public static Task<List<FriendRequestResponse>> PendingRequests()
    {
        return ApiClient.GetAsync<List<FriendRequestResponse>>($"/api/friends/requests?userId={Session.UserId}");
    }

    public static Task Respond(long requestId, bool accept)
    {
        return ApiClient.PostAsync<object>("/api/friends/respond", new
        {
            requestId,
            userId = Session.UserId,
            accept,
        });
    }

    public static Task<List<FriendViewResponse>> ListFriends()
    {
        return ApiClient.GetAsync<List<FriendViewResponse>>($"/api/friends?userId={Session.UserId}");
    }

    public static Task Remove(int friendUserId)
    {
        return ApiClient.PostAsync<object>("/api/friends/remove", new
        {
            userId = Session.UserId,
            friendUserId,
        });
    }

    public static Task<SendGiftResponse> SendGift(int toUserId, string giftId)
    {
        return ApiClient.PostAsync<SendGiftResponse>("/api/friends/gift", new
        {
            fromUserId = Session.UserId,
            toUserId,
            giftId,
        });
    }
}
