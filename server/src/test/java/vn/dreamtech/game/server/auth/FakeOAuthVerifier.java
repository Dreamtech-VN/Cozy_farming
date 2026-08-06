package vn.dreamtech.game.server.auth;

import vn.dreamtech.game.server.auth.oauth.OAuthVerificationException;
import vn.dreamtech.game.server.auth.oauth.OAuthVerifier;
import vn.dreamtech.game.server.auth.oauth.ProviderIdentity;

import java.util.Map;

/** Verifier giả cho test — không gọi mạng thật, token "invalid" luôn báo lỗi để test nhánh 401. */
public final class FakeOAuthVerifier implements OAuthVerifier {
    private final Map<String, ProviderIdentity> tokens;

    public FakeOAuthVerifier(Map<String, ProviderIdentity> tokens) {
        this.tokens = tokens;
    }

    @Override
    public ProviderIdentity verify(String idToken) throws OAuthVerificationException {
        ProviderIdentity identity = tokens.get(idToken);
        if (identity == null) throw new OAuthVerificationException("token giả không hợp lệ");
        return identity;
    }
}
