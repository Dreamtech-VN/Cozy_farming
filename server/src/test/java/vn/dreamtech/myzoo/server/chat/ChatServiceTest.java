package vn.dreamtech.myzoo.server.chat;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;

import static org.junit.jupiter.api.Assertions.*;

class ChatServiceTest {
    TestSupport.FakeTime time;
    PlayerService players;
    ChatService chat;
    int an, binh;

    @BeforeEach
    void setUp() {
        var db = TestSupport.newDb();
        time = new TestSupport.FakeTime();
        players = new PlayerService(db, new EconomyService(db, time), time);
        chat = new ChatService(db, players, time);
        an = players.guestLogin(null).playerId();
        binh = players.guestLogin(null).playerId();
        players.createCharacter(an, "An", "farmer_1");
        players.createCharacter(binh, "Bình", "farmer_2");
    }

    // Mỗi lần gửi phải cách nhau ít nhất MIN_GAP_MS nên test phải nhích đồng hồ.
    void tick() {
        time.advance(ChatService.MIN_GAP_MS + 100);
    }

    // ---------- Kênh thế giới ----------
    @Test
    void worldMessageVisibleToEveryone() {
        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "Chào cả nhà", null);
        var seen = chat.world(binh, null, 50);
        assertEquals(1, seen.size());
        assertEquals("An", seen.get(0).senderName());
        assertEquals("Chào cả nhà", seen.get(0).text());
    }

    @Test
    void systemMessageAppearsInWorldFeed() {
        chat.system("Máy chủ bảo trì lúc 22h");
        var seen = chat.world(an, null, 50);
        assertEquals(1, seen.size());
        assertEquals(ChatService.SYSTEM, seen.get(0).channel());
        assertEquals("Hệ thống", seen.get(0).senderName());
    }

    // ---------- Tin riêng ----------
    @Test
    void privateMessageOnlyVisibleToTwoSides() {
        chat.send(an, ChatService.PRIVATE, binh, ChatService.TYPE_TEXT, "Cho mình xin ít cỏ", null);
        assertEquals(1, chat.conversation(an, binh, null, 50).size());
        assertEquals(1, chat.conversation(binh, an, null, 50).size());
        assertTrue(chat.world(an, null, 50).isEmpty(), "tin riêng không lọt ra kênh thế giới");

        int nguoiLa = players.guestLogin(null).playerId();
        players.createCharacter(nguoiLa, "NguoiLa", "farmer_1");
        assertTrue(chat.conversation(nguoiLa, an, null, 50).isEmpty());
    }

    @Test
    void privateNeedsTargetAndCannotSelfSend() {
        assertEquals(400, assertThrows(ApiException.class,
                () -> chat.send(an, ChatService.PRIVATE, null, ChatService.TYPE_TEXT, "hi", null)).status());
        assertEquals(400, assertThrows(ApiException.class,
                () -> chat.send(an, ChatService.PRIVATE, an, ChatService.TYPE_TEXT, "hi", null)).status());
    }

    // ---------- Chặn / ẩn ----------
    @Test
    void blockStopsPrivateMessagesAndHidesWorldChat() {
        chat.setRelation(binh, an, "BLOCK");
        assertEquals(403, assertThrows(ApiException.class,
                () -> chat.send(an, ChatService.PRIVATE, binh, ChatService.TYPE_TEXT, "hi", null)).status());

        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "ai đó nghe không", null);
        assertTrue(chat.world(binh, null, 50).isEmpty(), "Bình không thấy tin của An nữa");
        assertEquals(1, chat.world(an, null, 50).size(), "người khác vẫn thấy bình thường");
    }

    @Test
    void muteOnlyHidesWorldChatButAllowsPrivate() {
        chat.setRelation(binh, an, "MUTE");
        chat.send(an, ChatService.PRIVATE, binh, ChatService.TYPE_TEXT, "hi", null);   // vẫn gửi được
        tick();
        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "hello", null);
        assertTrue(chat.world(binh, null, 50).isEmpty());

        chat.setRelation(binh, an, "NONE");
        assertEquals(1, chat.world(binh, null, 50).size(), "bỏ chặn thì thấy lại");
    }

    // ---------- Chống spam ----------
    @Test
    void tooFastRejected() {
        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin 1", null);
        assertEquals(429, assertThrows(ApiException.class,
                () -> chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin 2", null)).status());
    }

    @Test
    void duplicateMessageRejected() {
        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "mua ban gi khong", null);
        tick();
        assertEquals(429, assertThrows(ApiException.class,
                () -> chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "mua ban gi khong", null)).status());
    }

    @Test
    void burstOverWindowRejected() {
        for (int i = 0; i < ChatService.MAX_IN_WINDOW; i++) {
            chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin so " + i, null);
            tick();
        }
        assertEquals(429, assertThrows(ApiException.class,
                () -> chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin nua", null)).status());

        time.advance(ChatService.WINDOW_MS);   // qua cửa sổ thì gửi lại được
        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin sau khi cho", null);
    }

    // ---------- Kiểm duyệt + tự động cấm ----------
    @Test
    void badContentRejectedAndAutoMutedAfterRepeatedViolations() {
        for (int i = 0; i < ChatService.AUTO_MUTE_VIOLATIONS; i++) {
            assertEquals(422, assertThrows(ApiException.class,
                    () -> chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "bán acc giá rẻ", null)).status());
            tick();
        }
        var ban = chat.banInfo(an);
        assertTrue(ban.banned(), "vi phạm 3 lần phải bị tự động cấm chat");

        assertEquals(403, assertThrows(ApiException.class,
                () -> chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin bình thường", null)).status());

        time.advance(ChatService.AUTO_MUTE_MS + 1000);
        assertFalse(chat.banInfo(an).banned(), "hết hạn cấm thì chat lại được");
        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin bình thường", null);
    }

    @Test
    void maskedMessageStillSentWithNotice() {
        var result = chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "bạn ngu quá", null);
        assertNotNull(result.notice());
        assertFalse(result.text().contains("ngu"));
        assertEquals(1, chat.world(binh, null, 50).size());
    }

    // ---------- Sticker / GIF ----------
    @Test
    void onlyCatalogStickersAndGifsAllowed() {
        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_STICKER, null, "hi");
        tick();
        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_GIF, null, "rabbit_dance");
        tick();
        assertEquals(404, assertThrows(ApiException.class,
                () -> chat.send(an, ChatService.WORLD, null, ChatService.TYPE_STICKER, null, "khong-co")).status());
        assertEquals(404, assertThrows(ApiException.class,
                () -> chat.send(an, ChatService.WORLD, null, ChatService.TYPE_GIF, null,
                        "https://example.com/bay.gif")).status());
    }

    // ---------- Ghi âm ----------
    @Test
    void voiceMustBeOwnedAndWithinLimits() {
        var meta = chat.saveVoice(an, new byte[1024], 5000);
        assertNotNull(meta.voiceId());

        assertEquals(403, assertThrows(ApiException.class,
                () -> chat.send(binh, ChatService.WORLD, null, ChatService.TYPE_VOICE, null, meta.voiceId())).status(),
                "không dùng được ghi âm của người khác");

        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_VOICE, null, meta.voiceId());
        assertEquals(1024, chat.readVoice(binh, meta.voiceId()).length, "tin ở kênh thế giới thì ai cũng nghe được");

        assertEquals(413, assertThrows(ApiException.class,
                () -> chat.saveVoice(an, new byte[ChatVoiceStore.MAX_BYTES + 1], 5000)).status());
        assertEquals(400, assertThrows(ApiException.class,
                () -> chat.saveVoice(an, new byte[10], ChatVoiceStore.MAX_DURATION_MS + 1)).status());
    }

    @Test
    void privateVoiceNotReadableByOutsider() {
        var meta = chat.saveVoice(an, new byte[64], 2000);
        chat.send(an, ChatService.PRIVATE, binh, ChatService.TYPE_VOICE, null, meta.voiceId());
        assertEquals(64, chat.readVoice(binh, meta.voiceId()).length);

        int nguoiLa = players.guestLogin(null).playerId();
        assertEquals(403, assertThrows(ApiException.class,
                () -> chat.readVoice(nguoiLa, meta.voiceId())).status());
    }

    // ---------- Báo cáo & admin ----------
    @Test
    void reportOncePerMessage() {
        var sent = chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin bị báo cáo", null);
        chat.report(binh, sent.id(), "nội dung khó chịu");
        assertEquals(1, chat.reports(50).size());
        assertEquals(409, assertThrows(ApiException.class,
                () -> chat.report(binh, sent.id(), "lần nữa")).status());
        assertEquals(404, assertThrows(ApiException.class, () -> chat.report(binh, 99999, "x")).status());
    }

    @Test
    void adminDeleteHidesContentButKeepsLog() {
        var sent = chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin xấu", null);
        chat.deleteMessage(sent.id(), 0);

        var seen = chat.world(binh, null, 50).get(0);
        assertTrue(seen.deleted());
        assertEquals("(tin nhắn đã bị xoá)", seen.text());

        var log = chat.adminLog(null, null, 50);
        assertEquals("tin xấu", log.get(0).text(), "log admin vẫn giữ nội dung gốc để tra cứu");
        assertEquals(404, assertThrows(ApiException.class, () -> chat.deleteMessage(sent.id(), 0)).status());
    }

    @Test
    void adminBanAndUnban() {
        chat.banChat(an, 30, "quấy rối");
        assertTrue(chat.banInfo(an).banned());
        assertEquals(403, assertThrows(ApiException.class,
                () -> chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "hi", null)).status());

        chat.unbanChat(an);
        assertFalse(chat.banInfo(an).banned());
        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "hi", null);
    }
}
