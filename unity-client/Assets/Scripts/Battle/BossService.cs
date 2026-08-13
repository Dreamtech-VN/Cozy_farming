using System.Collections.Generic;
using System.Threading.Tasks;

public static class BossService
{
    // ---- World Boss ----
    public static Task<WorldBossStatusResponse> WorldBossStatus()
    {
        return ApiClient.GetAsync<WorldBossStatusResponse>("/api/world-boss/status");
    }

    public static Task<AttackStatusResponse> WorldBossAttackStatus()
    {
        return ApiClient.GetAsync<AttackStatusResponse>($"/api/world-boss/attack-status?userId={Session.UserId}");
    }

    public static Task<BattleStateView> WorldBossAttack()
    {
        return ApiClient.PostAsync<BattleStateView>("/api/world-boss/attack", new { userId = Session.UserId });
    }

    public static Task<BossReportResponse> WorldBossReport(string battleId)
    {
        return ApiClient.PostAsync<BossReportResponse>("/api/world-boss/report", new { userId = Session.UserId, battleId });
    }

    public static Task<List<BossLeaderboardEntryResponse>> WorldBossLeaderboard()
    {
        return ApiClient.GetAsync<List<BossLeaderboardEntryResponse>>("/api/world-boss/leaderboard");
    }

    // ---- Guild Boss ----
    public static Task<GuildBossStatusResponse> GuildBossStatus(int guildId)
    {
        return ApiClient.GetAsync<GuildBossStatusResponse>($"/api/guild/boss/status?guildId={guildId}");
    }

    public static Task<AttackStatusResponse> GuildBossAttackStatus()
    {
        return ApiClient.GetAsync<AttackStatusResponse>($"/api/guild/boss/attack-status?userId={Session.UserId}");
    }

    public static Task<BattleStateView> GuildBossAttack()
    {
        return ApiClient.PostAsync<BattleStateView>("/api/guild/boss/attack", new { userId = Session.UserId });
    }

    public static Task<BossReportResponse> GuildBossReport(string battleId)
    {
        return ApiClient.PostAsync<BossReportResponse>("/api/guild/boss/report", new { userId = Session.UserId, battleId });
    }

    public static Task<List<BossLeaderboardEntryResponse>> GuildBossLeaderboard(int guildId)
    {
        return ApiClient.GetAsync<List<BossLeaderboardEntryResponse>>($"/api/guild/boss/leaderboard?guildId={guildId}");
    }

    // ---- Guild War ----
    public static Task<GuildWarResponse> DeclareWar(int targetGuildId)
    {
        return ApiClient.PostAsync<GuildWarResponse>("/api/guild/war/declare", new { userId = Session.UserId, targetGuildId });
    }

    public static Task<BattleStateView> GuildWarAttack()
    {
        return ApiClient.PostAsync<BattleStateView>("/api/guild/war/attack", new { userId = Session.UserId });
    }

    public static Task<GuildWarResponse> GuildWarReport(string battleId)
    {
        return ApiClient.PostAsync<GuildWarResponse>("/api/guild/war/report", new { userId = Session.UserId, battleId });
    }

    public static Task<GuildWarResponse> MyWar()
    {
        return ApiClient.GetAsync<GuildWarResponse>($"/api/guild/war/my?userId={Session.UserId}");
    }
}
