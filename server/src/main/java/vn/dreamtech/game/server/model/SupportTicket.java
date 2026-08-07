package vn.dreamtech.game.server.model;

/** {@code category}: "bug" | "contact". */
public record SupportTicket(long id, int userId, String category, String message, long createdAt, boolean resolved) {
}
