// ===== Danh mục vật phẩm =====
// icon: emoji hiển thị trong UI DOM; sprite: tham chiếu sheet khi cần vẽ trong world.

export type ItemKind =
  | 'seed' | 'crop' | 'product' | 'fish' | 'insect' | 'food'
  | 'furniture' | 'deco' | 'tool' | 'gift' | 'material' | 'special';

export interface ItemSprite { url: string; sx: number; sy: number; sw: number; sh: number }

export interface ItemDef {
  id: string;
  name: string;
  kind: ItemKind;
  icon: string;            // emoji dự phòng
  sprite?: ItemSprite;     // sprite thật từ asset pack (ưu tiên hiển thị)
  sell: number;            // giá bán cho NPC (0 = không bán được)
  buy?: number;            // giá mua ở shop (nếu bán trong shop)
  desc?: string;
  meta?: Record<string, unknown>;
}

export const ITEMS: Record<string, ItemDef> = {};

export function defItem(d: ItemDef): ItemDef {
  ITEMS[d.id] = d;
  return d;
}

export function item(id: string): ItemDef {
  return ITEMS[id] ?? { id, name: id, kind: 'material', icon: '', sell: 0 };
}

// ---- Vật phẩm chung ----
defItem({ id: 'fertilizer', name: 'Phân bón', kind: 'material', icon: '', sprite: { url: 'assets/farm/chibi/fertilizer.png', sx: 0, sy: 0, sw: 34, sh: 37 }, sell: 2, buy: 15, desc: 'Giảm 30% thời gian lớn của cây.' });
defItem({ id: 'feed', name: 'Thức ăn gia súc', kind: 'material', icon: '', sprite: { url: 'assets/farm/chibi/wheat.png', sx: 0, sy: 0, sw: 52, sh: 52 }, sell: 2, buy: 10, desc: 'Cho gà/bò/heo ăn.' });
defItem({ id: 'gift_flower', name: 'Bó hoa', kind: 'gift', icon: '', sprite: { url: 'assets/ui/act/flower_red.png', sx: 0, sy: 0, sw: 11, sh: 11 }, sell: 10, buy: 50, desc: 'Quà tặng bạn bè.' });
defItem({ id: 'gift_choco', name: 'Sô-cô-la', kind: 'gift', icon: '', sprite: { url: 'assets/ui/act/choco.png', sx: 0, sy: 0, sw: 12, sh: 11 }, sell: 20, buy: 100, desc: 'Quà tặng bạn bè.' });
defItem({ id: 'gift_teddy', name: 'Gấu bông', kind: 'gift', icon: '', sprite: { url: 'assets/ui/act/teddy.png', sx: 0, sy: 0, sw: 14, sh: 12 }, sell: 60, buy: 300, desc: 'Quà tặng dễ thương.' });
defItem({ id: 'lucky_ticket', name: 'Vé quay may mắn', kind: 'special', icon: '', sprite: { url: 'assets/ui/act/ticket.png', sx: 0, sy: 0, sw: 14, sh: 9 }, sell: 0, buy: 2000, desc: 'Thêm 1 lượt quay Vòng quay may mắn.' });

// ---- Sản phẩm chăn nuôi (icon từ ui/items.png của farm pack) ----
const ITEMS_SHEET = 'assets/farm/items.png';
defItem({ id: 'egg', name: 'Trứng gà', kind: 'product', icon: '', sell: 25, sprite: { url: 'assets/farm/chibi/egg.png', sx: 0, sy: 0, sw: 43, sh: 52 } });
defItem({ id: 'milk', name: 'Sữa bò', kind: 'product', icon: '', sell: 60, sprite: { url: 'assets/farm/chibi/milk.png', sx: 0, sy: 0, sw: 34, sh: 52 } });
defItem({ id: 'meat', name: 'Thịt heo', kind: 'product', icon: '', sell: 90, desc: 'Thịt tươi thu từ chuồng heo, nấu món gì cũng ngon.', sprite: { url: 'assets/farm/chibi/meat.png', sx: 0, sy: 0, sw: 46, sh: 52 } });
// save cũ còn giữ "nấm heo ủi" nên vẫn khai báo để kho hiện đúng tên/ảnh
defItem({ id: 'pork', name: 'Nấm heo ủi', kind: 'product', icon: '', sell: 45, desc: 'Heo ủi đất tìm được nấm quý.', sprite: { url: 'assets/farm/chibi/mushroom.png', sx: 0, sy: 0, sw: 49, sh: 52 } });
defItem({ id: 'wool', name: 'Len cừu', kind: 'product', icon: '', sell: 70, sprite: { url: 'assets/farm/chibi/wool.png', sx: 0, sy: 0, sw: 52, sh: 49 } });

