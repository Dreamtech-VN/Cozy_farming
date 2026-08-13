using System;

[Serializable]
public class EventEntryResponse
{
    public int id;
    public string title;
    public string description;
    public long startAt;
    public long endAt;
    public bool active;
}

[Serializable]
public class UserSettingsResponse
{
    public int userId;
    public bool pushNotifications;
    public string friendRequestPrivacy; // "EVERYONE" | "NOBODY"
    public string messagePrivacy;       // "EVERYONE" | "NOBODY"
    public string language;
}

[Serializable]
public class SupportTicketResponse
{
    public long id;
    public int userId;
    public string category;
    public string message;
    public long createdAt;
    public bool resolved;
}
