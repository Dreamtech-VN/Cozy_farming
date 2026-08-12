using System;

[Serializable]
public class CreateCharacterRequest
{
    public int userId;
    public string name;
    public int gender;   // 0 = nam, 1 = nữ
    public int hairId;
    public int topId;
    public int bottomId;
}

[Serializable]
public class CharacterResponse
{
    public int userId;
    public string name;
    public int gender;
    public int hairId;
    public int topId;
    public int bottomId;
}