// ---- Công cụ (mua ở bách hóa) ----
defItem({ id: 'tool_basket', name: 'Liềm gặt', kind: 'tool', icon: '', sell: 0, buy: 400, desc: 'Nằm sẵn trên thanh công cụ, thu hoạch nhanh cây chín gần nhất.', sprite: { url: 'assets/farm/chibi/19_sickle.png', sx: 0, sy: 0, sw: 50, sh: 62 } });
defItem({ id: 'tool_axe', name: 'Rìu', kind: 'tool', icon: '', sell: 0, buy: 800, desc: 'Chặt cây ở Nông trại lấy Gỗ (cây mọc lại sau vài phút).', sprite: { url: 'assets/farm/chibi/20_axe.png', sx: 0, sy: 0, sw: 58, sh: 62 } });

// ---- Nguyên liệu từ rìu / đào đất ----
defItem({ id: 'wood', name: 'Gỗ', kind: 'material', icon: '', sell: 8, desc: 'Chặt từ cây bằng rìu. Nguyên liệu xây dựng sau này.', sprite: { url: 'assets/farm/chibi/wood.png', sx: 0, sy: 0, sw: 46, sh: 46 } });
defItem({ id: 'stone', name: 'Đá', kind: 'material', icon: '', sell: 6, desc: 'Đào từ mấy đống đất ngoài nông trại / bãi biển.', sprite: { url: 'assets/farm/chibi/stone.png', sx: 0, sy: 0, sw: 52, sh: 49 } });

// ---- Đá cường hoá: dùng để đập trang bị ----
defItem({ id: 'enh_stone', name: 'Đá Nâng Cấp', kind: 'material', icon: '', sprite: { url: 'assets/farm/chibi/stone.png', sx: 0, sy: 0, sw: 52, sh: 49 }, sell: 20, buy: 200, desc: 'Nguyên liệu đập trang bị. Mua ở quầy trang bị hoặc rơi ra khi đập hỏng.' });

// ---- Rương trang bị: nguồn DUY NHẤT ra trang bị (GunPow không bán thẳng đồ) ----
defItem({ id: 'chest_eq1', name: 'Rương Trang Bị Thường', kind: 'special', icon: '', sprite: { url: 'assets/equip/chest/eq1.png', sx: 0, sy: 0, sw: 63, sh: 53 }, sell: 0, buy: 3000, desc: 'Mở ra 1 trang bị bậc 1-6.' });
defItem({ id: 'chest_eq2', name: 'Rương Trang Bị Khá', kind: 'special', icon: '', sprite: { url: 'assets/equip/chest/eq2.png', sx: 0, sy: 0, sw: 63, sh: 52 }, sell: 0, buy: 15000, desc: 'Mở ra 1 trang bị bậc 5-12.' });
defItem({ id: 'chest_eq3', name: 'Rương Trang Bị Xịn', kind: 'special', icon: '', sprite: { url: 'assets/equip/chest/eq3.png', sx: 0, sy: 0, sw: 64, sh: 54 }, sell: 0, buy: 60000, desc: 'Mở ra 1 trang bị bậc 11-20.' });

// ---- Đá thăng tinh: dùng để nâng sao trang bị (3 cấp như GunPow) ----
defItem({ id: 'star_stone_1', name: 'Đá Lên Sao Nhỏ', kind: 'material', icon: '', sprite: { url: 'assets/equip/stone_004.png', sx: 0, sy: 0, sw: 57, sh: 56 }, sell: 40, buy: 400, desc: 'Dùng để lên sao trang bị (sao 1-2).' });
defItem({ id: 'star_stone_2', name: 'Đá Lên Sao Vừa', kind: 'material', icon: '', sprite: { url: 'assets/equip/stone_014.png', sx: 0, sy: 0, sw: 57, sh: 60 }, sell: 120, buy: 1200, desc: 'Dùng để lên sao trang bị (sao 3-4).' });
defItem({ id: 'star_stone_3', name: 'Đá Lên Sao Lớn', kind: 'material', icon: '', sprite: { url: 'assets/equip/stone_024.png', sx: 0, sy: 0, sw: 57, sh: 57 }, sell: 300, buy: 3000, desc: 'Dùng để lên sao trang bị (sao 5).' });

