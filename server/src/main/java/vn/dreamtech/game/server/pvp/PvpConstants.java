package vn.dreamtech.game.server.pvp;

public final class PvpConstants {
    /** Địch gần như bất tử — PvP là đấu trong giới hạn lượt (xem {@code BattleConstants#PVP_MOVE_LIMIT}), không phải hạ gục địch. */
    public static final int PERSONAL_ENGAGE_HP = 999_999;
    public static final int PERSONAL_ENGAGE_COUNTER_DAMAGE = 10;

    public static final int RATING_WIN = 20;
    public static final int RATING_LOSS = -10;
    public static final int RATING_DRAW = 5;
    public static final int MIN_RATING = 0;

    private PvpConstants() {
    }
}
