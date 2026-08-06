package vn.dreamtech.game.server.battle.dungeon;

import java.util.List;
import java.util.Optional;

/** Danh mục dungeon (tĩnh, giống {@code StoryLevelCatalog}) — MVP 2 dungeon, mỗi cái 3 tầng. */
public final class DungeonCatalog {
    private static final List<DungeonDef> DUNGEONS = List.of(
            new DungeonDef(1, "Hầm ngục đá cổ", List.of(
                    new FloorDef(120, 8),
                    new FloorDef(160, 10),
                    new FloorDef(220, 14)
            ), 80, 200),
            new DungeonDef(2, "Hầm ngục băng giá", List.of(
                    new FloorDef(200, 12),
                    new FloorDef(260, 16),
                    new FloorDef(340, 20)
            ), 130, 350)
    );

    public static List<DungeonDef> all() {
        return DUNGEONS;
    }

    public static Optional<DungeonDef> find(int id) {
        return DUNGEONS.stream().filter(d -> d.id() == id).findFirst();
    }

    private DungeonCatalog() {
    }
}
