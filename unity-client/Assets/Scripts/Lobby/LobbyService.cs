using System.Collections.Generic;
using System.Threading.Tasks;

public static class LobbyService
{
    public static Task Heartbeat(int x, int y)
    {
        return ApiClient.PostAsync<object>("/api/lobby/heartbeat", new
        {
            userId = Session.UserId,
            x,
            y,
        });
    }

    public static Task<List<LobbyPlayerView>> ListPlayers()
    {
        return ApiClient.GetAsync<List<LobbyPlayerView>>("/api/lobby/players");
    }

    public static Task Leave()
    {
        return ApiClient.PostAsync<object>("/api/lobby/leave", new { userId = Session.UserId });
    }
}
