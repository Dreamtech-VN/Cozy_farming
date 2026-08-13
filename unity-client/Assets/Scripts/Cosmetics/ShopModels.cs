using System;

[Serializable]
public class ShopItemResponse
{
    public int itemId;
    public string type;
    public string name;
    public long priceGold;
}

[Serializable]
public class BuyCosmeticResponse
{
    public int itemId;
    public long paidGold;
    public long goldRemaining;
}
