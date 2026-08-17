package vn.dreamtech.myzoo.server.config;

import java.util.List;

// Cấu hình cho màn Splash (S01) và Server List (S06). Đổi ở đây, client không cần build lại.
public final class GameConfig {
    public static final String GAME_VERSION = "0.1.0";
    public static final String MIN_CLIENT_VERSION = "0.1.0";

    public record ServerDef(String id, String name, String region, String status, String population,
                            boolean recommended) {
    }

    // status: ONLINE | MAINTENANCE | FULL | LOCKED
    public static final List<ServerDef> SERVERS = List.of(
            new ServerDef("s1", "Đồng Cỏ Xanh", "VN", "ONLINE", "SMOOTH", true),
            new ServerDef("s2", "Rừng Tre", "VN", "ONLINE", "BUSY", false));

    // Endpoint admin chỉ bật khi có ADMIN_TOKEN — mặc định tắt hoàn toàn cho an toàn.
    public static String adminToken() {
        return System.getenv("ADMIN_TOKEN");
    }

    public static boolean maintenance() {
        return Boolean.parseBoolean(System.getenv().getOrDefault("MAINTENANCE", "false"));
    }

    public static String maintenanceMessage() {
        return System.getenv().getOrDefault("MAINTENANCE_MESSAGE", "Máy chủ đang bảo trì, quay lại sau nhé!");
    }

    public static boolean isValidServer(String serverId) {
        return SERVERS.stream().anyMatch(s -> s.id().equals(serverId));
    }

    public static boolean isJoinable(String serverId) {
        return SERVERS.stream().anyMatch(s -> s.id().equals(serverId) && "ONLINE".equals(s.status()));
    }

    private GameConfig() {
    }
}
