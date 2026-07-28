package org.example.utils;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Rate-limit / lockout tam thoi theo key (vd "login:" + ip), luu trong bo nho (khong can DB/Redis).
 * Dung cho: gioi han so lan dang nhap sai, so lan doan sai OTP, cooldown gui lai OTP.
 */
public class RateLimitUtil {

    private static final ConcurrentHashMap<String, Bucket> BUCKETS = new ConcurrentHashMap<>();

    private RateLimitUtil() {
    }

    private static class Bucket {
        final AtomicInteger count = new AtomicInteger(0);
        volatile long windowStartMillis;
        volatile long lockedUntilMillis;
    }

    public static boolean isBlocked(String key) {
        Bucket bucket = BUCKETS.get(key);
        if (bucket == null) {
            return false;
        }
        return System.currentTimeMillis() < bucket.lockedUntilMillis;
    }

    public static long remainingSeconds(String key) {
        Bucket bucket = BUCKETS.get(key);
        if (bucket == null) {
            return 0;
        }
        long remainingMillis = bucket.lockedUntilMillis - System.currentTimeMillis();
        return Math.max(0, remainingMillis / 1000);
    }

    /**
     * @return true neu lan goi nay khien key bi khoa (vua vuot maxAttempts), de servlet
     * goi ghi ghi lai 1 dong audit log duy nhat cho su kien khoa nay.
     */
    public static boolean recordFailure(String key, int maxAttempts, long windowMillis, long lockoutMillis) {
        long now = System.currentTimeMillis();
        Bucket bucket = BUCKETS.computeIfAbsent(key, k -> new Bucket());

        boolean justLocked;
        synchronized (bucket) {
            if (now - bucket.windowStartMillis > windowMillis) {
                bucket.windowStartMillis = now;
                bucket.count.set(0);
            }
            int attempts = bucket.count.incrementAndGet();
            justLocked = attempts >= maxAttempts;
            if (justLocked) {
                bucket.lockedUntilMillis = now + lockoutMillis;
            }
        }

        cleanupExpired(now);
        return justLocked;
    }

    public static void reset(String key) {
        BUCKETS.remove(key);
    }

    private static void cleanupExpired(long now) {
        BUCKETS.entrySet().removeIf(entry -> {
            Bucket b = entry.getValue();
            long staleAfter = Math.max(b.lockedUntilMillis, b.windowStartMillis) + 60 * 60 * 1000L;
            return now > staleAfter;
        });
    }
}
