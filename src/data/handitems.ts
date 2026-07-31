// ===== Đồ cầm tay (part Avatar z = 70) =====
// Mua ở Tiệm thời trang -> vào túi đồ -> "Dùng" để gắn xuống ô trang bị,
// bấm ô đó là nhân vật cầm lên tay.

import { defItem } from './items';
import { chibiList, chibiPriceXu } from './chibi';

export const HAND_Z = 70;
export const HAND_PREFIX = 'hand_';

export function handItemId(partId: number): string { return HAND_PREFIX + partId; }
export function partOfHandItem(itemId: string): number {
  return itemId.startsWith(HAND_PREFIX) ? Number(itemId.slice(HAND_PREFIX.length)) : 0;
}

// đăng ký vật phẩm cho mọi đồ cầm tay (không giới hạn giới tính -> lọc khi bày bán)
export const HAND_PARTS = chibiList(HAND_Z);
for (const p of HAND_PARTS) {
  defItem({
    id: handItemId(p.id), name: p.name, kind: 'tool', icon: '🖐️',
    sprite: { url: `assets/chibi/${p.id}.png`, sx: 0, sy: 0, sw: 64, sh: 96 },
    sell: 0,
    buy: chibiPriceXu(p) || undefined,
    desc: 'Đồ cầm tay — bấm Dùng để đưa xuống ô trang bị, rồi bấm ô đó để cầm lên tay.',
    meta: { handPart: p.id }
  });
}
