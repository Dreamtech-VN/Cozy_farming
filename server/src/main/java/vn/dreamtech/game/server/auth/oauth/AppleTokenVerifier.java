package vn.dreamtech.game.server.auth.oauth;

import com.nimbusds.jose.JOSEException;
import com.nimbusds.jose.JWSVerifier;
import com.nimbusds.jose.crypto.RSASSAVerifier;
import com.nimbusds.jose.jwk.JWK;
import com.nimbusds.jose.jwk.JWKSet;
import com.nimbusds.jose.jwk.RSAKey;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URI;
import java.text.ParseException;
import java.util.Date;
import java.util.function.Supplier;

/**
 * Xác thực ID token Apple THẬT — verify chữ ký JWT bằng JWKS chính chủ Apple
 * ({@code https://appleid.apple.com/auth/keys}, cache lại + tự refresh khi
 * gặp {@code kid} lạ, vd. Apple xoay khoá) qua {@code nimbus-jose-jwt}, kiểm
 * thêm {@code iss}/{@code aud}/{@code exp}. Cần biến môi trường
 * {@code APPLE_CLIENT_ID} (Services ID thật đăng ký với Apple) để so khớp
 * {@code aud}, chặn token cấp cho app khác — KHÔNG còn là placeholder tin
 * tưởng token gửi lên.
 */
public final class AppleTokenVerifier implements OAuthVerifier {
    private static final String ISSUER = "https://appleid.apple.com";
    private static final String JWKS_URL = "https://appleid.apple.com/auth/keys";
    private static final int JWKS_TIMEOUT_MS = 5000;
    private static final int JWKS_SIZE_LIMIT_BYTES = 50 * 1024;

    private final String expectedClientId;
    private final Supplier<JWKSet> jwksLoader;
    private volatile JWKSet cachedJwkSet;

    public AppleTokenVerifier(String expectedClientId) {
        this(expectedClientId, defaultJwksLoader());
    }

    /** Cho phép test tiêm JWKS giả (không gọi Apple thật) — không đổi hành vi ở production (constructor công khai vẫn dùng {@link #defaultJwksLoader}). */
    AppleTokenVerifier(String expectedClientId, Supplier<JWKSet> jwksLoader) {
        this.expectedClientId = expectedClientId;
        this.jwksLoader = jwksLoader;
    }

    private static Supplier<JWKSet> defaultJwksLoader() {
        return () -> {
            try {
                return JWKSet.load(URI.create(JWKS_URL).toURL(), JWKS_TIMEOUT_MS, JWKS_TIMEOUT_MS, JWKS_SIZE_LIMIT_BYTES);
            } catch (MalformedURLException e) {
                throw new IllegalStateException("URL JWKS Apple không hợp lệ", e);
            } catch (IOException | ParseException e) {
                throw new IllegalStateException("Lỗi tải JWKS từ Apple: " + e.getMessage(), e);
            }
        };
    }

    @Override
    public ProviderIdentity verify(String idToken) throws OAuthVerificationException {
        if (expectedClientId == null || expectedClientId.isBlank()) {
            throw new OAuthVerificationException("Chưa cấu hình APPLE_CLIENT_ID trên server");
        }
        try {
            SignedJWT jwt = SignedJWT.parse(idToken);
            String kid = jwt.getHeader().getKeyID();
            JWK jwk = findKey(kid);
            if (jwk == null) {
                throw new OAuthVerificationException("Không tìm thấy khoá xác thực Apple phù hợp (kid=" + kid + ")");
            }
            RSAKey rsaKey = jwk.toRSAKey();
            JWSVerifier verifier = new RSASSAVerifier(rsaKey);
            if (!jwt.verify(verifier)) {
                throw new OAuthVerificationException("Chữ ký token Apple không hợp lệ");
            }

            JWTClaimsSet claims = jwt.getJWTClaimsSet();
            if (!ISSUER.equals(claims.getIssuer())) {
                throw new OAuthVerificationException("Token Apple sai issuer");
            }
            if (claims.getAudience() == null || !claims.getAudience().contains(expectedClientId)) {
                throw new OAuthVerificationException("Token Apple không cấp cho app này (aud không khớp)");
            }
            Date exp = claims.getExpirationTime();
            if (exp == null || exp.before(new Date())) {
                throw new OAuthVerificationException("Token Apple đã hết hạn");
            }

            String sub = claims.getSubject();
            String email = claims.getStringClaim("email");
            return new ProviderIdentity(sub, email);
        } catch (ParseException e) {
            throw new OAuthVerificationException("Token Apple không đúng định dạng JWT: " + e.getMessage());
        } catch (JOSEException e) {
            throw new OAuthVerificationException("Lỗi xác minh chữ ký token Apple: " + e.getMessage());
        }
    }

    /** Tìm khoá theo {@code kid} trong JWKS đã cache — nếu không thấy thì tải lại 1 lần (Apple xoay khoá định kỳ). */
    private JWK findKey(String kid) {
        JWK found = jwkSet().getKeyByKeyId(kid);
        if (found != null) {
            return found;
        }
        cachedJwkSet = jwksLoader.get();
        return cachedJwkSet.getKeyByKeyId(kid);
    }

    private JWKSet jwkSet() {
        JWKSet local = cachedJwkSet;
        if (local == null) {
            synchronized (this) {
                local = cachedJwkSet;
                if (local == null) {
                    local = jwksLoader.get();
                    cachedJwkSet = local;
                }
            }
        }
        return local;
    }
}
