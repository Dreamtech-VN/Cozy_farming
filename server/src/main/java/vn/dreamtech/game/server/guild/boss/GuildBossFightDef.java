package vn.dreamtech.game.server.guild.boss;

import vn.dreamtech.game.server.battle.EnemyDef;

import static vn.dreamtech.game.server.guild.boss.GuildBossConstants.PERSONAL_ENGAGE_COUNTER_DAMAGE;
import static vn.dreamtech.game.server.guild.boss.GuildBossConstants.PERSONAL_ENGAGE_HP;

/**
 * "Bản sao" cá nhân của trùm guild cho 1 lượt đánh — mỗi thành viên đánh
 * bản sao HP cố định này, KHÔNG trực tiếp thao túng HP chung của guild
 * (xem {@code GuildBossService#report}, đồng bộ sau khi trận kết thúc).
 * Thưởng exp/vàng ở đây luôn là 0 vì {@code GuildBossService} tự phát
 * thưởng lúc report, không dùng cơ chế thưởng chung của {@code BattleService}.
 */
public record GuildBossFightDef(String name) implements EnemyDef {
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
