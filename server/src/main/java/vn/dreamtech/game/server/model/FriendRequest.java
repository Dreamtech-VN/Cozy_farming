package vn.dreamtech.game.server.model;

public record FriendRequest(long id, int fromUserId, int toUserId, long createdAt) {
}
