package vn.dreamtech.myzoo.server.catalog;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

// Danh mục tĩnh MVP (spec RULE 04: data-driven, không hardcode trong gameplay code).
// Mỗi crop thu hoạch ra đúng 1 loại food cùng id; species ăn danh sách food chấp nhận được.
public final class Catalog {
    public record CropDef(String id, String name, long seedCost, int growthSeconds, int yieldMin, int yieldMax, int xp,
                          long sellPrice, int minFarmLevel) {
    }

    public record SpeciesDef(String id, String name, long cost, List<String> diet, int appeal, String rarity, int minZooLevel) {
    }

    public record HabitatTypeDef(String id, String name, long cost, int capacity, int minZooLevel) {
    }

    public static final List<CropDef> CROPS = List.of(
            new CropDef("wheat", "Lúa mì", 100, 60, 2, 3, 5, 55, 1),
            new CropDef("corn", "Ngô", 150, 120, 2, 4, 8, 65, 2),
            new CropDef("carrot", "Cà rốt", 120, 90, 2, 3, 6, 60, 1),
            new CropDef("lettuce", "Xà lách", 130, 100, 2, 3, 7, 65, 2),
            new CropDef("potato", "Khoai tây", 180, 180, 3, 5, 10, 70, 3),
            new CropDef("grass", "Cỏ khô", 80, 45, 3, 5, 4, 30, 1),
            new CropDef("bamboo", "Tre", 250, 300, 2, 3, 14, 130, 5),
            new CropDef("berry", "Dâu rừng", 200, 240, 2, 4, 12, 90, 4)
    );

    public static final List<SpeciesDef> SPECIES = List.of(
            new SpeciesDef("rabbit", "Thỏ", 500, List.of("carrot", "lettuce"), 5, "R", 1),
            new SpeciesDef("sheep", "Cừu", 800, List.of("grass", "wheat"), 7, "R", 1),
            new SpeciesDef("monkey", "Khỉ", 1500, List.of("berry", "corn"), 12, "SR", 2),
            new SpeciesDef("giraffe", "Hươu cao cổ", 2500, List.of("lettuce", "grass"), 18, "SR", 3),
            new SpeciesDef("elephant", "Voi", 4000, List.of("grass", "berry", "potato"), 25, "SSR", 4),
            new SpeciesDef("panda", "Gấu trúc", 6000, List.of("bamboo"), 35, "SSR", 5)
    );

    public static final List<HabitatTypeDef> HABITAT_TYPES = List.of(
            new HabitatTypeDef("meadow", "Đồng cỏ", 400, 3, 1),
            new HabitatTypeDef("forest", "Chuồng rừng", 900, 3, 2),
            new HabitatTypeDef("grove", "Rừng tre", 2000, 2, 4)
    );

    private static final Map<String, CropDef> CROP_BY_ID = index(CROPS, CropDef::id);
    private static final Map<String, SpeciesDef> SPECIES_BY_ID = index(SPECIES, SpeciesDef::id);
    private static final Map<String, HabitatTypeDef> HABITAT_BY_ID = index(HABITAT_TYPES, HabitatTypeDef::id);

    // Thành phẩm chế biến: không trồng được, chỉ bán. Giá cao hơn tổng nguyên liệu.
    public record ProductDef(String id, String name, long sellPrice) {
    }

    public static final List<ProductDef> PRODUCTS = List.of(
            new ProductDef("flour", "Bột mì", 220),
            new ProductDef("bread", "Bánh mì", 560),
            new ProductDef("carrot_cake", "Bánh cà rốt", 320),
            new ProductDef("berry_jam", "Mứt dâu", 360),
            new ProductDef("egg", "Trứng gà", 45),
            new ProductDef("duck_egg", "Trứng vịt", 55),
            new ProductDef("milk", "Sữa bò", 90),
            new ProductDef("goat_milk", "Sữa dê", 110),
            new ProductDef("truffle", "Nấm cục", 150),
            new ProductDef("cheese", "Phô mai", 380),
            new ProductDef("cake", "Bánh kem", 520));

    // Vật nuôi: ăn nông sản rồi sinh sản phẩm sau một khoảng thời gian.
    // Không trùng loài với sở thú (spec liệt kê cừu nhưng cừu đã là thú sở thú, nên đổi sang dê).
    public record LivestockDef(String id, String name, long cost, String foodId, int foodQty,
                               String productId, int productQty, int productSeconds, int minFarmLevel) {
    }

    public static final List<LivestockDef> LIVESTOCK = List.of(
            new LivestockDef("chicken", "Gà", 600, "wheat", 1, "egg", 2, 300, 1),
            new LivestockDef("duck", "Vịt", 800, "corn", 1, "duck_egg", 2, 420, 2),
            new LivestockDef("goat", "Dê", 1600, "grass", 2, "goat_milk", 1, 600, 3),
            new LivestockDef("cow", "Bò", 2400, "grass", 3, "milk", 2, 900, 4),
            new LivestockDef("pig", "Heo", 3200, "potato", 2, "truffle", 1, 1200, 5));

    public static Optional<LivestockDef> livestock(String id) {
        return LIVESTOCK.stream().filter(l -> l.id().equals(id)).findFirst();
    }

    // Trang trí chuồng: cộng thẳng vào độ hấp dẫn khi chuồng có thú đã được cho ăn.
    public record DecorDef(String id, String name, long cost, int appealBonus, int minZooLevel) {
    }

    public static final List<DecorDef> DECORS = List.of(
            new DecorDef("rock", "Tảng đá", 600, 3, 1),
            new DecorDef("pond", "Hồ nước nhỏ", 1500, 8, 2),
            new DecorDef("tree", "Cây cổ thụ", 2600, 14, 3),
            new DecorDef("fountain", "Đài phun nước", 5000, 25, 4));

    public static Optional<ProductDef> product(String id) {
        return PRODUCTS.stream().filter(p -> p.id().equals(id)).findFirst();
    }

    public static Optional<DecorDef> decor(String id) {
        return DECORS.stream().filter(d -> d.id().equals(id)).findFirst();
    }

    // Giá bán chung cho cả nông sản lẫn thành phẩm.
    public static Optional<Long> sellPrice(String foodId) {
        var c = crop(foodId);
        if (c.isPresent()) return Optional.of(c.get().sellPrice());
        return product(foodId).map(ProductDef::sellPrice);
    }

    public static String displayName(String foodId) {
        var c = crop(foodId);
        if (c.isPresent()) return c.get().name();
        return product(foodId).map(ProductDef::name).orElse(foodId);
    }

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
