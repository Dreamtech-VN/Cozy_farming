package vn.dreamtech.game.server.admin;

import com.sun.net.httpserver.HttpExchange;
import vn.dreamtech.game.server.item.ItemException;

/**
 * Xác thực admin bằng shared-secret qua header {@code X-Admin-Token} — chưa
 * có hệ tài khoản admin/phân quyền thật (RBAC), MVP đủ để chặn người ngoài
 * gọi thẳng endpoint quản trị. Cần biến môi trường {@code ADMIN_TOKEN};
 * CHƯA đặt thì mọi request admin đều bị từ chối (an toàn theo mặc định,
 * không phải "mở hết nếu quên cấu hình"). TODO: tài khoản admin thật + phân
 * quyền theo vai trò khi cần nhiều admin với quyền khác nhau.
 */
public final class AdminAuth {
    private static final String HEADER = "X-Admin-Token";

    public static void requireAdmin(HttpExchange exchange) {
        requireAdmin(exchange, System.getenv("ADMIN_TOKEN"));
    }

    /** Tách riêng để test được logic so khớp token mà không cần set biến môi trường thật. */
    static void requireAdmin(HttpExchange exchange, String expected) {
        if (expected == null || expected.isBlank()) {
            throw new ItemException(503, "Server chưa cấu hình ADMIN_TOKEN");
        }
        String provided = exchange.getRequestHeaders().getFirst(HEADER);
        if (provided == null || !constantTimeEquals(expected, provided)) {
            throw new ItemException(401, "Sai hoặc thiếu admin token");
        }
    }

    /** So sánh thời gian hằng số — tránh lộ độ dài trùng khớp qua timing attack khi dò token. */
    private static boolean constantTimeEquals(String a, String b) {
        if (a.length() != b.length()) {
            return false;
        }
        int result = 0;
        for (int i = 0; i < a.length(); i++) {
            result |= a.charAt(i) ^ b.charAt(i);
        }
        return result == 0;
    }

    private AdminAuth() {
    }
}
