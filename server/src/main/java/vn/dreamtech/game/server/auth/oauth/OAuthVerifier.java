package vn.dreamtech.game.server.auth.oauth;

/** Xác thực id token từ nhà cung cấp (Google/Apple), trả về danh tính thật. */
public interface OAuthVerifier {
    /** Ném {@link OAuthVerificationException} nếu token không hợp lệ/hết hạn. */
    ProviderIdentity verify(String idToken) throws OAuthVerificationException;
}
