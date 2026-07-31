// ===== Đồ cầm tay (part Avatar z = 70) =====
// Theo Lttt: "Cầm tay" là MỘT LOẠI TRANG PHỤC trong tiệm thời trang, đứng
// cùng hàng với Áo / Quần / Trang sức / Nón (T.shopCategories), mua xong là
// mặc luôn — không phải vật phẩm bỏ túi rồi gắn xuống ô trang bị.
// Vì vậy đồ cầm tay dùng chung kho với quần áo (S.chibiWardrobe), file này
// chỉ còn giữ hằng số và hàm dọn save cũ.

export const HAND_Z = 70;
const HAND_PREFIX = 'hand_';

// Save cũ để đồ cầm tay trong túi dạng hand_<partId> -> chuyển vào tủ quần áo.
export function migrateHandItems(inv: Record<string, number>, wardrobe: number[]) {
  for (const id of Object.keys(inv)) {
    if (!id.startsWith(HAND_PREFIX)) continue;
    const pid = Number(id.slice(HAND_PREFIX.length));
    if (pid && !wardrobe.includes(pid)) wardrobe.push(pid);
    delete inv[id];
  }
}
