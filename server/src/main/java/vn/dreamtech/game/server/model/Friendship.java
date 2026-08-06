package vn.dreamtech.game.server.model;

/**
 * {@code userIdA < userIdB} LUÔN đúng (thứ tự chuẩn hoá) — 1 cặp bạn bè chỉ
 * có ĐÚNG 1 dòng, tránh lưu 2 chiều trùng lặp. Điểm thân mật ({@code
 * intimacyPoints}) gắn liền với tình bạn — chỉ bạn bè mới tích được thân
 * mật, mất bạn thì mất luôn điểm.
 */
public record Friendship(int userIdA, int userIdB, int intimacyPoints, Long lastGiftAt, long createdAt) {
}
