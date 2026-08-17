package vn.dreamtech.myzoo.server.catalog;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

// Đồ ngoại hình cho gacha. Spec §27.20: gacha chỉ bán ngoại hình/sưu tầm, không bán sức mạnh —
// nên ở đây không có thú và không có trang trí cộng độ hấp dẫn.
public final class CosmeticCatalog {
    public static final String AVATAR = "AVATAR";
    public static final String ZOO_SKIN = "ZOO_SKIN";

    public static final String R = "R";
    public static final String SR = "SR";
    public static final String SSR = "SSR";
    public static final String UR = "UR";

    public record CosmeticDef(String id, String name, String kind, String tier) {
    }

    // Ngoại hình gốc: ai cũng có sẵn, không nằm trong pool gacha.
    // Thêm ngoại hình mặc định vào màn tạo nhân vật thì phải thêm id vào đây, không thì server chặn.
    public static final List<String> STARTER_AVATARS = List.of("farmer_1", "farmer_2", "farmer_3", "keeper_1");

    public static final List<CosmeticDef> COSMETICS = List.of(
            new CosmeticDef("av_straw_hat", "Nón lá rơm", AVATAR, R),
            new CosmeticDef("av_overall", "Yếm xanh", AVATAR, R),
            new CosmeticDef("av_boots", "Ủng vàng", AVATAR, R),
            new CosmeticDef("av_scarf", "Khăn quàng đỏ", AVATAR, R),
            new CosmeticDef("av_raincoat", "Áo mưa vàng", AVATAR, SR),
            new CosmeticDef("av_zookeeper", "Đồng phục sở thú", AVATAR, SR),
            new CosmeticDef("av_chef", "Đồ đầu bếp", AVATAR, SR),
            new CosmeticDef("av_festival", "Áo dài hội làng", AVATAR, SSR),
            new CosmeticDef("av_moonlight", "Bộ ánh trăng", AVATAR, SSR),
            new CosmeticDef("av_golden", "Bộ hoàng kim", AVATAR, UR),

            new CosmeticDef("skin_fence_wood", "Hàng rào gỗ", ZOO_SKIN, R),
            new CosmeticDef("skin_path_stone", "Lối đi lát đá", ZOO_SKIN, R),
            new CosmeticDef("skin_lantern", "Đèn lồng", ZOO_SKIN, R),
            new CosmeticDef("skin_flower_bed", "Luống hoa", ZOO_SKIN, SR),
            new CosmeticDef("skin_waterfall", "Thác nước mini", ZOO_SKIN, SR),
            new CosmeticDef("skin_bamboo_gate", "Cổng tre", ZOO_SKIN, SSR),
            new CosmeticDef("skin_rainbow", "Cầu vồng", ZOO_SKIN, UR));

    private static final Map<String, CosmeticDef> BY_ID =
            COSMETICS.stream().collect(Collectors.toMap(CosmeticDef::id, Function.identity()));

    public static Optional<CosmeticDef> cosmetic(String id) {
        return Optional.ofNullable(BY_ID.get(id));
    }

    public static List<CosmeticDef> byTier(String tier) {
        return COSMETICS.stream().filter(c -> c.tier().equals(tier)).toList();
    }

    public static boolean isStarterAvatar(String id) {
        return STARTER_AVATARS.contains(id);
    }

    private CosmeticCatalog() {
    }
}
