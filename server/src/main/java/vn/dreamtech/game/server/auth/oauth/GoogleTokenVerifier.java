package vn.dreamtech.game.server.auth.oauth;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

/**
 * Xác thực ID token Google THẬT qua endpoint {@code tokeninfo} chính chủ
 * Google (đơn giản hơn tự verify chữ ký JWT bằng JWKS, được Google hỗ trợ
 * chính thức cho use-case xác thực phía server) — không phải placeholder.
 * Cần biến môi trường {@code GOOGLE_CLIENT_ID} (OAuth client ID thật từ
 * Google Cloud Console) để so khớp {@code aud}, chặn token cấp cho app khác.
 */
public final class GoogleTokenVerifier implements OAuthVerifier {
    private static final String TOKENINFO_URL = "https://oauth2.googleapis.com/tokeninfo?id_token=";

    private final String expectedClientId;
    private final HttpClient http;

    public GoogleTokenVerifier(String expectedClientId) {
        this.expectedClientId = expectedClientId;
        this.http = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(5)).build();
    }

    @Override
    public ProviderIdentity verify(String idToken) throws OAuthVerificationException {
        if (expectedClientId == null || expectedClientId.isBlank()) {
            throw new OAuthVerificationException("Chưa cấu hình GOOGLE_CLIENT_ID trên server");
        }
        try {
            HttpRequest req = HttpRequest.newBuilder(URI.create(TOKENINFO_URL + idToken))
                    .timeout(Duration.ofSeconds(5)).GET().build();
            HttpResponse<String> res = http.send(req, HttpResponse.BodyHandlers.ofString());
            if (res.statusCode() != 200) {
                throw new OAuthVerificationException("Token Google không hợp lệ hoặc hết hạn");
            }
            JsonObject body = JsonParser.parseString(res.body()).getAsJsonObject();
            String aud = body.has("aud") ? body.get("aud").getAsString() : null;
            if (!expectedClientId.equals(aud)) {
                throw new OAuthVerificationException("Token Google không cấp cho app này (aud không khớp)");
            }
            String sub = body.get("sub").getAsString();
            String email = body.has("email") ? body.get("email").getAsString() : null;
            return new ProviderIdentity(sub, email);
        } catch (java.io.IOException | InterruptedException e) {
            throw new OAuthVerificationException("Lỗi gọi Google tokeninfo: " + e.getMessage());
        }
    }
}
