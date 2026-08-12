using System;

[Serializable]
public class GuestLoginRequest
{
    public string guestToken;
}

[Serializable]
public class GuestLoginResponse
{
    public int userId;
    public string guestToken;
    public bool isNew;
}
