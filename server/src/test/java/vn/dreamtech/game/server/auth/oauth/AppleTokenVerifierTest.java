package vn.dreamtech.game.server.auth.oauth;

import com.nimbusds.jose.JOSEException;
import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jose.JWSHeader;
import com.nimbusds.jose.crypto.RSASSASigner;
import com.nimbusds.jose.jwk.JWKSet;
import com.nimbusds.jose.jwk.RSAKey;
import com.nimbusds.jose.jwk.gen.RSAKeyGenerator;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Date;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

/**
 * Test AppleTokenVerifier với JWKS GIẢ (tự sinh cặp khoá RSA + tự ký JWT
 * cục bộ, tiêm vào qua constructor package-private) — KHÔNG gọi Apple thật,
 * vẫn kiểm được đúng logic verify chữ ký/iss/aud/exp/kid.
 */
class AppleTokenVerifierTest {
    private static final String CLIENT_ID = "vn.dreamtech.game.client";
    private static final String ISSUER = "https://appleid.apple.com";

    private RSAKey rsaKey;
    private AppleTokenVerifier verifier;

    @BeforeEach
    void setUp() throws JOSEException {
        rsaKey = new RSAKeyGenerator(2048).keyID("test-kid-1").generate();
        JWKSet jwkSet = new JWKSet(rsaKey.toPublicJWK());
        verifier = new AppleTokenVerifier(CLIENT_ID, () -> jwkSet);
    }

    private static String signedToken(String issuer, String audience, String subject, String email,
                                       Date expiration, String kid, RSAKey signingKey) throws JOSEException {
        JWTClaimsSet.Builder claims = new JWTClaimsSet.Builder()
                .issuer(issuer)
                .audience(audience)
                .subject(subject)
                .expirationTime(expiration);
        if (email != null) {
            claims.claim("email", email);
        }
        SignedJWT jwt = new SignedJWT(new JWSHeader.Builder(JWSAlgorithm.RS256).keyID(kid).build(), claims.build());
        jwt.sign(new RSASSASigner(signingKey));
        return jwt.serialize();
    }

    private static Date future() {
        return new Date(System.currentTimeMillis() + 60_000);
    }

    private static Date past() {
        return new Date(System.currentTimeMillis() - 60_000);
    }

    @Test
    void validTokenVerifiedSuccessfully() throws Exception {
        String token = signedToken(ISSUER, CLIENT_ID, "user-123", "a@b.com", future(), "test-kid-1", rsaKey);
        var identity = verifier.verify(token);
        assertEquals("user-123", identity.providerUserId());
        assertEquals("a@b.com", identity.email());
    }

    @Test
    void wrongAudienceRejected() throws Exception {
        String token = signedToken(ISSUER, "other-app", "user-123", null, future(), "test-kid-1", rsaKey);
        assertThrows(OAuthVerificationException.class, () -> verifier.verify(token));
    }

    @Test
    void wrongIssuerRejected() throws Exception {
        String token = signedToken("https://evil.example.com", CLIENT_ID, "user-123", null, future(), "test-kid-1", rsaKey);
        assertThrows(OAuthVerificationException.class, () -> verifier.verify(token));
    }

    @Test
    void expiredTokenRejected() throws Exception {
        String token = signedToken(ISSUER, CLIENT_ID, "user-123", null, past(), "test-kid-1", rsaKey);
        assertThrows(OAuthVerificationException.class, () -> verifier.verify(token));
    }

    @Test
    void signedByWrongKeyRejected() throws Exception {
        RSAKey otherKey = new RSAKeyGenerator(2048).keyID("test-kid-1").generate();
        String token = signedToken(ISSUER, CLIENT_ID, "user-123", null, future(), "test-kid-1", otherKey);
        assertThrows(OAuthVerificationException.class, () -> verifier.verify(token));
    }

    @Test
    void unknownKidRejected() throws Exception {
        String token = signedToken(ISSUER, CLIENT_ID, "user-123", null, future(), "unknown-kid", rsaKey);
        assertThrows(OAuthVerificationException.class, () -> verifier.verify(token));
    }

    @Test
    void missingClientIdConfigRejected() {
        AppleTokenVerifier unconfigured = new AppleTokenVerifier(null, () -> new JWKSet(rsaKey.toPublicJWK()));
        assertThrows(OAuthVerificationException.class, () -> unconfigured.verify("whatever"));
    }

    @Test
    void malformedTokenRejected() {
        assertThrows(OAuthVerificationException.class, () -> verifier.verify("not-a-jwt"));
    }
}
