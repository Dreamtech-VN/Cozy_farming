package vn.dreamtech.myzoo.server.shop;

import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.http.JsonHttp;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Map;

// Xác thực hoá đơn với cổng thanh toán (spec §27.14). Client KHÔNG bao giờ tự nói "cộng cho tôi 1000 KC";
// nó gửi biên nhận của store, server hỏi lại store rồi mới cộng.
public final class IapVerifier {
    public static final String GOOGLE_PLAY = "GOOGLE_PLAY";
    public static final String APP_STORE = "APP_STORE";
    public static final String MOCK = "MOCK";

    // Mã giao dịch của store; dùng làm khoá chống cộng tiền hai lần cho cùng một hoá đơn.
    public record Verified(String provider, String externalTransactionId) {
    }

    private final HttpClient http = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10)).build();

    private final boolean allowMock;

    public IapVerifier() {
        this(mockAllowedByEnv());
    }

    // Test dựng thẳng với true/false thay vì phụ thuộc biến môi trường, nên cả hai nhánh đều được kiểm.
    public IapVerifier(boolean allowMock) {
        this.allowMock = allowMock;
    }

    public static boolean mockAllowedByEnv() {
        return Boolean.parseBoolean(System.getenv().getOrDefault("IAP_ALLOW_MOCK", "false"));
    }

    public boolean mockAllowed() {
        return allowMock;
    }

    public static String googlePackage() {
        return System.getenv("GOOGLE_PLAY_PACKAGE");
    }

    public static String googleAccessToken() {
        return System.getenv("GOOGLE_PLAY_ACCESS_TOKEN");
    }

    public static String appStoreSecret() {
        return System.getenv("APP_STORE_SHARED_SECRET");
    }

    public Verified verify(String provider, String productId, String receipt) {
        if (receipt == null || receipt.isBlank()) throw new ApiException(400, "Thiếu biên nhận thanh toán");
        return switch (provider == null ? "" : provider) {
            case GOOGLE_PLAY -> verifyGoogle(productId, receipt);
            case APP_STORE -> verifyAppStore(receipt);
            case MOCK -> verifyMock(productId, receipt);
            default -> throw new ApiException(400, "Cổng thanh toán không hợp lệ");
        };
    }

    // Chỉ bật khi đặt IAP_ALLOW_MOCK=true. Mặc định tắt: để sót cờ này trên production là mở cửa
    // cho bất kỳ ai tự cộng Kim Cương.
    private Verified verifyMock(String productId, String receipt) {
        if (!allowMock) {
            throw new ApiException(503, "Máy chủ chưa cấu hình thanh toán");
        }
        return new Verified(MOCK, "MOCK-" + productId + "-" + receipt);
    }

    private Verified verifyGoogle(String productId, String purchaseToken) {
        String pkg = googlePackage();
        String token = googleAccessToken();
        if (pkg == null || token == null) throw new ApiException(503, "Máy chủ chưa cấu hình Google Play");

        String url = "https://androidpublisher.googleapis.com/androidpublisher/v3/applications/"
                + pkg + "/purchases/products/" + productId + "/tokens/" + purchaseToken;
        Map<?, ?> body = getJson(url, token);

        // purchaseState: 0 = đã mua. Khác 0 là huỷ hoặc đang chờ, không được cộng tiền.
        Object state = body.get("purchaseState");
        if (state == null || ((Number) state).intValue() != 0) {
            throw new ApiException(402, "Giao dịch chưa hoàn tất hoặc đã huỷ");
        }
        Object orderId = body.get("orderId");
        String external = orderId != null ? orderId.toString() : purchaseToken;
        return new Verified(GOOGLE_PLAY, external);
    }

    private Verified verifyAppStore(String receipt) {
        String secret = appStoreSecret();
        if (secret == null) throw new ApiException(503, "Máy chủ chưa cấu hình App Store");

        String payload = "{\"receipt-data\":\"" + receipt + "\",\"password\":\"" + secret + "\"}";
        Map<?, ?> body = postJson("https://buy.itunes.apple.com/verifyReceipt", payload);

        // 21007 = biên nhận của sandbox gửi nhầm lên production; Apple yêu cầu thử lại ở sandbox.
        int status = number(body.get("status"));
        if (status == 21007) {
            body = postJson("https://sandbox.itunes.apple.com/verifyReceipt", payload);
            status = number(body.get("status"));
        }
        if (status != 0) throw new ApiException(402, "Biên nhận không hợp lệ (mã " + status + ")");

        Object receiptObj = body.get("receipt");
        String external = null;
        if (receiptObj instanceof Map<?, ?> map) {
            Object inApp = map.get("in_app");
            if (inApp instanceof java.util.List<?> list && !list.isEmpty()
                    && list.get(0) instanceof Map<?, ?> first) {
                Object txId = first.get("transaction_id");
                if (txId != null) external = txId.toString();
            }
        }
        if (external == null) throw new ApiException(402, "Biên nhận thiếu mã giao dịch");
        return new Verified(APP_STORE, external);
    }

    private static int number(Object value) {
        return value instanceof Number n ? n.intValue() : -1;
    }

    private Map<?, ?> getJson(String url, String bearer) {
        try {
            HttpRequest request = HttpRequest.newBuilder(URI.create(url))
                    .header("Authorization", "Bearer " + bearer)
                    .timeout(Duration.ofSeconds(15))
                    .GET().build();
            HttpResponse<String> response = http.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() != 200) {
                throw new ApiException(402, "Cổng thanh toán từ chối (mã " + response.statusCode() + ")");
            }
            return JsonHttp.GSON.fromJson(response.body(), Map.class);
        } catch (ApiException e) {
            throw e;
        } catch (Exception e) {
            throw new ApiException(502, "Không hỏi được cổng thanh toán: " + e.getMessage());
        }
    }

    private Map<?, ?> postJson(String url, String payload) {
        try {
            HttpRequest request = HttpRequest.newBuilder(URI.create(url))
                    .header("Content-Type", "application/json")
                    .timeout(Duration.ofSeconds(15))
                    .POST(HttpRequest.BodyPublishers.ofString(payload)).build();
            HttpResponse<String> response = http.send(request, HttpResponse.BodyHandlers.ofString());
            return JsonHttp.GSON.fromJson(response.body(), Map.class);
        } catch (Exception e) {
            throw new ApiException(502, "Không hỏi được cổng thanh toán: " + e.getMessage());
        }
    }
}
