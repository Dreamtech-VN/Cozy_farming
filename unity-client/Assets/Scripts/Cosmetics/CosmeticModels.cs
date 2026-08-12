using System;

[Serializable]
public class CosmeticDefResponse
{
    public int id;
    public string type; // "EYES", "AVATAR", "AVATAR_FRAME", "TITLE", "EMOTE", "HAT", "SHIRT", "PANTS", "SHOES", "PET", "SKIN"
    public string name;
}

[Serializable]
public class CharacterAppearanceResponse
{
    public int userId;
    public int? eyesId;
    public int? avatarId;
    public int? avatarFrameId;
    public int? titleId;
    public int? emoteId;
    public int? hatId;
    public int? shirtId;
    public int? pantsId;
    public int? shoesId;
    public int? petId;
    public int? skinId;

    public int? SlotValue(string type)
    {
        return type switch
        {
            "EYES" => eyesId,
            "AVATAR" => avatarId,
            "AVATAR_FRAME" => avatarFrameId,
            "TITLE" => titleId,
            "EMOTE" => emoteId,
            "HAT" => hatId,
            "SHIRT" => shirtId,
            "PANTS" => pantsId,
            "SHOES" => shoesId,
            "PET" => petId,
            "SKIN" => skinId,
            _ => null,
        };
    }
}
