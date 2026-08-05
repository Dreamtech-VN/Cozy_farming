package vn.dreamtech.cozyfarming.server.farm;

/**
 * Bảng cây trồng phía server — CHỈ số liệu cân bằng (thời gian lớn/sản
 * lượng/exp), khớp {@code src/data/crops.ts} phía client (nguồn số liệu đã
 * đồng bộ với Lttt thật ở phiên trước, không đổi lại ở đây). Server giữ
 * riêng bảng này để tự tính chín/sản lượng, không tin số liệu client gửi
 * lên (chặn gian lận: đổi giờ máy, sửa code JS để thu hoạch sớm...).
 */
public record CropDef(String id, int growMin, int yieldMin, int yieldMax, int sellPrice, int exp) {
}
