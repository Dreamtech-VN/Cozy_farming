package vn.dreamtech.game.server.pvp;

import vn.dreamtech.game.server.battle.EnemyDef;

import static vn.dreamtech.game.server.pvp.PvpConstants.PERSONAL_ENGAGE_COUNTER_DAMAGE;
import static vn.dreamtech.game.server.pvp.PvpConstants.PERSONAL_ENGAGE_HP;

/** "Sân đấu" cá nhân cho 1 lượt PvP — mỗi bên chơi độc lập trong giới hạn lượt, không đối đầu trực tiếp qua bàn cờ chung. */
public record PvpFightDef(String name) implements EnemyDef {
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
