package vn.dreamtech.game.server.battle.eventpuzzle;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

/**
 * Danh mục Event Puzzle (tĩnh) — MVP đặt cứng ngày bắt đầu/kết thúc trong
 * code (giống lịch sự kiện thật, không phải tương đối theo lúc server
 * khởi động). TODO: khi có công cụ quản trị (admin tool), chuyển sang cấu
 * hình được từ DB thay vì sửa code mỗi lần thêm sự kiện mới.
 */
public final class EventPuzzleCatalog {
    private static final List<EventPuzzleDef> EVENTS = List.of(
            new EventPuzzleDef(1, "Lễ hội mùa hè", 260, 14, 100, 250,
                    Instant.parse("2026-08-01T00:00:00Z").toEpochMilli(),
                    Instant.parse("2026-08-31T23:59:59Z").toEpochMilli()),
            new EventPuzzleDef(2, "Lễ hội Trung Thu", 320, 16, 120, 300,
                    Instant.parse("2026-09-15T00:00:00Z").toEpochMilli(),
                    Instant.parse("2026-09-25T23:59:59Z").toEpochMilli())
    );

    public static List<EventPuzzleDef> all() {
        return EVENTS;
    }

    public static Optional<EventPuzzleDef> find(int id) {
        return EVENTS.stream().filter(e -> e.id() == id).findFirst();
    }

    private EventPuzzleCatalog() {
    }
}
