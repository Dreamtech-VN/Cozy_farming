package vn.dreamtech.game.server.model;

import java.time.Instant;

public record PasswordReset(int userId, String codeHash, Instant expiresAt) {
}
