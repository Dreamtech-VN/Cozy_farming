package vn.dreamtech.game.server.battle;

import vn.dreamtech.game.server.battle.challenge.ChallengeType;

public record ChallengeStatusView(ChallengeType type, boolean available, long cooldownRemainingMs) {
}
