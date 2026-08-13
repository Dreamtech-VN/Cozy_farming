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

    public static Task<List<StoryLevelDef>> ListAdventureLevels()
    {
        return ApiClient.GetAsync<List<StoryLevelDef>>("/api/battle/adventure/levels");
    }

    public static Task<BattleStateView> StartAdventure(int levelId)
    {
        return ApiClient.PostAsync<BattleStateView>("/api/battle/adventure/start", new { userId = Session.UserId, levelId });
    }

    public static Task<List<EventPuzzleDefResponse>> ListEventPuzzles()
    {
        return ApiClient.GetAsync<List<EventPuzzleDefResponse>>("/api/battle/event-puzzle/list");
    }

    public static Task<BattleStateView> StartEventPuzzle(int eventId)
    {
        return ApiClient.PostAsync<BattleStateView>("/api/battle/event-puzzle/start", new { userId = Session.UserId, eventId });
    }

    public static Task<List<DungeonDefResponse>> ListDungeons()
    {
        return ApiClient.GetAsync<List<DungeonDefResponse>>("/api/battle/dungeon/list");
    }

    public static Task<BattleStateView> StartDungeon(int dungeonId)
    {
        return ApiClient.PostAsync<BattleStateView>("/api/battle/dungeon/start", new { userId = Session.UserId, dungeonId });
    }

    public static Task<List<TowerDefResponse>> ListTowers()
    {
        return ApiClient.GetAsync<List<TowerDefResponse>>("/api/battle/tower/list");
    }

    public static Task<BattleStateView> StartTower(int towerId)
    {
        return ApiClient.PostAsync<BattleStateView>("/api/battle/tower/start", new { userId = Session.UserId, towerId });
    }

    public static Task<List<TowerLeaderboardEntryResponse>> GetTowerLeaderboard(int towerId)
    {
        return ApiClient.GetAsync<List<TowerLeaderboardEntryResponse>>($"/api/battle/tower/leaderboard?towerId={towerId}");
    }

    // type: "DAILY" hoặc "WEEKLY"
    public static Task<BattleStateView> StartChallenge(string type)
    {
        return ApiClient.PostAsync<BattleStateView>("/api/battle/challenge/start", new { userId = Session.UserId, type });
    }

    public static Task<ChallengeStatusResponse> GetChallengeStatus(string type)
    {
        return ApiClient.GetAsync<ChallengeStatusResponse>($"/api/battle/challenge/status?userId={Session.UserId}&type={type}");
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
