package vn.dreamtech.game.server.battle.eventpuzzle;

import vn.dreamtech.game.server.battle.EnemyDef;

/** Màn chơi giới hạn thời gian — {@code startAt}/{@code endAt} là epoch millis, chỉ chơi được trong khoảng này. */
public record EventPuzzleDef(int id, String name, int enemyHp, int enemyCounterDamage, int rewardExp, int rewardGold,
                              long startAt, long endAt) implements EnemyDef {
    public boolean isActiveAt(long nowMillis) {
        return nowMillis >= startAt && nowMillis <= endAt;
    }
}
