package vn.dreamtech.game.server.mail;

import vn.dreamtech.game.server.item.GrantedReward;

import java.util.List;

public record MailClaimResult(String mailId, List<GrantedReward> granted) {
}
