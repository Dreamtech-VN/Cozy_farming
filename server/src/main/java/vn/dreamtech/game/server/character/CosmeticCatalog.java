package vn.dreamtech.game.server.character;

import vn.dreamtech.game.server.model.CosmeticDef;
import vn.dreamtech.game.server.model.CosmeticType;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Danh mục vật phẩm làm đẹp (tĩnh, giống {@code GiftCatalog}) — chưa có hệ
 * shop/gacha thật nên id/tên tạm cố định trong code. TODO: chuyển sang bảng
 * DB thật khi có shop.
 */
public final class CosmeticCatalog {
    private static final List<CosmeticDef> ALL = List.of(
            new CosmeticDef(1, CosmeticType.EYES, "eyes_default"),
            new CosmeticDef(2, CosmeticType.EYES, "eyes_round"),
            new CosmeticDef(3, CosmeticType.EYES, "eyes_sharp"),
            new CosmeticDef(10, CosmeticType.AVATAR, "avatar_default"),
            new CosmeticDef(11, CosmeticType.AVATAR, "avatar_smile"),
            new CosmeticDef(20, CosmeticType.AVATAR_FRAME, "frame_bronze"),
            new CosmeticDef(21, CosmeticType.AVATAR_FRAME, "frame_gold"),
            new CosmeticDef(30, CosmeticType.TITLE, "title_newbie"),
            new CosmeticDef(31, CosmeticType.TITLE, "title_veteran"),
            new CosmeticDef(40, CosmeticType.EMOTE, "emote_wave"),
            new CosmeticDef(41, CosmeticType.EMOTE, "emote_laugh"),
            new CosmeticDef(50, CosmeticType.HAT, "hat_straw"),
            new CosmeticDef(51, CosmeticType.HAT, "hat_crown"),
            new CosmeticDef(60, CosmeticType.SHIRT, "shirt_casual"),
            new CosmeticDef(70, CosmeticType.PANTS, "pants_casual"),
            new CosmeticDef(80, CosmeticType.SHOES, "shoes_sneaker"),
            new CosmeticDef(90, CosmeticType.PET, "pet_cat"),
            new CosmeticDef(91, CosmeticType.PET, "pet_dog"),
            new CosmeticDef(100, CosmeticType.SKIN, "skin_default")
    );

    private static final Map<Integer, CosmeticDef> BY_ID = ALL.stream()
            .collect(java.util.stream.Collectors.toMap(CosmeticDef::id, d -> d));

    public static List<CosmeticDef> all() {
        return ALL;
    }

    public static Optional<CosmeticDef> find(int id) {
        return Optional.ofNullable(BY_ID.get(id));
    }

    private CosmeticCatalog() {
    }
}
