package vn.dreamtech.cozyfarming.server.model;

/** Khớp {@code PondFish} client ({@code src/systems/fishfarm.ts}) — {@code fedAt} null nghĩa là chưa từng cho ăn. */
public record PondFish(String id, String type, long at, Long fedAt) {
}
