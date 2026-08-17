package vn.dreamtech.myzoo.server.chat;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.player.PlayerService;

import static org.junit.jupiter.api.Assertions.*;

// Long-poll chờ theo đồng hồ thật nên các test này dùng mốc thời gian ngắn (vài trăm ms).
class ChatLongPollTest {
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

    @Test
    void returnsImmediatelyWhenNewerMessageAlreadyExists() {
        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin cũ", null);

        long start = System.currentTimeMillis();
        chat.awaitNewMessage(0, 5000);
        assertTrue(System.currentTimeMillis() - start < 1000, "đã có tin mới hơn thì không được chờ");
    }

    @Test
    void waitsUntilTimeoutWhenNothingArrives() {
        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin đầu", null);
        long lastId = chat.world(binh, null, 10).get(0).id();

        long start = System.currentTimeMillis();
        chat.awaitNewMessage(lastId, 300);
        long waited = System.currentTimeMillis() - start;
        assertTrue(waited >= 250, "phải chờ gần hết thời gian, chờ được " + waited + "ms");
        assertTrue(waited < 3000, "nhưng không được treo quá lâu");
    }

    // Đây là điểm mấu chốt: tin của người khác phải đánh thức người đang chờ ngay lập tức.
    @Test
    void wakesUpEarlyWhenSomeoneSendsAMessage() throws Exception {
        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin đầu", null);
        long lastId = chat.world(binh, null, 10).get(0).id();

        var sender = new Thread(() -> {
            try {
                Thread.sleep(200);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            time.advance(ChatService.MIN_GAP_MS + 100);
            chat.send(binh, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin mới", null);
        });

        long start = System.currentTimeMillis();
        sender.start();
        chat.awaitNewMessage(lastId, 10_000);
        long waited = System.currentTimeMillis() - start;
        sender.join();

        assertTrue(waited < 5000, "phải bật dậy khi có tin, chờ " + waited + "ms");
        assertEquals(2, chat.world(binh, null, 10).size());
    }

    @Test
    void systemMessageAlsoWakesWaiters() throws Exception {
        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin đầu", null);
        long lastId = chat.world(binh, null, 10).get(0).id();

        var announcer = new Thread(() -> {
            try {
                Thread.sleep(150);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            chat.system("Máy chủ bảo trì lúc 22h");
        });

        long start = System.currentTimeMillis();
        announcer.start();
        chat.awaitNewMessage(lastId, 10_000);
        announcer.join();
        assertTrue(System.currentTimeMillis() - start < 5000, "thông báo hệ thống cũng phải đánh thức");
    }

    @Test
    void waitIsCappedSoNoRequestHangsForever() {
        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin đầu", null);
        long lastId = chat.world(binh, null, 10).get(0).id();

        long start = System.currentTimeMillis();
        chat.awaitNewMessage(lastId, 100);   // xin chờ ít thì được trả về sớm
        assertTrue(System.currentTimeMillis() - start < 2000);
        assertTrue(ChatService.MAX_WAIT_MS <= 30_000, "trần chờ phải nhỏ hơn timeout mặc định của proxy");
    }

    @Test
    void manyWaitersAreAllWokenByOneMessage() throws Exception {
        chat.send(an, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin đầu", null);
        long lastId = chat.world(binh, null, 10).get(0).id();

        int waiters = 20;
        var threads = new Thread[waiters];
        var done = new java.util.concurrent.atomic.AtomicInteger();
        for (int i = 0; i < waiters; i++) {
            threads[i] = Thread.ofVirtual().start(() -> {
                chat.awaitNewMessage(lastId, 10_000);
                done.incrementAndGet();
            });
        }
        Thread.sleep(200);
        time.advance(ChatService.MIN_GAP_MS + 100);
        chat.send(binh, ChatService.WORLD, null, ChatService.TYPE_TEXT, "tin mới", null);
        for (Thread t : threads) t.join(5000);

        assertEquals(waiters, done.get(), "một tin phải đánh thức tất cả người đang chờ");
    }
}
