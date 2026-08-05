package vn.dreamtech.cozyfarming.server.model;

/**
 * Khớp đúng bảng {@code users} thật (avatar_2x.sql). Vài cột không dùng ở
 * giai đoạn này (role/ban/ThuongNap*) vẫn giữ trong schema thật cho khớp,
 * chỉ chưa thao tác tới trong Java (thêm dần ở giai đoạn nạp thẻ/khuyến mãi
 * sau này).
 */
public record User(
        int id,
        String username,
        String passwordHash,
        int active,
        String phone,
        String gmail,
        int vnd,
        int tongNap,
        boolean loginLock
) {
}
