package vn.dreamtech.game.server.model;

public record Guild(int id, String name, String tag, String description, int leaderUserId, long createdAt) {
}
