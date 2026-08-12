public static class Session
{
    public static int UserId = -1;
    public static string GuestToken = "";
    public static string BattleId = "";
    public static string LastPvpMatchId = ""; // matchId PvP vừa report xong -> dùng để không nhận nhầm lại chính nó lúc poll ghép cặp mới

    public static bool IsLoggedIn => UserId > 0;
}
