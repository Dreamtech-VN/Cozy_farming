using System;
using System.Collections.Generic;

[Serializable]
public class RewardEntryResponse
{
    public int itemId;
    public int quantity;
}

[Serializable]
public class MailViewResponse
{
    public string id;
    public string title;
    public string body;
    public List<RewardEntryResponse> rewards;
    public string source;
    public long createdAt;
    public long? expiresAt;
    public long? readAt;
    public long? claimedAt;
}

[Serializable]
public class GrantedRewardResponse
{
    public int itemId;
    public string itemName;
    public string category;
    public int quantity;
}

[Serializable]
public class MailClaimResponse
{
    public string mailId;
    public List<GrantedRewardResponse> granted;
}

[Serializable]
public class ItemDefResponse
{
    public int id;
    public string name;
    public string category;
    public int? refId;
    public string description;
}
