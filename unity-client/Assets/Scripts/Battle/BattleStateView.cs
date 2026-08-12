using System;
using System.Collections.Generic;

[Serializable]
public class BattleStateView
{
    public string battleId;
    public int userId;
    public string mode;      // "STORY", "DUNGEON", "GUILD_BOSS", "PVP", ...
    public int? levelId;
    public string status;    // "ONGOING", "WON", "LOST"
    public int[][] board;    // 8x8, mỗi ô 0-5 = màu gem
    public int playerHp, playerHpMax, enemyHp, enemyHpMax;
    public int mana, manaMax, comboCount;
    public List<string> activeEffects; // "PLAYER_DAMAGE_UP", "PLAYER_MANA_DOWN"
    public bool matched, critical;
    public int chainLevels, damageDealt, manaGained;
    public bool enemyCountered;
    public int enemyCounterDamage;
    public bool rewardGranted;
    public int rewardExp, rewardGold;
    public int? floorIndex, totalFloors; // chỉ có giá trị ở Dungeon/Tower
    public bool floorCleared;
    public int totalDamageDealt; // dùng cho Guild/World Boss/PvP report
}

[Serializable]
public class StoryLevelDef
{
    public int id;
    public string name;
    public int enemyHp;
    public int enemyCounterDamage;
    public int rewardExp;
    public int rewardGold;
}
