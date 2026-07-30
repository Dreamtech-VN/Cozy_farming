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
  color: number;           // màu vẽ procedural
  kind: 'butterfly' | 'bug';
}

const LIST: [string, string, FishRarity, number, string[], number, 'butterfly' | 'bug'][] = [
  ['Bướm trắng', '🦋', 'common', 15, ['farm', 'park'], 0xffffff, 'butterfly'],
  ['Bướm vàng', '🦋', 'common', 20, ['farm', 'park'], 0xffe066, 'butterfly'],
  ['Bướm cam', '🦋', 'common', 25, ['park', 'town'], 0xff922b, 'butterfly'],
  ['Bướm xanh', '🦋', 'rare', 80, ['park'], 0x4dabf7, 'butterfly'],
  ['Bướm tím', '🦋', 'rare', 95, ['park', 'beach'], 0xb197fc, 'butterfly'],
  ['Bướm đêm', '🦋', 'epic', 240, ['town'], 0x495057, 'butterfly'],
  ['Bướm hoàng đế', '🦋', 'legendary', 900, ['park'], 0xffd43b, 'butterfly'],
  ['Bọ rùa', '🐞', 'common', 18, ['farm', 'park'], 0xfa5252, 'bug'],
  ['Bọ cánh cứng', '🪲', 'common', 22, ['farm', 'town'], 0x2b8a3e, 'bug'],
  ['Dế mèn', '🦗', 'common', 16, ['farm', 'park'], 0x66471f, 'bug'],
  ['Chuồn chuồn', '🪰', 'rare', 85, ['pond', 'park'], 0x15aabf, 'bug'],
  ['Đom đóm', '✨', 'rare', 110, ['farm', 'park'], 0xfff3bf, 'bug'],
  ['Bọ hung vàng', '🪲', 'epic', 260, ['park'], 0xfab005, 'bug'],
  ['Ve sầu ngọc', '🦟', 'legendary', 850, ['town'], 0x0ca678, 'bug']
];

export const INSECTS: Record<string, InsectDef> = {};
LIST.forEach(([name, icon, rarity, price, zones, color, kind], i) => {
  const id = `insect_${i}`;
  INSECTS[id] = { id, name, icon, rarity, price, zones, color, kind };
  defItem({ id, name, kind: 'insect', icon, sell: price, meta: { rarity } });
});

export const INSECT_LIST = Object.values(INSECTS);
export const NETS = [
  { tier: 1, name: 'Vợt tre', price: 150, icon: '🥅' },
  { tier: 2, name: 'Vợt lưới mịn', price: 1200, icon: '🥅' }
];
