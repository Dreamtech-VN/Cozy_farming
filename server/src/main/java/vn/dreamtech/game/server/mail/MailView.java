package vn.dreamtech.game.server.mail;

import vn.dreamtech.game.server.item.RewardEntry;

import java.util.List;

public record MailView(String id, String title, String body, List<RewardEntry> rewards, String source,
                        long createdAt, Long expiresAt, Long readAt, Long claimedAt) {
}
