package vn.dreamtech.cozyfarming.server.livestock;

import java.util.Map;
import java.util.Optional;

/** 4 vật nuôi hiện có, chép nguyên số liệu từ `src/data/animals.ts` (TODO: sinh tự động ở giai đoạn sau). */
public final class AnimalCatalog {
    private static final Map<String, AnimalDef> ANIMALS = Map.of(
            "chicken", new AnimalDef("chicken", 300, "egg", 1, 3, 10, 7, 6),
            "cow", new AnimalDef("cow", 1500, "milk", 1, 2, 30, 20, 15),
            "pig", new AnimalDef("pig", 900, "meat", 1, 2, 20, 13, 10),
            "sheep", new AnimalDef("sheep", 1200, "wool", 1, 1, 45, 30, 14)
    );

    public static Optional<AnimalDef> find(String id) {
        return Optional.ofNullable(ANIMALS.get(id));
    }

    private AnimalCatalog() {
    }
}
