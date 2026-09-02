/**
 * Rate limit token-bucket trong bộ nhớ (doc 22).
 * Production nhiều instance nên chuyển sang Redis; interface giữ nguyên.
 */
export function createRateLimiter({ capacity, refillPerSecond }) {
  const buckets = new Map();

  return {
    /** true nếu được phép, false nếu vượt hạn mức. */
    take(key, cost = 1) {
      const now = Date.now();
      const bucket = buckets.get(key) ?? { tokens: capacity, at: now };
      const elapsed = (now - bucket.at) / 1000;
      bucket.tokens = Math.min(capacity, bucket.tokens + elapsed * refillPerSecond);
      bucket.at = now;
      if (bucket.tokens < cost) { buckets.set(key, bucket); return false; }
      bucket.tokens -= cost;
      buckets.set(key, bucket);
      return true;
    },
    /** Dọn bucket cũ để map không phình vô hạn. */
    sweep(olderThanMs = 600_000) {
      const cutoff = Date.now() - olderThanMs;
      for (const [key, bucket] of buckets) if (bucket.at < cutoff) buckets.delete(key);
    },
    get size() { return buckets.size; },
  };
}
