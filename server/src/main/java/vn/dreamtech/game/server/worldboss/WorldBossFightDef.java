package vn.dreamtech.game.server.worldboss;

import vn.dreamtech.game.server.battle.EnemyDef;

import static vn.dreamtech.game.server.worldboss.WorldBossConstants.PERSONAL_ENGAGE_COUNTER_DAMAGE;
import static vn.dreamtech.game.server.worldboss.WorldBossConstants.PERSONAL_ENGAGE_HP;

/** "Bản sao" cá nhân của trùm thế giới cho 1 lượt đánh — xem {@code GuildBossFightDef} cho lý do thiết kế tương tự. */
public record WorldBossFightDef(String name) implements EnemyDef {
    @Override
    public int enemyHp() {
        return PERSONAL_ENGAGE_HP;
    }

    @Override
    public int enemyCounterDamage() {
        return PERSONAL_ENGAGE_COUNTER_DAMAGE;
    }

    @Override
    public int rewardExp() {
        return 0;
    }

    @Override
    public int rewardGold() {
        return 0;
    }
}
