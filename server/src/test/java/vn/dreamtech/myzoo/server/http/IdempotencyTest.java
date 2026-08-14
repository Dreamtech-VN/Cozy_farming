package vn.dreamtech.myzoo.server.http;

import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;

import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import static org.junit.jupiter.api.Assertions.*;

class IdempotencyTest {
    @Test
    void sameRequestIdRunsActionOnceAndReplaysResponse() {
        var idempotency = new Idempotency(TestSupport.newDb(), new TestSupport.FakeTime());
        AtomicInteger runs = new AtomicInteger();
        String first = idempotency.execute("req-1", 1, () -> Map.of("value", runs.incrementAndGet()));
        String second = idempotency.execute("req-1", 1, () -> Map.of("value", runs.incrementAndGet()));
        assertEquals(first, second);
        assertEquals(1, runs.get());
    }

    @Test
    void missingRequestIdRunsEveryTime() {
        var idempotency = new Idempotency(TestSupport.newDb(), new TestSupport.FakeTime());
        AtomicInteger runs = new AtomicInteger();
        idempotency.execute(null, 1, () -> Map.of("value", runs.incrementAndGet()));
        idempotency.execute("", 1, () -> Map.of("value", runs.incrementAndGet()));
        assertEquals(2, runs.get());
    }
}
