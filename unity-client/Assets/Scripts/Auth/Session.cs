public static class Session
{
    public static int UserId = -1;
    public static string GuestToken = "";
    public static string BattleId = "";

    public static bool IsLoggedIn => UserId > 0;
}
