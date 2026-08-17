package vn.dreamtech.myzoo.server.http;

import vn.dreamtech.myzoo.server.time.TimeSource;

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

// Giới hạn tần suất gọi API bằng cửa sổ trượt trong bộ nhớ.
// Chạy nhiều tiến trình thì mỗi tiến trình đếm riêng — chấp nhận được vì đây là lớp chống spam,
// không phải hạn mức tính tiền.
public final class RateLimiter {
    public static final int WINDOW_MS = 60_000;
    public static final int NORMAL_LIMIT = 120;
    public static final int SENSITIVE_LIMIT = 12;

    // Đăng nhập, đăng ký, đổi mật khẩu, mua bán: siết chặt để chặn dò mật khẩu và spam giao dịch.
    private static final String[] SENSITIVE = {
            "/v1/auth/", "/v1/shop/", "/v1/gacha/", "/v1/players", "/v1/giftcodes/"};

    private final TimeSource time;
    private final Map<String, Deque<Long>> hits = new ConcurrentHashMap<>();

    public RateLimiter(TimeSource time) {
        this.time = time;
    }

    public static boolean isSensitive(String path) {
        for (String prefix : SENSITIVE) {
            if (path.startsWith(prefix)) return true;
        }
        return false;
    }

    // Trả về số giây phải chờ nếu vượt hạn, 0 nếu được đi tiếp.
    public int retryAfterSeconds(String caller, String path) {
        int limit = isSensitive(path) ? SENSITIVE_LIMIT : NORMAL_LIMIT;
        String key = (isSensitive(path) ? "s:" : "n:") + caller;
        long now = time.now();
        Deque<Long> window = hits.computeIfAbsent(key, k -> new ArrayDeque<>());
        synchronized (window) {
            while (!window.isEmpty() && now - window.peekFirst() >= WINDOW_MS) window.pollFirst();
            if (window.size() >= limit) {
                long waitMs = WINDOW_MS - (now - window.peekFirst());
                return (int) Math.max(1, (waitMs + 999) / 1000);
            }
            window.addLast(now);
            return 0;
        }
    }

    // Gọi định kỳ để bảng không phình theo số IP đã từng ghé qua.
    public void evictIdle() {
        long now = time.now();
        hits.entrySet().removeIf(entry -> {
            Deque<Long> window = entry.getValue();
            synchronized (window) {
                return window.isEmpty() || now - window.peekLast() >= WINDOW_MS;
            }
        });
    }
}
