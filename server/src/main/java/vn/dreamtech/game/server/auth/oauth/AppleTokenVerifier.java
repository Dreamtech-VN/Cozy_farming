package vn.dreamtech.game.server.auth.oauth;

/**
 * ⚠️ CHƯA xác thực thật. Apple ID token là JWT ký bằng khoá riêng của Apple
 * (JWKS tại {@code https://appleid.apple.com/auth/keys}) — verify đúng cần
 * thư viện JWT (vd. nimbus-jose-jwt) để kiểm chữ ký + `aud`/`iss`/`exp`,
 * chưa thêm dependency đó. CHỦ ĐỘNG BÁO LỖI thay vì tin token gửi lên (khác
 * hẳn kiểu "placeholder tin tưởng luôn" — tin token client gửi = lỗ hổng bảo
 * mật thật, không chấp nhận được dù là code tạm). TODO: thêm nimbus-jose-jwt,
 * verify chữ ký + audience khớp {@code APPLE_CLIENT_ID}/{@code APPLE_TEAM_ID}.
 */
public final class AppleTokenVerifier implements OAuthVerifier {
    @Override
    public ProviderIdentity verify(String idToken) throws OAuthVerificationException {
        throw new OAuthVerificationException("Đăng nhập Apple chưa được cấu hình trên server");
    }
}
