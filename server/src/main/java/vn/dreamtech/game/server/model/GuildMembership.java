package vn.dreamtech.game.server.model;

public record GuildMembership(int userId, int guildId, GuildRole role, long joinedAt) {
}
