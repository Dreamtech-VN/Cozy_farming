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
  rubyBuy?: number;        // mua bằng ruby
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
defItem({ id: 'fertilizer', name: 'Phân bón', kind: 'material', icon: '', sprite: { url: 'assets/farm/it/fertilizer.png', sx: 0, sy: 0, sw: 10, sh: 11 }, sell: 2, buy: 15, desc: 'Giảm 30% thời gian lớn của cây.' });
defItem({ id: 'feed', name: 'Thức ăn gia súc', kind: 'material', icon: '', sprite: { url: 'assets/farm/it/wheat.png', sx: 0, sy: 0, sw: 16, sh: 16 }, sell: 2, buy: 10, desc: 'Cho gà/bò/heo ăn.' });
defItem({ id: 'gift_flower', name: 'Bó hoa', kind: 'gift', icon: '', sprite: { url: 'assets/ui/act/flower_red.png', sx: 0, sy: 0, sw: 11, sh: 11 }, sell: 10, buy: 50, desc: 'Quà tặng bạn bè.' });
defItem({ id: 'gift_choco', name: 'Sô-cô-la', kind: 'gift', icon: '', sprite: { url: 'assets/ui/act/choco.png', sx: 0, sy: 0, sw: 12, sh: 11 }, sell: 20, buy: 100, desc: 'Quà tặng bạn bè.' });
defItem({ id: 'gift_teddy', name: 'Gấu bông', kind: 'gift', icon: '', sprite: { url: 'assets/ui/act/teddy.png', sx: 0, sy: 0, sw: 14, sh: 12 }, sell: 60, buy: 300, desc: 'Quà tặng dễ thương.' });
defItem({ id: 'lucky_ticket', name: 'Vé quay may mắn', kind: 'special', icon: '', sprite: { url: 'assets/ui/act/ticket.png', sx: 0, sy: 0, sw: 14, sh: 9 }, sell: 0, rubyBuy: 5, desc: 'Thêm 1 lượt quay Vòng quay may mắn.' });

// ---- Sản phẩm chăn nuôi (icon từ ui/items.png của farm pack) ----
const ITEMS_SHEET = 'assets/farm/items.png';
defItem({ id: 'egg', name: 'Trứng gà', kind: 'product', icon: '', sell: 25, sprite: { url: 'assets/farm/it/egg.png', sx: 0, sy: 0, sw: 13, sh: 16 } });
defItem({ id: 'milk', name: 'Sữa bò', kind: 'product', icon: '', sell: 60, sprite: { url: 'assets/farm/it/milk.png', sx: 0, sy: 0, sw: 10, sh: 16 } });
defItem({ id: 'pork', name: 'Nấm heo ủi', kind: 'product', icon: '', sell: 45, desc: 'Heo ủi đất tìm được nấm quý.', sprite: { url: 'assets/farm/it/mushroom.png', sx: 0, sy: 0, sw: 15, sh: 16 } });
defItem({ id: 'wool', name: 'Len cừu', kind: 'product', icon: '', sell: 70, sprite: { url: 'assets/farm/it/wool.png', sx: 0, sy: 0, sw: 16, sh: 15 } });

// ---- Nông cụ (mua ở bách hóa, gắn lên thanh nông cụ từ túi đồ) ----
defItem({ id: 'tool_basket', name: 'Giỏ thu hoạch', kind: 'tool', icon: '', sell: 0, buy: 400, desc: 'Gắn lên thanh nông cụ để thu hoạch nhanh cây chín gần nhất.', sprite: { url: 'assets/chibi/tools/basket.png', sx: 0, sy: 0, sw: 48, sh: 46 } });
defItem({ id: 'tool_axe', name: 'Rìu', kind: 'tool', icon: '', sell: 0, buy: 800, desc: 'Chặt cây ở Nông trại lấy Gỗ (cây mọc lại sau vài phút).', sprite: { url: 'assets/chibi/tools/axe.png', sx: 0, sy: 0, sw: 46, sh: 46 } });
defItem({ id: 'tool_shovel', name: 'Xẻng', kind: 'tool', icon: '🦯', sell: 0, buy: 600, desc: 'Đào các đống đất ở Nông trại/Bãi biển tìm kho báu.', sprite: { url: 'assets/chibi/tools/shovel.png', sx: 0, sy: 0, sw: 46, sh: 46 } });

