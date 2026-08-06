package vn.dreamtech.game.server.battle.adventure;

import vn.dreamtech.game.server.battle.EnemyDef;

/** Giống {@code StoryLevelDef} về cấu trúc — tách catalog riêng vì Adventure là tuyến nội dung khác Story (không theo cốt truyện chính). */
public record AdventureLevelDef(int id, String name, int enemyHp, int enemyCounterDamage, int rewardExp, int rewardGold) implements EnemyDef {
}
