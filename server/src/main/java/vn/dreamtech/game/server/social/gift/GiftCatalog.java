package vn.dreamtech.game.server.social.gift;

import java.util.Map;
import java.util.Optional;

/**
 * Game mới chưa có hệ ví/xu (chưa làm shop/economy) — quà tặng hiện chưa
 * tốn tiền, chỉ giới hạn 1 lần/cặp bạn/ngày (xem
 * {@link vn.dreamtech.game.server.social.gift.SendGiftHandler#GIFT_COOLDOWN_MS})
 * để tránh spam max điểm thân mật tức thì. TODO: khi có ví/xu, đổi quà tặng
 * sang tốn xu thay vì chỉ giới hạn theo thời gian.
 */
public final class GiftCatalog {
    private static final Map<String, GiftDef> GIFTS = Map.of(
            "flower", new GiftDef("flower", 10),
            "chocolate", new GiftDef("chocolate", 25),
            "teddy_bear", new GiftDef("teddy_bear", 50),
            "jewelry", new GiftDef("jewelry", 100)
    );

    public static Optional<GiftDef> find(String id) {
        return Optional.ofNullable(GIFTS.get(id));
    }

    private GiftCatalog() {
    }
}
