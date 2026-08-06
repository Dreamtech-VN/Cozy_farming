package vn.dreamtech.game.server.model;

/** {@code userIdA < userIdB} luôn đúng (thứ tự chuẩn hoá), khớp {@code Friendship}. */
public record Marriage(int userIdA, int userIdB, long marriedAt) {
}
