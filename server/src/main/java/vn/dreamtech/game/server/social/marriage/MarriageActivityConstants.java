package vn.dreamtech.game.server.social.marriage;

/** Số liệu cân bằng cho các nguồn điểm thân mật sau khi cưới — game mới, không có gốc thật để đối chiếu. */
public final class MarriageActivityConstants {
    /** Cộng điểm khi cả 2 vợ chồng cùng online — chặn spam bằng cooldown, không phải theo chu kỳ ngày. */
    public static final int ONLINE_TICK_INTIMACY = 5;
    public static final long ONLINE_TICK_COOLDOWN_MS = 5 * 60_000L;

    /** Nhiệm vụ đôi — cả 2 phải đang online mới nhận được, 1 lần/24h/cặp. */
    public static final int DUO_QUEST_INTIMACY = 100;
    public static final long DUO_QUEST_COOLDOWN_MS = 24 * 3_600_000L;

    /** Trận đánh hợp tác — mỗi người tự đánh 1 bản sao cá nhân; nếu cả 2 cùng hoàn thành trong
     * vòng {@value #COOP_BATTLE_WINDOW_MS} ms tính từ lượt của người kia, cả 2 nhận thưởng chung. */
    public static final int COOP_BATTLE_INTIMACY = 150;
    public static final long COOP_BATTLE_WINDOW_MS = 24 * 3_600_000L;
    public static final int COOP_BATTLE_HP = 300;
    public static final int COOP_BATTLE_COUNTER_DAMAGE = 12;

    private MarriageActivityConstants() {
    }
}
