package vn.dreamtech.game.server.battle;

import java.util.List;
import java.util.Optional;

/**
 * Danh mục màn Story (tĩnh, giống {@code CosmeticCatalog}/{@code
 * GiftCatalog}) — MVP chỉ 3 màn tuyến tính, chưa có cốt truyện/hội thoại
 * thật. Adventure/Daily/Weekly/Event Puzzle và toàn bộ PvP/PvE khác (Dungeon,
 * Tower, Raid, Boss Rush, World Boss, Guild Boss, Ranked, Guild War...) CHƯA
 * làm — để giai đoạn sau khi lõi match-3 đã ổn định.
 */
public final class StoryLevelCatalog {
    private static final List<StoryLevelDef> LEVELS = List.of(
            new StoryLevelDef(1, "Cánh đồng ban mai", 150, 8, 20, 50),
            new StoryLevelDef(2, "Khu rừng thì thầm", 250, 12, 35, 90),
            new StoryLevelDef(3, "Hang động bí ẩn", 400, 18, 60, 150)
    );

    public static List<StoryLevelDef> all() {
        return LEVELS;
    }

    public static Optional<StoryLevelDef> find(int id) {
        return LEVELS.stream().filter(l -> l.id() == id).findFirst();
    }

    private StoryLevelCatalog() {
    }
}
