package vn.dreamtech.myzoo.server.http;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;

import static org.junit.jupiter.api.Assertions.*;

class RateLimiterTest {
    TestSupport.FakeTime time;
    RateLimiter limiter;

    @BeforeEach
    void setUp() {
        time = new TestSupport.FakeTime();
        limiter = new RateLimiter(time);
    }

    @Test
    void allowsUpToLimitThenBlocks() {
        for (int i = 0; i < RateLimiter.NORMAL_LIMIT; i++) {
            assertEquals(0, limiter.retryAfterSeconds("an", "/v1/farm"), "request thứ " + i + " phải qua");
        }
        assertTrue(limiter.retryAfterSeconds("an", "/v1/farm") > 0, "vượt hạn phải bị chặn");
    }

    @Test
    void windowSlidesSoTrafficResumes() {
        for (int i = 0; i < RateLimiter.NORMAL_LIMIT; i++) limiter.retryAfterSeconds("an", "/v1/farm");
        assertTrue(limiter.retryAfterSeconds("an", "/v1/farm") > 0);

        time.advance(RateLimiter.WINDOW_MS);
        assertEquals(0, limiter.retryAfterSeconds("an", "/v1/farm"), "qua cửa sổ thì gọi lại được");
    }

    @Test
    void callersCountedSeparately() {
        for (int i = 0; i < RateLimiter.NORMAL_LIMIT; i++) limiter.retryAfterSeconds("an", "/v1/farm");
        assertTrue(limiter.retryAfterSeconds("an", "/v1/farm") > 0);
        assertEquals(0, limiter.retryAfterSeconds("binh", "/v1/farm"), "người khác không bị vạ lây");
    }

    @Test
    void sensitivePathsHaveTighterLimitAndOwnBudget() {
        assertTrue(RateLimiter.isSensitive("/v1/auth/login"));
        assertTrue(RateLimiter.isSensitive("/v1/shop/purchase"));
        assertFalse(RateLimiter.isSensitive("/v1/farm"));

        for (int i = 0; i < RateLimiter.SENSITIVE_LIMIT; i++) {
            assertEquals(0, limiter.retryAfterSeconds("an", "/v1/auth/login"));
        }
        assertTrue(limiter.retryAfterSeconds("an", "/v1/auth/login") > 0, "dò mật khẩu bị chặn sớm");
        assertEquals(0, limiter.retryAfterSeconds("an", "/v1/farm"), "hạn mức nhóm nhạy cảm tính riêng");
    }

    @Test
    void retryAfterCountsDownAsWindowAges() {
        for (int i = 0; i < RateLimiter.SENSITIVE_LIMIT; i++) limiter.retryAfterSeconds("an", "/v1/auth/login");
        int first = limiter.retryAfterSeconds("an", "/v1/auth/login");
        time.advance(30_000);
        int later = limiter.retryAfterSeconds("an", "/v1/auth/login");
        assertTrue(later < first, "càng chờ thì thời gian còn lại càng ngắn");
        assertTrue(later > 0);
    }

    @Test
    void evictIdleDropsStaleCallersButKeepsActiveOnes() {
        limiter.retryAfterSeconds("cu", "/v1/farm");
        time.advance(RateLimiter.WINDOW_MS + 1000);
        limiter.retryAfterSeconds("moi", "/v1/farm");
        limiter.evictIdle();

        // Người cũ bị dọn nên hạn mức của họ trở lại đầy đủ.
        for (int i = 0; i < RateLimiter.NORMAL_LIMIT; i++) {
            assertEquals(0, limiter.retryAfterSeconds("cu", "/v1/farm"));
        }
    }
}
