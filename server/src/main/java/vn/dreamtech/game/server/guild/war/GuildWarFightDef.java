package vn.dreamtech.game.server.guild.war;

import vn.dreamtech.game.server.battle.EnemyDef;

import static vn.dreamtech.game.server.guild.war.GuildWarConstants.PERSONAL_ENGAGE_COUNTER_DAMAGE;
import static vn.dreamtech.game.server.guild.war.GuildWarConstants.PERSONAL_ENGAGE_HP;

/** "Bản sao" cá nhân cho 1 lượt đánh trong Guild War — giống {@code GuildBossFightDef}/{@code PvpFightDef} về ý tưởng. */
public record GuildWarFightDef(String name) implements EnemyDef {
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
