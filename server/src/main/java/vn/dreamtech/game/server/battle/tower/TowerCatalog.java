package vn.dreamtech.game.server.battle.tower;

import java.util.List;
import java.util.Optional;

/** Danh mục tháp (tĩnh) — MVP 1 tháp, 30 tầng. */
public final class TowerCatalog {
    private static final List<TowerDef> TOWERS = List.of(
            new TowerDef(1, "Tháp vô tận", 100, 15, 5, 1, 30, 15, 25)
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
