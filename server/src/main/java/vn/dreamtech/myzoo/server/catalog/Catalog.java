package vn.dreamtech.myzoo.server.catalog;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

// Danh mục tĩnh MVP (spec RULE 04: data-driven, không hardcode trong gameplay code).
// Mỗi crop thu hoạch ra đúng 1 loại food cùng id; species ăn danh sách food chấp nhận được.
public final class Catalog {
    public record CropDef(String id, String name, long seedCost, int growthSeconds, int yieldMin, int yieldMax, int xp) {
    }

    public record SpeciesDef(String id, String name, long cost, List<String> diet, int appeal, String rarity) {
    }

    public record HabitatTypeDef(String id, String name, long cost, int capacity) {
    }

    public static final List<CropDef> CROPS = List.of(
            new CropDef("wheat", "Lúa mì", 100, 60, 2, 3, 5),
            new CropDef("corn", "Ngô", 150, 120, 2, 4, 8),
            new CropDef("carrot", "Cà rốt", 120, 90, 2, 3, 6),
            new CropDef("lettuce", "Xà lách", 130, 100, 2, 3, 7),
            new CropDef("potato", "Khoai tây", 180, 180, 3, 5, 10),
            new CropDef("grass", "Cỏ khô", 80, 45, 3, 5, 4),
            new CropDef("bamboo", "Tre", 250, 300, 2, 3, 14),
            new CropDef("berry", "Dâu rừng", 200, 240, 2, 4, 12)
    );

    public static final List<SpeciesDef> SPECIES = List.of(
            new SpeciesDef("rabbit", "Thỏ", 500, List.of("carrot", "lettuce"), 5, "R"),
            new SpeciesDef("sheep", "Cừu", 800, List.of("grass", "wheat"), 7, "R"),
            new SpeciesDef("monkey", "Khỉ", 1500, List.of("berry", "corn"), 12, "SR"),
            new SpeciesDef("giraffe", "Hươu cao cổ", 2500, List.of("lettuce", "grass"), 18, "SR"),
            new SpeciesDef("elephant", "Voi", 4000, List.of("grass", "berry", "potato"), 25, "SSR"),
            new SpeciesDef("panda", "Gấu trúc", 6000, List.of("bamboo"), 35, "SSR")
    );

    public static final List<HabitatTypeDef> HABITAT_TYPES = List.of(
            new HabitatTypeDef("meadow", "Đồng cỏ", 400, 3),
            new HabitatTypeDef("forest", "Chuồng rừng", 900, 3),
            new HabitatTypeDef("grove", "Rừng tre", 2000, 2)
    );

    private static final Map<String, CropDef> CROP_BY_ID = index(CROPS, CropDef::id);
    private static final Map<String, SpeciesDef> SPECIES_BY_ID = index(SPECIES, SpeciesDef::id);
    private static final Map<String, HabitatTypeDef> HABITAT_BY_ID = index(HABITAT_TYPES, HabitatTypeDef::id);

    public static Optional<CropDef> crop(String id) {
        return Optional.ofNullable(CROP_BY_ID.get(id));
    }

    public static Optional<SpeciesDef> species(String id) {
        return Optional.ofNullable(SPECIES_BY_ID.get(id));
    }

    public static Optional<HabitatTypeDef> habitatType(String id) {
        return Optional.ofNullable(HABITAT_BY_ID.get(id));
    }

    private static <T> Map<String, T> index(List<T> list, java.util.function.Function<T, String> key) {
        return list.stream().collect(Collectors.toMap(key, v -> v));
    }

    private Catalog() {
    }
}