// ---- Nguyên liệu từ rìu / xẻng ----
defItem({ id: 'wood', name: 'Gỗ', kind: 'material', icon: '', sell: 8, desc: 'Chặt từ cây bằng rìu. Nguyên liệu xây dựng sau này.', sprite: { url: 'assets/farm/it/wood.png', sx: 0, sy: 0, sw: 14, sh: 14 } });
defItem({ id: 'stone', name: 'Đá', kind: 'material', icon: '', sell: 6, desc: 'Đào được bằng xẻng.', sprite: { url: 'assets/farm/it/stone.png', sx: 0, sy: 0, sw: 16, sh: 15 } });

// ---- Mồi câu (bán ở tiệm câu, tự dùng con xịn nhất khi thả câu) ----
defItem({ id: 'bait_worm', name: 'Mồi giun', kind: 'material', icon: '', sprite: { url: 'assets/ui/act/bait_worm.png', sx: 0, sy: 0, sw: 13, sh: 9 }, sell: 1, buy: 5, desc: 'Cá cắn câu nhanh hơn 30%.', meta: { bait: { wait: 0.7, rare: 0 } } });
defItem({ id: 'bait_shrimp', name: 'Mồi tôm', kind: 'material', icon: '', sprite: { url: 'assets/ui/act/bait_shrimp.png', sx: 0, sy: 0, sw: 14, sh: 14 }, sell: 5, buy: 25, desc: 'Cắn nhanh hơn 40%, +10% tỉ lệ cá hiếm.', meta: { bait: { wait: 0.6, rare: 0.1 } } });
defItem({ id: 'bait_vip', name: 'Mồi thượng hạng', kind: 'material', icon: '✨', sell: 15, buy: 80, desc: 'Cá cắn gần như ngay, +25% tỉ lệ cá hiếm.', meta: { bait: { wait: 0.3, rare: 0.25 } }, sprite: { url: 'assets/chibi/tools/bait.png', sx: 0, sy: 0, sw: 28, sh: 33 } });

// ---- Quả cây khế trong nông trại ----
defItem({ id: 'crop_khe', name: 'Quả khế', kind: 'crop', icon: '', sprite: { url: 'assets/ui/act/khe.png', sx: 0, sy: 0, sw: 15, sh: 15 }, sell: 12, desc: 'Ăn khế trả vàng~ rung cây khế ở Nông trại mỗi 10 phút.' });

// ---- Đồ ăn (tiệc) ----
defItem({ id: 'food_cake', name: 'Bánh kem', kind: 'food', icon: '', sprite: { url: 'assets/ui/act/cake.png', sx: 0, sy: 0, sw: 12, sh: 13 }, sell: 40, buy: 200, desc: 'Dùng để mở tiệc tại nhà.' });
// ----- Chế biến từ nông sản (Cloverframe pack) -----
defItem({ id: 'cheese', name: 'Phô mai', kind: 'food', icon: '', sprite: { url: 'assets/farm/it/cheese.png', sx: 0, sy: 0, sw: 16, sh: 16 }, sell: 120, buy: 260, desc: 'Ủ từ sữa bò — bán được giá.' });
defItem({ id: 'bread', name: 'Bánh mì', kind: 'food', icon: '', sprite: { url: 'assets/farm/it/bread.png', sx: 0, sy: 0, sw: 16, sh: 15 }, sell: 55, buy: 120, desc: 'Nướng từ lúa mì, ăn cho chắc bụng.' });
defItem({ id: 'honey', name: 'Mật ong', kind: 'product', icon: '', sprite: { url: 'assets/farm/it/honey.png', sx: 0, sy: 0, sw: 11, sh: 16 }, sell: 150, buy: 320, desc: 'Ong lấy mật từ vườn hoa của bạn.' });
defItem({ id: 'crop_blueberry', name: 'Việt quất', kind: 'crop', icon: '', sprite: { url: 'assets/farm/it/blueberry.png', sx: 0, sy: 0, sw: 16, sh: 16 }, sell: 90, desc: 'Quả rừng hiếm — đào ụ đất ở Nông trại có thể nhặt được.' });
defItem({ id: 'food_juice', name: 'Nước ép', kind: 'food', icon: '', sprite: { url: 'assets/farm/it/juice.png', sx: 0, sy: 0, sw: 10, sh: 16 }, sell: 8, buy: 40 });
