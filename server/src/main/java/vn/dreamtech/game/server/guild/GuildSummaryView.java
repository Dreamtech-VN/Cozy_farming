package vn.dreamtech.game.server.guild;

public record GuildSummaryView(int id, String name, String tag, String description, int leaderUserId, int memberCount, int maxMembers) {
}
