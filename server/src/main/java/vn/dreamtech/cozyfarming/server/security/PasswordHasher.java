package vn.dreamtech.cozyfarming.server.security;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;

/**
 * Băm mật khẩu THẬT (PBKDF2-HMAC-SHA256, có salt ngẫu nhiên) — khác hẳn hash
 * tay djb2 phía client (`login.ts`, chỉ để chặn gõ sai trên máy khi CHƯA có
 * server). Đây mới là nơi băm mật khẩu thật sự, client chỉ gửi mật khẩu thô
 * qua kênh HTTPS (khi triển khai thật) tới đây.
 *
 * Không dùng thư viện ngoài (BCrypt...) — PBKDF2 có sẵn trong JDK, đủ an
 * toàn cho giai đoạn này, tránh thêm dependency chưa cần thiết.
 */
public final class PasswordHasher {
    private static final int ITERATIONS = 120_000;
    private static final int KEY_LENGTH = 256;
    private static final SecureRandom RANDOM = new SecureRandom();

    /** Trả về chuỗi lưu DB: {@code <iterations>:<salt-base64>:<hash-base64>} */
    public static String hash(String rawPassword) {
        byte[] salt = new byte[16];
        RANDOM.nextBytes(salt);
        byte[] hash = pbkdf2(rawPassword.toCharArray(), salt, ITERATIONS);
        return ITERATIONS + ":" + Base64.getEncoder().encodeToString(salt) + ":"
                + Base64.getEncoder().encodeToString(hash);
    }

    public static boolean verify(String rawPassword, String stored) {
        String[] parts = stored.split(":");
        if (parts.length != 3) return false;
        int iterations = Integer.parseInt(parts[0]);
        byte[] salt = Base64.getDecoder().decode(parts[1]);
        byte[] expected = Base64.getDecoder().decode(parts[2]);
        byte[] actual = pbkdf2(rawPassword.toCharArray(), salt, iterations);
        return constantTimeEquals(expected, actual);
    }

    private static byte[] pbkdf2(char[] password, byte[] salt, int iterations) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, KEY_LENGTH);
            SecretKeyFactory f = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            return f.generateSecret(spec).getEncoded();
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new IllegalStateException(e);
        }
    }

    private static boolean constantTimeEquals(byte[] a, byte[] b) {
        if (a.length != b.length) return false;
        int diff = 0;
        for (int i = 0; i < a.length; i++) diff |= a[i] ^ b[i];
        return diff == 0;
    }

    private PasswordHasher() {
    }
}
