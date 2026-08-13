using System;

[Serializable]
public class WalletResponse
{
    public int userId;
    public long gold;
    public long diamond;
}

[Serializable]
public class LevelInfoResponse
{
    public int userId;
    public int level;
    public int exp;
}
