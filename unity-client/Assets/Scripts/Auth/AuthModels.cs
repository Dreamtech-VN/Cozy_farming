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

[Serializable]
public class AccountResponse
{
    public int userId;
    public string username;
}

[Serializable]
public class ForgotPasswordResponse
{
    public bool sent;
    public string devOnlyCode;
}
