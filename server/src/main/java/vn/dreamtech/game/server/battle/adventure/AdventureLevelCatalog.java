package vn.dreamtech.game.server.battle.adventure;

import java.util.List;
import java.util.Optional;

/** Danh mục màn Adventure (tĩnh, giống {@code StoryLevelCatalog}) — 4 màn, không tuyến tính bắt buộc (chơi thứ tự nào cũng được, khác Story). */
public final class AdventureLevelCatalog {
    private static final List<AdventureLevelDef> LEVELS = List.of(
            new AdventureLevelDef(1, "Ốc đảo lạc lối", 180, 10, 25, 60),
            new AdventureLevelDef(2, "Vịnh san hô", 260, 14, 40, 100),
            new AdventureLevelDef(3, "Đầm lầy mù sương", 340, 18, 55, 140),
            new AdventureLevelDef(4, "Vực thẳm cổ đại", 480, 24, 75, 190)
    );

    public static List<AdventureLevelDef> all() {
        return LEVELS;
    }

    public static Optional<AdventureLevelDef> find(int id) {
        return LEVELS.stream().filter(l -> l.id() == id).findFirst();
    }

    private AdventureLevelCatalog() {
    }
}
