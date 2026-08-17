package vn.dreamtech.myzoo.server.analytics;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class AnalyticsServiceTest {
    TestSupport.FakeTime time;
    AnalyticsService analytics;

    @BeforeEach
    void setUp() {
        time = new TestSupport.FakeTime();
        analytics = new AnalyticsService(TestSupport.newDb(), time);
    }

    @Test
    void countsEventsAndActivePlayers() {
        analytics.track(1, AnalyticsService.LOGIN, Map.of("kind", "guest"));
        analytics.track(1, AnalyticsService.GACHA_PULL, Map.of("count", 10));
        analytics.track(2, AnalyticsService.LOGIN, Map.of("kind", "guest"));

        var summary = analytics.summary(7);
        assertEquals(3, summary.totalEvents());
        assertEquals(2, summary.activePlayers(), "đếm người chơi riêng biệt, không đếm số sự kiện");
        assertEquals(AnalyticsService.LOGIN, summary.events().get(0).event(), "sự kiện nhiều nhất đứng đầu");
        assertEquals(2, summary.events().get(0).count());
    }

    @Test
    void onlyCountsInsideTheWindow() {
        analytics.track(1, AnalyticsService.LOGIN, null);
        time.advance(10L * 24 * 60 * 60 * 1000);
        analytics.track(1, AnalyticsService.LOGIN, null);

        assertEquals(1, analytics.summary(7).totalEvents(), "sự kiện 10 ngày trước nằm ngoài cửa sổ 7 ngày");
        assertEquals(2, analytics.summary(30).totalEvents());
    }

    @Test
    void windowIsClamped() {
        assertEquals(7, analytics.summary(0).days());
        assertEquals(7, analytics.summary(-3).days());
        assertEquals(7, analytics.summary(500).days());
        assertEquals(14, analytics.summary(14).days());
    }

    @Test
    void anonymousEventsDoNotCountAsPlayers() {
        analytics.track(null, AnalyticsService.LOGIN, null);
        var summary = analytics.summary(7);
        assertEquals(1, summary.totalEvents());
        assertEquals(0, summary.activePlayers());
    }

    // Ghi thống kê hỏng không bao giờ được làm hỏng hành động chính của người chơi.
    @Test
    void trackNeverThrowsEvenOnGarbageInput() {
        assertDoesNotThrow(() -> analytics.track(1, "sự_kiện_lạ", Map.of("k", new Object())));
        assertDoesNotThrow(() -> analytics.track(1, null, null));
        assertDoesNotThrow(() -> analytics.track(1, AnalyticsService.LOGIN,
                Map.of("dai", "x".repeat(5000))));
    }

    @Test
    void longPropsAreTruncatedInsteadOfFailing() {
        analytics.track(1, AnalyticsService.LOGIN, Map.of("dai", "x".repeat(5000)));
        assertEquals(1, analytics.summary(7).totalEvents(), "props dài vẫn ghi được, chỉ bị cắt bớt");
    }
}
