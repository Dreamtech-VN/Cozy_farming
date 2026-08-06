package vn.dreamtech.game.server.battle.challenge;

import vn.dreamtech.game.server.battle.EnemyDef;

public record ChallengeDef(ChallengeType type, String name, int enemyHp, int enemyCounterDamage, int rewardExp, int rewardGold) implements EnemyDef {
}
