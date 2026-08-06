package vn.dreamtech.game.server.model;

/** Vị trí + mốc thời gian còn hoạt động của 1 người chơi trong sảnh. */
public record Presence(int userId, int x, int y, long lastSeen) {
}
