package vn.dreamtech.game.server.battle.challenge;

/** {@code cooldownMs} tính từ lần HOÀN THÀNH gần nhất (không phải reset theo mốc lịch/tuần thật) — đơn giản hoá cho MVP. */
public enum ChallengeType {
    DAILY(24 * 3_600_000L),
    WEEKLY(7 * 24 * 3_600_000L);

    public final long cooldownMs;

    ChallengeType(long cooldownMs) {
        this.cooldownMs = cooldownMs;
    }
}
