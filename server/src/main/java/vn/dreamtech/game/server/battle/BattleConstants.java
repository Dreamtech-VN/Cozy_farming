package vn.dreamtech.game.server.battle;

/** Hằng số cân bằng cơ chế combo/mana/ultimate/buff/debuff/chain/critical — tạm thời, chưa qua playtest thật. */
public final class BattleConstants {
    public static final int BOARD_ROWS = 8;
    public static final int BOARD_COLS = 8;
    public static final int COLOR_COUNT = 6;

    public static final int PLAYER_HP_MAX = 100;

    public static final int BASE_DAMAGE_PER_TILE = 10;
    public static final int CRITICAL_GROUP_SIZE = 5; // group >= 5 ô: critical (x2 sát thương)
    public static final int BONUS_GROUP_SIZE = 4;    // group == 4 ô: x1.5 sát thương
    public static final double CHAIN_BONUS_PER_LEVEL = 0.20; // mỗi tầng chain (từ tầng 2) +20% sát thương tầng đó

    public static final double COMBO_BONUS_PER_STACK = 0.10; // mỗi lượt khớp liên tiếp +10% tổng sát thương lượt sau
    public static final int COMBO_MAX_STACK = 5;

    public static final int MANA_PER_TILE = 2;
    public static final int MANA_MAX = 100;
    public static final int ULTIMATE_DAMAGE = 80;

    public static final int CRIT_BUFF_DURATION_SWAPS = 2;      // critical -> buff DAMAGE_UP cho 2 lượt kế tiếp
    public static final double CRIT_BUFF_DAMAGE_MULT = 0.20;

    public static final int ENEMY_COUNTER_EVERY_N_SWAPS = 3;   // cứ 3 lượt của người chơi, địch phản đòn 1 lần
    public static final int ENEMY_DEBUFF_DURATION_SWAPS = 2;   // phản đòn -> debuff MANA_DOWN cho 2 lượt kế tiếp
    public static final double ENEMY_DEBUFF_MANA_MULT = 0.5;

    public static final int PVP_MOVE_LIMIT = 20; // PvP không đấu tới khi 1 bên hết máu — hết lượt là dừng, so tổng sát thương

    private BattleConstants() {
    }
}
