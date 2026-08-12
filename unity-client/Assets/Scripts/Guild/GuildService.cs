using System.Collections.Generic;
using System.Threading.Tasks;

public static class GuildService
{
    public static Task<List<GuildSummaryResponse>> ListGuilds()
    {
        return ApiClient.GetAsync<List<GuildSummaryResponse>>("/api/guild/list");
    }

    public static async Task<GuildInfoResponse> GetMyGuildOrNull()
    {
        try
        {
            return await ApiClient.GetAsync<GuildInfoResponse>($"/api/guild/my?userId={Session.UserId}");
        }
        catch (ApiException e) when (e.StatusCode == 404)
        {
            return null;
        }
    }

    public static Task<GuildResponse> Create(string name, string tag, string description)
    {
        return ApiClient.PostAsync<GuildResponse>("/api/guild/create", new
        {
            userId = Session.UserId,
            name,
            tag,
            description,
        });
    }

    public static Task<GuildMembershipResponse> Join(int guildId)
    {
        return ApiClient.PostAsync<GuildMembershipResponse>("/api/guild/join", new
        {
            userId = Session.UserId,
            guildId,
        });
    }

    public static Task Leave()
    {
        return ApiClient.PostAsync<object>("/api/guild/leave", new { userId = Session.UserId });
    }
}
