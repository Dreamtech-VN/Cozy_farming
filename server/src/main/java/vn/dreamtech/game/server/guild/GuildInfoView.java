package vn.dreamtech.game.server.guild;

import vn.dreamtech.game.server.model.GuildMembership;

import java.util.List;

public record GuildInfoView(int id, String name, String tag, String description, int leaderUserId,
                             int memberCount, int maxMembers, List<GuildMembership> members) {
}
