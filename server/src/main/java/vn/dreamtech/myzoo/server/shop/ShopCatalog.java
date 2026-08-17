package vn.dreamtech.myzoo.server.shop;

import java.util.List;
import java.util.Optional;

// Spec RULE: hai loại tiền tách bạch — mỗi món chỉ mua bằng ĐÚNG MỘT loại, không có
// endpoint nào đổi Kim Cương sang Vàng hay ngược lại.
public final class ShopCatalog {
    public static final String TYPE_FOOD = "FOOD";
    public static final String TYPE_GROW_BOOST = "GROW_BOOST";

    public record ItemDef(String id, String name, String description, String currency, long price,
                          String type, String param, int value) {
    }

    public record KcPack(String id, String name, long kcAmount, long priceVnd) {
    }

    public static final List<ItemDef> ITEMS = List.of(
            new ItemDef("food_carrot_10", "Bao cà rốt", "10 cà rốt vào kho nông trại",
                    "VANG", 700, TYPE_FOOD, "carrot", 10),
            new ItemDef("food_grass_20", "Bó cỏ khô lớn", "20 cỏ khô vào kho nông trại",
                    "VANG", 900, TYPE_FOOD, "grass", 20),
            new ItemDef("food_lettuce_10", "Thùng xà lách", "10 xà lách vào kho nông trại",
                    "VANG", 800, TYPE_FOOD, "lettuce", 10),
            new ItemDef("food_bamboo_5", "Bó tre", "5 tre vào kho nông trại",
                    "VANG", 1400, TYPE_FOOD, "bamboo", 5),
            new ItemDef("grow_boost", "Phân bón thần tốc", "Làm chín ngay 1 ô đang trồng",
                    "KC", 20, TYPE_GROW_BOOST, null, 1));

    // Giá VND chỉ để hiển thị — bản này thanh toán giả lập, chưa nối cổng thật.
    public static final List<KcPack> KC_PACKS = List.of(
            new KcPack("kc_small", "Túi Kim Cương nhỏ", 100, 20000),
            new KcPack("kc_medium", "Túi Kim Cương vừa", 550, 100000),
            new KcPack("kc_large", "Rương Kim Cương", 1200, 200000));

    public static Optional<ItemDef> item(String id) {
        return ITEMS.stream().filter(i -> i.id().equals(id)).findFirst();
    }

    public static Optional<KcPack> pack(String id) {
        return KC_PACKS.stream().filter(p -> p.id().equals(id)).findFirst();
    }

    private ShopCatalog() {
    }
}
