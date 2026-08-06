package vn.dreamtech.game.server.social.marriage;

/** Số liệu cân bằng — game mới, không có gốc thật để đối chiếu, theo "gợi ý cân bằng" người dùng đưa ra. */
public final class MarriageConstants {
    /** Level tối thiểu cả hai bên để cầu hôn được. */
    public static final int MIN_LEVEL = 25;
    /** Điểm thân mật tối thiểu để cầu hôn được. */
    public static final int PROPOSAL_THRESHOLD = 1000;
    /** Phải là bạn bè tối thiểu bấy nhiêu ngày trước khi cầu hôn được. */
    public static final long MIN_FRIENDSHIP_DURATION_MS = 7 * 24 * 3_600_000L;
    /** "Mua nhẫn cầu hôn" — 1 trong 2 mức giá, người cầu hôn chọn trả bằng vàng hay kim cương. */
    public static final long RING_COST_GOLD = 100_000;
    public static final long RING_COST_DIAMOND = 500;
    /** Thời gian chờ sau khi ly hôn trước khi cưới lại (áp dụng cho CẢ HAI người). */
    public static final long DIVORCE_COOLDOWN_MS = 3 * 24 * 3_600_000L;

    private MarriageConstants() {
    }
}
