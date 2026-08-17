package vn.dreamtech.myzoo.server.auth;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

// PBKDF2 có sẵn trong JDK — không cần thư viện ngoài (Maven chạy offline).
public final class PasswordHash {
    private static final int ITERATIONS = 120_000;
    private static final int KEY_BITS = 256;
    private static final SecureRandom RANDOM = new SecureRandom();

    public static String newSalt() {
        byte[] salt = new byte[16];
        RANDOM.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }

    public static String hash(String password, String salt) {
        try {
            var spec = new PBEKeySpec(password.toCharArray(), Base64.getDecoder().decode(salt), ITERATIONS, KEY_BITS);
            byte[] key = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded();
            return Base64.getEncoder().encodeToString(key);
        } catch (Exception e) {
            throw new IllegalStateException("Không băm được mật khẩu", e);
        }
    }

    public static boolean matches(String password, String salt, String expectedHash) {
        return MessageDigest.isEqual(hash(password, salt).getBytes(), expectedHash.getBytes());
    }

    private PasswordHash() {
    }
}
