package vn.dreamtech.game.server.social.marriage;

/** Số liệu cân bằng — game mới, không có gốc thật để đối chiếu, tự đặt hợp lý. */
public final class MarriageConstants {
    /** Điểm thân mật tối thiểu để cầu hôn được. */
    public static final int PROPOSAL_THRESHOLD = 1000;
    /** "Mua nhẫn cầu hôn" — trừ điểm thân mật chung của cặp (chưa có ví/xu, xem TODO giai đoạn 7). */
    public static final int RING_COST = 200;

    private MarriageConstants() {
    }
}
