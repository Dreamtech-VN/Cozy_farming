package vn.dreamtech.game.server.worldboss;

public record WorldBossStatusView(int remainingHp, int poolMaxHp, long cycleStartedAt, long cycleEndsAt) {
}
