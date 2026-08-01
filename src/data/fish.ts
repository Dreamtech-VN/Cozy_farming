import { defItem } from './items';

// Cá — sprite từ fishing/fish_all.png (lưới 16px, 10×10)
export type FishRarity = 'common' | 'rare' | 'epic' | 'legendary';

export interface FishDef {
  id: string;
  name: string;
  index: number;           // vị trí trong fish_all.png
  rarity: FishRarity;
  price: number;
  zones: string[];         // khu câu được: beach, pond
  minRod: number;          // cấp cần tối thiểu
}

const NAMES: [string, FishRarity, number, string[]][] = [
  ['Cá vẹt', 'common', 30, ['beach']],
  ['Cá thu', 'common', 35, ['beach']],
  ['Cá hề', 'rare', 90, ['beach']],
  ['Cá bơn', 'common', 30, ['beach']],
  ['Lươn bạc', 'rare', 110, ['beach', 'pond']],
  ['Cá ngựa', 'epic', 260, ['beach']],
  ['Cá mao tiên', 'epic', 300, ['beach']],
  ['Cá bò hòm', 'rare', 120, ['beach']],
  ['Cá ngừ', 'rare', 140, ['beach']],
  ['Cá bướm sọc', 'rare', 100, ['beach']],
  ['Cá vược', 'common', 40, ['beach', 'pond']],
  ['Cá đuôi xanh', 'epic', 280, ['beach']],
  ['Cá pollock', 'common', 32, ['beach']],
  ['Cá wrasse', 'common', 36, ['beach']],
  ['Cá weaver', 'common', 33, ['beach']],
  ['Cá tráp', 'common', 38, ['beach', 'pond']],
  ['Cá nóc', 'rare', 130, ['beach']],
  ['Cá tuyết', 'common', 42, ['beach']],
  ['Cá dab', 'common', 30, ['beach']],
  ['Cá bơn sao', 'common', 34, ['pond']],
  ['Cá whiting', 'common', 31, ['pond']],
  ['Cá halibut', 'rare', 150, ['beach']],
  ['Cá trích', 'common', 28, ['beach', 'pond']],
  ['Cá đuối', 'epic', 320, ['beach']],
  ['Cá sói', 'epic', 290, ['beach']],
  ['Cá xương', 'rare', 115, ['pond']],
  ['Cá cobia', 'rare', 125, ['beach']],
  ['Cá trống đen', 'rare', 135, ['pond']],
  ['Cá blob', 'legendary', 800, ['beach']],
  ['Cá chép vàng', 'legendary', 1000, ['pond']]
];

export const FISHES: Record<string, FishDef> = {};
NAMES.forEach(([name, rarity, price, zones], i) => {
  const id = `fish_${i}`;
  const minRod = rarity === 'legendary' ? 3 : rarity === 'epic' ? 2 : 1;
  FISHES[id] = { id, name, index: i, rarity, price, zones, minRod };
  defItem({
    id, name, kind: 'fish', icon: rarity === 'legendary' ? '🐠' : '🐟',
    sprite: { url: 'assets/fishing/fish_all.png', sx: (i % 10) * 16, sy: Math.floor(i / 10) * 16, sw: 16, sh: 16 },
    sell: price, meta: { rarity }
  });
});

export const FISH_LIST = Object.values(FISHES);

// Cần câu — 3 bậc lấy đúng theo Lttt (bảng items: 442 tre / 445 sắt / 446 VIP).
// `part` là id part chibi Avatar: mua cần là có luôn hình cầm tay trong tủ đồ.
// Icon shop/thanh nông cụ cắt ra từ CHÍNH 3 part đó (scripts/make_rod_icons.py)
// nên icon và cái cần cầm trên tay là cùng một hình — sheet 3 ô 32x32.
export const ROD_SHEET = 'assets/fishing/rods.png';

export interface RodDef {
  tier: number; name: string; price: number; cur: 'coin' | 'ruby'; bonus: number; part: number;
}

// Giá gốc trong bảng `items` của Lttt:
//   (442, 10000, -1, ... 'cần câu tre')   -> 10.000 xu
//   (445,    -1, 25, ... 'cần câu sắt')   -> 25 lượng
//   (446,    -1, 100, ... 'cần câu VIP')  -> 100 lượng
// Bên mình LƯỢNG LÀ TIỀN NẠP và chỉ tiêu cho gacha / skin giới hạn, nên hai
// bậc cần trên đổi sang xu, quy đổi 1 lượng = 1.000 xu để giữ nguyên thứ bậc
// (25 -> 25.000, 100 -> 100.000). Cần câu là đồ chơi thường, không đụng tiền nạp.
export const RODS: RodDef[] = [
  { tier: 1, name: 'Cần câu tre', price: 10000, cur: 'coin', bonus: 0, part: 442 },
  { tier: 2, name: 'Cần câu sắt', price: 25000, cur: 'coin', bonus: 0.1, part: 445 },
  { tier: 3, name: 'Cần câu VIP', price: 100000, cur: 'coin', bonus: 0.25, part: 446 }
];

// ô icon của bậc cần (tier 0 = chưa có cần thì lấy tạm ô cần tre)
export function rodIconRect(tier: number) {
  const i = Math.min(Math.max(tier, 1), RODS.length) - 1;
  return { url: ROD_SHEET, sx: i * 32, sy: 0, sw: 32, sh: 32 };
}

export const RARITY_COLOR: Record<FishRarity, string> = {
  common: '#9aa5b1', rare: '#4dabf7', epic: '#b197fc', legendary: '#ffd43b'
};
export const RARITY_NAME: Record<FishRarity, string> = {
  common: 'Thường', rare: 'Hiếm', epic: 'Sử thi', legendary: 'Huyền thoại'
};