// ---- Đá tẩy luyện: gieo lại 5 dòng phụ của trang bị ----
defItem({ id: 'ref_stone', name: 'Đá Rửa Chỉ Số', kind: 'material', icon: '', sprite: { url: 'assets/equip/stone_066.png', sx: 0, sy: 0, sw: 59, sh: 64 }, sell: 60, buy: 600, desc: 'Gieo lại các dòng chỉ số phụ của trang bị.' });

// ---- Mồi câu ----
// Đúng 3 loại mồi của Lttt (bảng `items` trong avatar_2x.sql):
//   443 'mồi cơm'   giá 5 xu
//   447 'mồi trùng' giá 20 xu
//   448 'trứng kiến' giá 30 xu  (chính là mồi server trừ mỗi lần quăng câu)
// Ghi chú: cột `icon` của 3 dòng này (771 / 763 / 772) trỏ vào ảnh quần áo
// trong res.rar bản mình có, không ra hình mồi, nên hình lấy từ pack câu cá.
defItem({ id: 'bait_rice', name: 'Mồi cơm', kind: 'material', icon: '', sprite: { url: 'assets/farm/chibi/bread.png', sx: 0, sy: 0, sw: 48, sh: 48 }, sell: 1, buy: 5, desc: 'Mồi rẻ nhất. Quăng câu là mất 1 mồi.', meta: { bait: { wait: 1, rare: 0 } } });
defItem({ id: 'bait_worm', name: 'Mồi trùng', kind: 'material', icon: '', sprite: { url: 'assets/ui/act/bait_worm.png', sx: 0, sy: 0, sw: 13, sh: 9 }, sell: 4, buy: 20, desc: 'Cá cắn nhanh hơn 30%, +10% tỉ lệ cá hiếm.', meta: { bait: { wait: 0.7, rare: 0.1 } } });
defItem({ id: 'bait_ant_egg', name: 'Trứng kiến', kind: 'material', icon: '', sprite: { url: 'assets/farm/chibi/egg.png', sx: 0, sy: 0, sw: 43, sh: 52 }, sell: 6, buy: 30, desc: 'Mồi xịn nhất: cá cắn nhanh hơn 50%, +25% tỉ lệ cá hiếm.', meta: { bait: { wait: 0.5, rare: 0.25 } } });

// ---- Quả cây khế trong nông trại ----
defItem({ id: 'crop_khe', name: 'Quả khế', kind: 'crop', icon: '', sprite: { url: 'assets/ui/act/khe.png', sx: 0, sy: 0, sw: 15, sh: 15 }, sell: 12, desc: 'Ăn khế trả vàng~ rung cây khế ở Nông trại mỗi 10 phút.' });

// ---- Đồ ăn (tiệc) ----
defItem({ id: 'food_cake', name: 'Bánh kem', kind: 'food', icon: '', sprite: { url: 'assets/ui/act/cake.png', sx: 0, sy: 0, sw: 12, sh: 13 }, sell: 40, buy: 200, desc: 'Dùng để mở tiệc tại nhà.' });
// ----- Chế biến từ nông sản (Cloverframe pack) -----
defItem({ id: 'cheese', name: 'Phô mai', kind: 'food', icon: '', sprite: { url: 'assets/farm/chibi/cheese.png', sx: 0, sy: 0, sw: 52, sh: 52 }, sell: 120, buy: 260, desc: 'Ủ từ sữa bò — bán được giá.' });
defItem({ id: 'bread', name: 'Bánh mì', kind: 'food', icon: '', sprite: { url: 'assets/farm/chibi/bread.png', sx: 0, sy: 0, sw: 52, sh: 49 }, sell: 55, buy: 120, desc: 'Nướng từ lúa mì, ăn cho chắc bụng.' });
defItem({ id: 'honey', name: 'Mật ong', kind: 'product', icon: '', sprite: { url: 'assets/farm/chibi/honey.png', sx: 0, sy: 0, sw: 37, sh: 52 }, sell: 150, buy: 320, desc: 'Ong lấy mật từ vườn hoa của bạn.' });
defItem({ id: 'crop_blueberry', name: 'Việt quất', kind: 'crop', icon: '', sprite: { url: 'assets/farm/chibi/blueberry.png', sx: 0, sy: 0, sw: 52, sh: 52 }, sell: 90, desc: 'Quả rừng hiếm — đào ụ đất ở Nông trại có thể nhặt được.' });
defItem({ id: 'food_juice', name: 'Nước ép', kind: 'food', icon: '', sprite: { url: 'assets/farm/chibi/juice.png', sx: 0, sy: 0, sw: 34, sh: 52 }, sell: 8, buy: 40 });
