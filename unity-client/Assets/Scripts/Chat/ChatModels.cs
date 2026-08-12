using System;

[Serializable]
public class ChatMessageResponse
{
    public long id;
    public int userId;
    public string senderName;
    public string text;
    public long createdAt;
}
