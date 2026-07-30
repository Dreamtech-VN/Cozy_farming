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

// Cần câu
export const RODS = [
  { tier: 1, name: 'Cần trúc', price: 200, icon: '🎣', bonus: 0 },
  { tier: 2, name: 'Cần sợi thủy tinh', price: 1500, icon: '🎣', bonus: 0.1 },
  { tier: 3, name: 'Cần vàng', price: 8000, icon: '🎣', bonus: 0.25 }
];

export const RARITY_COLOR: Record<FishRarity, string> = {
  common: '#9aa5b1', rare: '#4dabf7', epic: '#b197fc', legendary: '#ffd43b'
};
export const RARITY_NAME: Record<FishRarity, string> = {
  common: 'Thường', rare: 'Hiếm', epic: 'Sử thi', legendary: 'Huyền thoại'
};
