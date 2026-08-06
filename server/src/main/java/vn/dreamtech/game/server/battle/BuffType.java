package vn.dreamtech.game.server.battle;

/** Tập buff/debuff tối thiểu cho MVP — mở rộng thêm loại khác khi có thêm skill/vật phẩm. */
public enum BuffType {
    /** Buff: +{@link BattleConstants#CRIT_BUFF_DAMAGE_MULT} sát thương, nhận khi vừa khớp critical. */
    PLAYER_DAMAGE_UP,
    /** Debuff: giảm mana nhận được, địch áp khi phản đòn. */
    PLAYER_MANA_DOWN
}
