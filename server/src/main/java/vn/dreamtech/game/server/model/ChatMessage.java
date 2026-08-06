package vn.dreamtech.game.server.model;

/** {@code senderName} lưu tại thời điểm gửi (denormalize) — lịch sử chat hiện đúng tên lúc gửi, không đổi theo nếu người chơi đổi tên sau. */
public record ChatMessage(long id, int userId, String senderName, String text, long createdAt) {
}
