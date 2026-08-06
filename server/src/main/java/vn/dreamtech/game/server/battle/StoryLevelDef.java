package vn.dreamtech.game.server.battle;

public record StoryLevelDef(int id, String name, int enemyHp, int enemyCounterDamage, int rewardExp, int rewardGold) implements EnemyDef {
}
