using System.Threading.Tasks;

public static class CharacterService
{
    public static async Task<CharacterResponse> GetMyCharacterOrNull()
    {
        try
        {
            return await ApiClient.GetAsync<CharacterResponse>($"/api/character?userId={Session.UserId}");
        }
        catch (ApiException e) when (e.StatusCode == 404)
        {
            return null;
        }
    }

    public static Task<CharacterResponse> UpdateOutfit(int hairId, int topId, int bottomId)
    {
        return ApiClient.PostAsync<CharacterResponse>("/api/character/outfit", new
        {
            userId = Session.UserId,
            hairId,
            topId,
            bottomId,
        });
    }

    public static Task<CharacterResponse> Create(string name, int gender, int hairId, int topId, int bottomId)
    {
        return ApiClient.PostAsync<CharacterResponse>("/api/character/create", new CreateCharacterRequest
        {
            userId = Session.UserId,
            name = name,
            gender = gender,
            hairId = hairId,
            topId = topId,
            bottomId = bottomId,
        });
    }
}
