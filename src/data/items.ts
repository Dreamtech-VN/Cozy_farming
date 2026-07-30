// ===== Danh mục vật phẩm =====
// icon: emoji hiển thị trong UI DOM; sprite: tham chiếu sheet khi cần vẽ trong world.

export type ItemKind =
  | 'seed' | 'crop' | 'product' | 'fish' | 'insect' | 'food'
  | 'furniture' | 'deco' | 'tool' | 'gift' | 'material' | 'special';

export interface ItemDef {
  id: string;
  name: string;
  kind: ItemKind;
  icon: string;            // emoji
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

// ---- Sản phẩm chăn nuôi ----
defItem({ id: 'egg', name: 'Trứng gà', kind: 'product', icon: '🥚', sell: 25 });
defItem({ id: 'milk', name: 'Sữa bò', kind: 'product', icon: '🥛', sell: 60 });
defItem({ id: 'pork', name: 'Nấm heo ủi', kind: 'product', icon: '🍄', sell: 45, desc: 'Heo ủi đất tìm được nấm quý.' });
defItem({ id: 'wool', name: 'Len cừu', kind: 'product', icon: '🧶', sell: 70 });

// ---- Đồ ăn (tiệc) ----
defItem({ id: 'food_cake', name: 'Bánh kem', kind: 'food', icon: '🎂', sell: 40, buy: 200, desc: 'Dùng để mở tiệc tại nhà.' });
defItem({ id: 'food_juice', name: 'Nước ép', kind: 'food', icon: '🧃', sell: 8, buy: 40 });
