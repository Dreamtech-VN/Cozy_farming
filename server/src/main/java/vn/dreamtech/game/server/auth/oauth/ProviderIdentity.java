package vn.dreamtech.game.server.auth.oauth;

/** Danh tính rút ra từ token nhà cung cấp (Google/Apple) sau khi xác thực. */
public record ProviderIdentity(String providerUserId, String email) {
}
