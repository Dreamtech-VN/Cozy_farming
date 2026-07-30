import { defItem } from './items';
import type { FishRarity } from './fish';

// Côn trùng — asset pack hiện chưa có sprite côn trùng (xem docs/ASSETS.md),
// tạm vẽ procedural trong world + emoji trong UI.
export interface InsectDef {
  id: string;
  name: string;
  icon: string;
  rarity: FishRarity;
  price: number;
  zones: string[];         // park, farm, town
  color: number;           // màu tint dự phòng
  kind: 'butterfly' | 'bug';
  frame: number;           // frame trong sheet nature (lưới 16px, 10 cột): hàng bọ 110-119, hàng bướm 120-129
}

const LIST: [string, string, FishRarity, number, string[], number, 'butterfly' | 'bug', number][] = [
  ['Bướm trắng', '🦋', 'common', 15, ['farm', 'park'], 0xffffff, 'butterfly', 120],
  ['Bướm vàng', '🦋', 'common', 20, ['farm', 'park'], 0xffe066, 'butterfly', 128],
  ['Bướm cam', '🦋', 'common', 25, ['park', 'town'], 0xff922b, 'butterfly', 125],
  ['Bướm xanh', '🦋', 'rare', 80, ['park'], 0x4dabf7, 'butterfly', 124],
  ['Bướm tím', '🦋', 'rare', 95, ['park', 'beach'], 0xb197fc, 'butterfly', 122],
  ['Bướm đêm', '🦋', 'epic', 240, ['town'], 0x495057, 'butterfly', 126],
  ['Bướm hoàng đế', '🦋', 'legendary', 900, ['park'], 0xffd43b, 'butterfly', 121],
  ['Bọ rùa', '🐞', 'common', 18, ['farm', 'park'], 0xfa5252, 'bug', 110],
  ['Bọ cánh cứng', '🪲', 'common', 22, ['farm', 'town'], 0x2b8a3e, 'bug', 113],
  ['Dế mèn', '🦗', 'common', 16, ['farm', 'park'], 0x66471f, 'bug', 114],
  ['Chuồn chuồn', '🪰', 'rare', 85, ['pond', 'park'], 0x15aabf, 'bug', 117],
  ['Đom đóm', '✨', 'rare', 110, ['farm', 'park'], 0xfff3bf, 'bug', 111],
  ['Bọ hung vàng', '🪲', 'epic', 260, ['park'], 0xfab005, 'bug', 115],
  ['Ve sầu ngọc', '🦟', 'legendary', 850, ['town'], 0x0ca678, 'bug', 116]
];

export const INSECTS: Record<string, InsectDef> = {};
LIST.forEach(([name, icon, rarity, price, zones, color, kind, frame], i) => {
  const id = `insect_${i}`;
  INSECTS[id] = { id, name, icon, rarity, price, zones, color, kind, frame };
  defItem({
    id, name, kind: 'insect', icon,
    sprite: { url: 'assets/nature/global.png', sx: (frame % 10) * 16, sy: Math.floor(frame / 10) * 16, sw: 16, sh: 16 },
    sell: price, meta: { rarity }
  });
});

export const INSECT_LIST = Object.values(INSECTS);
export const NETS = [
  { tier: 1, name: 'Vợt tre', price: 150, icon: '🥅' },
  { tier: 2, name: 'Vợt lưới mịn', price: 1200, icon: '🥅' }
];
