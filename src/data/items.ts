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
  return ITEMS[id] ?? { id, name: id, kind: 'material', icon: '📦', sell: 0 };
}

// ---- Vật phẩm chung ----
defItem({ id: 'fertilizer', name: 'Phân bón', kind: 'material', icon: '💩', sell: 2, buy: 15, desc: 'Giảm 30% thời gian lớn của cây.' });
defItem({ id: 'feed', name: 'Thức ăn gia súc', kind: 'material', icon: '🌾', sell: 2, buy: 10, desc: 'Cho gà/bò/heo ăn.' });
defItem({ id: 'gift_flower', name: 'Bó hoa', kind: 'gift', icon: '💐', sell: 10, buy: 50, desc: 'Quà tặng bạn bè.' });
defItem({ id: 'gift_choco', name: 'Sô-cô-la', kind: 'gift', icon: '🍫', sell: 20, buy: 100, desc: 'Quà tặng bạn bè.' });
defItem({ id: 'gift_teddy', name: 'Gấu bông', kind: 'gift', icon: '🧸', sell: 60, buy: 300, desc: 'Quà tặng dễ thương.' });
defItem({ id: 'lucky_ticket', name: 'Vé quay may mắn', kind: 'special', icon: '🎟️', sell: 0, rubyBuy: 5, desc: 'Thêm 1 lượt quay Vòng quay may mắn.' });

// ---- Sản phẩm chăn nuôi (icon từ ui/items.png của farm pack) ----
const ITEMS_SHEET = 'assets/farm/items.png';
defItem({ id: 'egg', name: 'Trứng gà', kind: 'product', icon: '🥚', sell: 25, sprite: { url: ITEMS_SHEET, sx: 0, sy: 64, sw: 16, sh: 16 } });
defItem({ id: 'milk', name: 'Sữa bò', kind: 'product', icon: '🥛', sell: 60, sprite: { url: ITEMS_SHEET, sx: 0, sy: 48, sw: 16, sh: 16 } });
defItem({ id: 'pork', name: 'Nấm heo ủi', kind: 'product', icon: '🍄', sell: 45, desc: 'Heo ủi đất tìm được nấm quý.', sprite: { url: ITEMS_SHEET, sx: 32, sy: 96, sw: 16, sh: 16 } });
defItem({ id: 'wool', name: 'Len cừu', kind: 'product', icon: '🧶', sell: 70, sprite: { url: ITEMS_SHEET, sx: 0, sy: 80, sw: 16, sh: 16 } });

// ---- Nông cụ (mua ở bách hóa, gắn lên thanh nông cụ từ túi đồ) ----
defItem({ id: 'tool_basket', name: 'Giỏ thu hoạch', kind: 'tool', icon: '🧺', sell: 0, buy: 400, desc: 'Gắn lên thanh nông cụ để thu hoạch nhanh cây chín gần nhất.', sprite: { url: 'assets/chibi/tools/basket.png', sx: 0, sy: 0, sw: 48, sh: 46 } });
defItem({ id: 'tool_axe', name: 'Rìu', kind: 'tool', icon: '🪓', sell: 0, buy: 800, desc: 'Đốn gỗ (tính năng sẽ mở trong bản cập nhật tới).', sprite: { url: 'assets/chibi/tools/axe.png', sx: 0, sy: 0, sw: 46, sh: 46 } });
defItem({ id: 'tool_shovel', name: 'Xẻng', kind: 'tool', icon: '🦯', sell: 0, buy: 600, desc: 'Đào bới (tính năng sẽ mở trong bản cập nhật tới).', sprite: { url: 'assets/chibi/tools/shovel.png', sx: 0, sy: 0, sw: 46, sh: 46 } });

// ---- Quả cây khế trong nông trại ----
defItem({ id: 'crop_khe', name: 'Quả khế', kind: 'crop', icon: '⭐', sell: 12, desc: 'Ăn khế trả vàng~ rung cây khế ở Nông trại mỗi 10 phút.' });

// ---- Đồ ăn (tiệc) ----
defItem({ id: 'food_cake', name: 'Bánh kem', kind: 'food', icon: '🎂', sell: 40, buy: 200, desc: 'Dùng để mở tiệc tại nhà.' });
defItem({ id: 'food_juice', name: 'Nước ép', kind: 'food', icon: '🧃', sell: 8, buy: 40 });
