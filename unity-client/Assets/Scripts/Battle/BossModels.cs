using System;

[Serializable]
public class WorldBossStatusResponse
{
    public int remainingHp;
    public int poolMaxHp;
    public long cycleStartedAt;
    public long cycleEndsAt;
}

[Serializable]
public class GuildBossStatusResponse
{
    public int guildId;
    public int remainingHp;
    public int poolMaxHp;
    public long cycleStartedAt;
    public long cycleEndsAt;
}

[Serializable]
public class BossReportResponse
{
    public int damageApplied;
    public int remainingHp;
    public bool poolDepleted;
    public int rewardExp;
    public int rewardGold;
}

[Serializable]
public class AttackStatusResponse
{
    public bool canAttack;
    public string reason;
}

[Serializable]
public class BossLeaderboardEntryResponse
{
    public int rank;
    public int userId;
    public int totalDamage;
}

[Serializable]
public class GuildWarResponse
{
    public string warId;
    public int guildA;
    public int guildB;
    public int scoreA;
    public int scoreB;
    public string status; // "ONGOING", "RESOLVED"
    public long startedAt;
    public long endsAt;
    public int? winnerGuildId; // null = hoà (khi RESOLVED)
}
