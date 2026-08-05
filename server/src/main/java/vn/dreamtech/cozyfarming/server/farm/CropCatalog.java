package vn.dreamtech.cozyfarming.server.farm;

import java.util.Map;
import java.util.Optional;

/**
 * 18 cây trồng đã đồng bộ số liệu với Lttt thật ở phía client
 * (`src/data/crops.ts`) — chép nguyên số liệu sang đây, KHÔNG đổi. Cây mới
 * thêm ở client thì thêm dòng tương ứng ở đây (giữ 2 bảng khớp nhau bằng
 * tay, chưa có cơ chế tự đồng bộ — ghi rõ TODO cho giai đoạn sau).
 */
public final class CropCatalog {
    // TODO(giai đoạn sau): sinh bảng này tự động từ crops.ts thay vì chép tay,
    // tránh 2 bên lệch nhau khi client thêm/đổi cây trồng mới.
    private static final Map<String, CropDef> CROPS = Map.ofEntries(
            Map.entry("carrot", new CropDef("carrot", 2, 1, 2, 18, 3)),
            Map.entry("turnip", new CropDef("turnip", 4, 1, 2, 26, 4)),
            Map.entry("potato", new CropDef("potato", 8, 1, 3, 45, 6)),
            Map.entry("tomato", new CropDef("tomato", 15, 2, 3, 70, 9)),
            Map.entry("cabbage", new CropDef("cabbage", 25, 1, 2, 110, 12)),
            Map.entry("pumpkin", new CropDef("pumpkin", 45, 1, 1, 190, 18)),
            Map.entry("grape", new CropDef("grape", 60, 1, 2, 250, 22)),
            Map.entry("strawberry", new CropDef("strawberry", 30, 2, 4, 150, 14)),
            Map.entry("corn", new CropDef("corn", 40, 2, 3, 170, 16)),
            Map.entry("eggplant", new CropDef("eggplant", 35, 1, 2, 160, 15)),
            Map.entry("chili", new CropDef("chili", 20, 2, 3, 95, 10)),
            Map.entry("wheat", new CropDef("wheat", 90, 2, 3, 380, 30)),
            Map.entry("onion", new CropDef("onion", 120, 1, 2, 520, 40)),
            Map.entry("broccoli", new CropDef("broccoli", 75, 1, 2, 310, 26)),
            Map.entry("rose", new CropDef("rose", 22, 1, 2, 104, 7)),
            Map.entry("tulip", new CropDef("tulip", 32, 1, 2, 146, 11)),
            Map.entry("watermelon", new CropDef("watermelon", 48, 1, 1, 214, 16)),
            Map.entry("sunflower", new CropDef("sunflower", 55, 1, 2, 244, 18))
    );

    public static Optional<CropDef> find(String id) {
        return Optional.ofNullable(CROPS.get(id));
    }

    private CropCatalog() {
    }
}
