package vn.dreamtech.cozyfarming.server.fishpond;

import java.util.Map;
import java.util.Optional;

/**
 * 3 loại cá giống chép nguyên số liệu từ {@code FRIES} trong
 * {@code src/systems/fishfarm.ts} — Pack5 không có bảng cá thật (`FishFarm`
 * kế thừa `AnimalDan` trong Lttt gốc, dùng chung pipeline với vật nuôi trên
 * cạn chứ không có dữ liệu loài cá riêng), nên vẫn dùng catalog cá do client
 * tự đặt (đã comment rõ trong file gốc), chỉ port đúng CÔNG THỨC.
 */
public final class FryCatalog {
    private static final Map<String, FryDef> FRIES = Map.of(
            "ca_ro", new FryDef("ca_ro", "Cá rô", 120, 20, 1, 2, 8),
            "ca_chep", new FryDef("ca_chep", "Cá chép", 300, 45, 1, 3, 18),
            "ca_tram", new FryDef("ca_tram", "Cá trắm", 700, 90, 2, 4, 34)
    );

    public static Optional<FryDef> find(String id) {
        return Optional.ofNullable(FRIES.get(id));
    }

    private FryCatalog() {
    }
}
