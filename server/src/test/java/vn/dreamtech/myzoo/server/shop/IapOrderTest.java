package vn.dreamtech.myzoo.server.shop;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.myzoo.server.TestSupport;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.farm.FarmService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;

import javax.sql.DataSource;

import static org.junit.jupiter.api.Assertions.*;

// Cờ cho phép cổng MOCK được tiêm thẳng vào ShopService nên kiểm được cả hai nhánh bật/tắt,
// không phụ thuộc biến môi trường lúc chạy test.
class IapOrderTest {
    DataSource db;
    TestSupport.FakeTime time;
    EconomyService economy;
    PlayerService players;
    ShopService shop;      // cổng MOCK đang bật
    ShopService locked;    // chưa cấu hình thanh toán
    int an;

    static final long SMALL_PACK_KC = ShopCatalog.pack("kc_small").orElseThrow().kcAmount();

    @BeforeEach
    void setUp() {
        db = TestSupport.newDb();
        time = new TestSupport.FakeTime();
        economy = new EconomyService(db, time);
        players = new PlayerService(db, economy, time);
        var farm = new FarmService(db, economy, players, time);
        shop = new ShopService(db, economy, players, farm, time, new IapVerifier(true));
        locked = new ShopService(db, economy, players, farm, time, new IapVerifier(false));
        an = players.guestLogin(null).playerId();
        players.createCharacter(an, "An", "farmer_1");
    }

    long kc() {
        return economy.balances(an).get(EconomyService.KIM_CUONG);
    }

    // Chưa cấu hình thanh toán thì mọi đường cộng Kim Cương phải đóng. Đây từng là lỗ hổng thật:
    // /v1/shop/topup trước đây ai gọi cũng được, tức là tự in tiền.
    @Test
    void everyFreeDiamondPathIsClosedWhenPaymentIsNotConfigured() {
        assertEquals(503, assertThrows(ApiException.class, () -> locked.topup(an, "kc_small")).status());
        assertEquals(503, assertThrows(ApiException.class,
                () -> locked.verifyAndGrant(an, IapVerifier.MOCK, "kc_small", "bien-nhan")).status());
        assertEquals(0, kc(), "không được cộng đồng nào");
    }

    @Test
    void verifiedPurchaseGrantsDiamondsAndRecordsOrder() {
        var order = shop.verifyAndGrant(an, IapVerifier.MOCK, "kc_small", "hoa-don-1");

        assertFalse(order.alreadyGranted());
        assertEquals(SMALL_PACK_KC, order.kcAdded());
        assertEquals(SMALL_PACK_KC, kc());

        var orders = shop.orders(an, 10);
        assertEquals(1, orders.size());
        assertEquals("GRANTED", orders.get(0).status());
        assertEquals("kc_small", orders.get(0).productId());
    }

    // Đây là bảo vệ quan trọng nhất: gửi lại cùng một biên nhận không được cộng tiền lần hai.
    @Test
    void sameReceiptNeverGrantsTwice() {
        shop.verifyAndGrant(an, IapVerifier.MOCK, "kc_small", "hoa-don-2");
        long after = kc();

        var again = shop.verifyAndGrant(an, IapVerifier.MOCK, "kc_small", "hoa-don-2");
        assertTrue(again.alreadyGranted());
        assertEquals(0, again.kcAdded());
        assertEquals(after, kc(), "gửi lại biên nhận cũ không được cộng thêm");
        assertEquals(1, shop.orders(an, 10).size(), "chỉ có đúng một đơn hàng");
    }

    @Test
    void differentReceiptsGrantSeparately() {
        shop.verifyAndGrant(an, IapVerifier.MOCK, "kc_small", "hoa-don-3");
        shop.verifyAndGrant(an, IapVerifier.MOCK, "kc_small", "hoa-don-4");
        assertEquals(SMALL_PACK_KC * 2, kc());
        assertEquals(2, shop.orders(an, 10).size());
    }

    @Test
    void purchaseIsWrittenToTheLedger() {
        shop.verifyAndGrant(an, IapVerifier.MOCK, "kc_small", "hoa-don-5");
        assertTrue(economy.history(an, null, 20).stream().anyMatch(e -> e.reason().equals("IAP")),
                "mọi lần nạp phải có dòng sổ cái");
    }

    @Test
    void unknownPackOrProviderRejected() {
        assertEquals(404, assertThrows(ApiException.class,
                () -> shop.verifyAndGrant(an, IapVerifier.MOCK, "khong-co", "x")).status());
        assertEquals(400, assertThrows(ApiException.class,
                () -> shop.verifyAndGrant(an, "PAYPAL", "kc_small", "x")).status());
        assertEquals(400, assertThrows(ApiException.class,
                () -> shop.verifyAndGrant(an, IapVerifier.MOCK, "kc_small", "")).status());
    }

    // Chưa cấu hình khoá của store thì phải từ chối, không được im lặng cộng tiền.
    @Test
    void realProvidersRefuseWhenNotConfigured() {
        if (IapVerifier.googlePackage() == null) {
            assertEquals(503, assertThrows(ApiException.class,
                    () -> shop.verifyAndGrant(an, IapVerifier.GOOGLE_PLAY, "kc_small", "token")).status());
        }
        if (IapVerifier.appStoreSecret() == null) {
            assertEquals(503, assertThrows(ApiException.class,
                    () -> shop.verifyAndGrant(an, IapVerifier.APP_STORE, "kc_small", "receipt")).status());
        }
    }

    @Test
    void ordersAreScopedToTheBuyer() {
        shop.verifyAndGrant(an, IapVerifier.MOCK, "kc_small", "hoa-don-6");
        int binh = players.guestLogin(null).playerId();
        players.createCharacter(binh, "Bình", "farmer_2");
        assertTrue(shop.orders(binh, 10).isEmpty(), "không thấy đơn hàng của người khác");
    }
}
