package vn.dreamtech.game.server.guild.boss;

public record GuildBossStatusView(int guildId, int remainingHp, int poolMaxHp, long cycleStartedAt, long cycleEndsAt) {
}
