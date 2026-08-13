using System;

[Serializable]
public class FriendRequestResponse
{
    public long id;
    public int fromUserId;
    public int toUserId;
    public long createdAt;
}

[Serializable]
public class FriendViewResponse
{
    public int userId;
    public string name;
    public int intimacyPoints;
}

[Serializable]
public class SendGiftResponse
{
    public int intimacyPoints;
}

[Serializable]
public class MarriageStatusResponse
{
    public bool married;
    public int? spouseUserId;
}

[Serializable]
public class MarriageProposalResponse
{
    public long id;
    public int fromUserId;
    public int toUserId;
    public long createdAt;
}

[Serializable]
public class MarriageActivityResponse
{
    public bool awarded;
    public int intimacyPoints;
    public string reason;
}

[Serializable]
public class CoopReportResponse
{
    public int damageDealt;
    public bool bonusAwarded;
    public int intimacyPoints;
}
