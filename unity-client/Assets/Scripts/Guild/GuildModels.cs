using System;
using System.Collections.Generic;

[Serializable]
public class GuildSummaryResponse
{
    public int id;
    public string name;
    public string tag;
    public string description;
    public int leaderUserId;
    public int memberCount;
    public int maxMembers;
}

[Serializable]
public class GuildMembershipResponse
{
    public int userId;
    public int guildId;
    public string role; // "LEADER", "OFFICER", "MEMBER"
    public long joinedAt;
}

[Serializable]
public class GuildResponse
{
    public int id;
    public string name;
    public string tag;
    public string description;
    public int leaderUserId;
    public long createdAt;
}

[Serializable]
public class GuildInfoResponse
{
    public int id;
    public string name;
    public string tag;
    public string description;
    public int leaderUserId;
    public int memberCount;
    public int maxMembers;
    public List<GuildMembershipResponse> members;
}
