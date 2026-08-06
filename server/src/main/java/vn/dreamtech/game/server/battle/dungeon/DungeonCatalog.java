package vn.dreamtech.game.server.battle.dungeon;

import java.util.List;
import java.util.Optional;

/** Danh mục dungeon (tĩnh, giống {@code StoryLevelCatalog}) — 4 dungeon, mỗi cái 3 tầng. */
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
            ), 130, 350),
            new DungeonDef(3, "Hầm ngục dung nham", List.of(
                    new FloorDef(300, 16),
                    new FloorDef(380, 20),
                    new FloorDef(470, 25)
            ), 180, 500),
            new DungeonDef(4, "Hầm ngục bóng tối", List.of(
                    new FloorDef(420, 20),
                    new FloorDef(520, 25),
                    new FloorDef(640, 30)
            ), 240, 650)
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
