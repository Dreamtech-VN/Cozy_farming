package vn.dreamtech.game.server.social.marriage;

import vn.dreamtech.game.server.battle.EnemyDef;

import static vn.dreamtech.game.server.social.marriage.MarriageActivityConstants.COOP_BATTLE_COUNTER_DAMAGE;
import static vn.dreamtech.game.server.social.marriage.MarriageActivityConstants.COOP_BATTLE_HP;

/** "Bản sao" cá nhân cho 1 lượt đánh trận hợp tác vợ chồng. */
public record MarriageCoopFightDef(String name) implements EnemyDef {
    @Override
    public int enemyHp() {
        return COOP_BATTLE_HP;
    }

    @Override
    public int enemyCounterDamage() {
        return COOP_BATTLE_COUNTER_DAMAGE;
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
