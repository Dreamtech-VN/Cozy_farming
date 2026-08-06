package vn.dreamtech.game.server.battle;

import java.util.List;
import java.util.Optional;

/**
 * Danh mục màn Story (tĩnh, giống {@code CosmeticCatalog}/{@code
 * GiftCatalog}) — 6 màn tuyến tính, chưa có cốt truyện/hội thoại thật.
 * Raid/Boss Rush/Guild War CHƯA làm — để giai đoạn sau.
 */
public final class StoryLevelCatalog {
    private static final List<StoryLevelDef> LEVELS = List.of(
            new StoryLevelDef(1, "Cánh đồng ban mai", 150, 8, 20, 50),
            new StoryLevelDef(2, "Khu rừng thì thầm", 250, 12, 35, 90),
            new StoryLevelDef(3, "Hang động bí ẩn", 400, 18, 60, 150),
            new StoryLevelDef(4, "Đỉnh núi sương mù", 550, 22, 85, 210),
            new StoryLevelDef(5, "Sa mạc cháy khát", 700, 26, 110, 280),
            new StoryLevelDef(6, "Thành trì bỏ hoang", 900, 30, 140, 360)
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
