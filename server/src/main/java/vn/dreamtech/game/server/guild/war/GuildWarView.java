package vn.dreamtech.game.server.guild.war;

public record GuildWarView(String warId, int guildA, int guildB, int scoreA, int scoreB, String status,
                            long startedAt, long endsAt, Integer winnerGuildId) {
}
