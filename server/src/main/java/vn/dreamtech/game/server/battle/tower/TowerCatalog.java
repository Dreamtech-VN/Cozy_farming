package vn.dreamtech.game.server.battle.tower;

import java.util.List;
import java.util.Optional;

/** Danh mục tháp (tĩnh) — 2 tháp: 1 tháp thường (30 tầng) + 1 tháp cao cấp khó hơn (50 tầng, thưởng cao hơn). */
public final class TowerCatalog {
    private static final List<TowerDef> TOWERS = List.of(
            new TowerDef(1, "Tháp vô tận", 100, 15, 5, 1, 30, 15, 25),
            new TowerDef(2, "Tháp hắc ám", 200, 30, 10, 2, 50, 25, 45)
    );

    public static List<TowerDef> all() {
        return TOWERS;
    }

    public static Optional<TowerDef> find(int id) {
        return TOWERS.stream().filter(t -> t.id() == id).findFirst();
    }

    private TowerCatalog() {
    }
}
