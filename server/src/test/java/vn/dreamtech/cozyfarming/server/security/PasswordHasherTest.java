package vn.dreamtech.cozyfarming.server.security;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PasswordHasherTest {
    @Test
    void verifyAcceptsCorrectPassword() {
        String stored = PasswordHasher.hash("matkhau123");
        assertTrue(PasswordHasher.verify("matkhau123", stored));
    }

    @Test
    void verifyRejectsWrongPassword() {
        String stored = PasswordHasher.hash("matkhau123");
        assertFalse(PasswordHasher.verify("saimatkhau", stored));
    }

    @Test
    void sameSameInputProducesDifferentHashEachTime() {
        // salt ngẫu nhiên mỗi lần -> 2 lần băm cùng mật khẩu phải ra chuỗi khác nhau
        assertNotEquals(PasswordHasher.hash("abc"), PasswordHasher.hash("abc"));
    }
}
