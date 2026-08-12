using System.Collections.Generic;
using System.Threading.Tasks;

public static class BattleService
{
    public static Task<List<StoryLevelDef>> ListStoryLevels()
    {
        return ApiClient.GetAsync<List<StoryLevelDef>>("/api/battle/story/levels");
    }

    public static Task<BattleStateView> StartStory(int levelId)
    {
        return ApiClient.PostAsync<BattleStateView>("/api/battle/story/start", new
        {
            userId = Session.UserId,
            levelId,
        });
    }

    public static Task<BattleStateView> Swap(int r1, int c1, int r2, int c2)
    {
        return ApiClient.PostAsync<BattleStateView>("/api/battle/swap", new
        {
            userId = Session.UserId,
            battleId = Session.BattleId,
            r1, c1, r2, c2,
        });
    }

    public static Task<BattleStateView> UseUltimate()
    {
        return ApiClient.PostAsync<BattleStateView>("/api/battle/ultimate", new
        {
            userId = Session.UserId,
            battleId = Session.BattleId,
        });
    }

    public static Task<BattleStateView> GetState()
    {
        return ApiClient.GetAsync<BattleStateView>(
            $"/api/battle/state?battleId={Session.BattleId}&userId={Session.UserId}");
    }
}
