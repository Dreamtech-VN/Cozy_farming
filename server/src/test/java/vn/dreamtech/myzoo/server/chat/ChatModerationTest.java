package vn.dreamtech.myzoo.server.chat;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ChatModerationTest {
    @Test
    void normalTextPasses() {
        var result = ChatModeration.check("Chào mọi người, ai bán cà rốt không?");
        assertEquals(ChatModeration.Verdict.OK, result.verdict());
    }

    @Test
    void emptyAndTooLongRejected() {
        assertTrue(ChatModeration.check("").rejected());
        assertTrue(ChatModeration.check("   ").rejected());
        assertTrue(ChatModeration.check("a".repeat(ChatModeration.MAX_LENGTH + 1)).rejected());
    }

    @Test
    void linksRejected() {
        assertTrue(ChatModeration.check("vào https://scam.xyz nhận quà").rejected());
        assertTrue(ChatModeration.check("truy cap www.abc.com nhe").rejected());
        assertTrue(ChatModeration.check("shop tại myzoo.vn").rejected());
    }

    @Test
    void phoneNumbersRejected() {
        assertTrue(ChatModeration.check("liên hệ 0987654321").rejected());
        assertTrue(ChatModeration.check("goi 098 765 4321 nhe").rejected());
    }

    @Test
    void scamAndTradingRejected() {
        assertTrue(ChatModeration.check("bán acc giá rẻ").rejected());
        assertTrue(ChatModeration.check("ai mua nick ib").rejected());
        assertTrue(ChatModeration.check("nạp thẻ chiết khấu 50%").rejected());
        assertTrue(ChatModeration.check("add zalo mình nhé").rejected());
        assertTrue(ChatModeration.check("hack game free KC").rejected());
    }

    @Test
    void bannedWordsRejectedEvenWhenDisguised() {
        assertTrue(ChatModeration.check("đm cái game này").rejected());
        assertTrue(ChatModeration.check("d.m thật").rejected(), "chèn dấu chấm không lách được");
        assertTrue(ChatModeration.check("D M ngu vãi").rejected(), "chèn dấu cách không lách được");
        assertTrue(ChatModeration.check("xem phim sex").rejected());
    }

    @Test
    void softWordsMaskedNotRejected() {
        var result = ChatModeration.check("bạn ngu quá");
        assertEquals(ChatModeration.Verdict.MASKED, result.verdict());
        assertFalse(result.text().contains("ngu"));
        assertTrue(result.text().contains("***"));
    }

    @Test
    void ordinaryWordsContainingBannedLettersStillPass() {
        assertEquals(ChatModeration.Verdict.OK, ChatModeration.check("Xin chào mọi người").verdict());
        assertEquals(ChatModeration.Verdict.OK, ChatModeration.check("ai gọi admin giúp mình với").verdict());
        assertEquals(ChatModeration.Verdict.OK, ChatModeration.check("mình đi ngủ đây").verdict());
        assertEquals(ChatModeration.Verdict.OK, ChatModeration.check("con ngựa của mình đẹp không").verdict());
    }

    @Test
    void normalizeStripsDiacriticsAndSeparators() {
        assertEquals("dmm", ChatModeration.normalize("Đ.M.M"));
        assertEquals("banacc", ChatModeration.normalize("Bán  ACC"));
    }

    @Test
    void emojiOnlyMessageAllowedButSpamOfSymbolsRejected() {
        assertFalse(ChatModeration.check("🐰🌾").rejected(), "emoji bình thường vẫn gửi được");
        assertTrue(ChatModeration.check("!@#$%^&*()".repeat(5)).rejected(), "chuỗi ký tự rác bị chặn");
    }
}
