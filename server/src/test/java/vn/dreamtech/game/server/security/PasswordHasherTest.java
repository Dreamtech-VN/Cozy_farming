package vn.dreamtech.game.server.security;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PasswordHasherTest {
    @Test
    void verifyAcceptsCorrectPassword() {
        String hash = PasswordHasher.hash("hunter2");
        assertTrue(PasswordHasher.verify("hunter2", hash));
    }

    @Test
    void verifyRejectsWrongPassword() {
        String hash = PasswordHasher.hash("hunter2");
        assertFalse(PasswordHasher.verify("wrong", hash));
    }

    @Test
    void hashIsSaltedDifferentlyEachTime() {
        assertNotEquals(PasswordHasher.hash("hunter2"), PasswordHasher.hash("hunter2"));
    }
}
