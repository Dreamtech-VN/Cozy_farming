// ===== Kho nông trại (theo Lttt) =====
// Lttt tách hẳn kho nông trại khỏi túi đồ: FarmService.getInventory() trả về
// 3 danh sách riêng — hatgiong (hạt giống), NongSan (nông sản), PhanBon (phân bón).
// Túi đồ chỉ giữ đồ dùng / quà / nguyên liệu; nông sản VÀ CÁ đều nằm ở kho.

import { S, save } from '@/core/save';
import { bus, EV } from '@/core/events';
import type { FarmStore } from '@/core/types';
import { item } from '@/data/items';

export type StoreKind = keyof FarmStore;   // 'seeds' | 'produce' | 'fert'

export function emptyStore(): FarmStore {
  return { seeds: {}, produce: {}, fert: {}, fish: {} };
}

export function ensureStore() {
  if (!S.farmStore) S.farmStore = emptyStore();
  for (const k of ['seeds', 'produce', 'fert', 'fish'] as StoreKind[]) {
    if (!S.farmStore[k]) S.farmStore[k] = {};
  }
}

export function countOf(kind: StoreKind, id: string): number {
  ensureStore();
  return S.farmStore[kind][id] ?? 0;
}

export function addTo(kind: StoreKind, id: string, n = 1) {
  ensureStore();
  const cur = (S.farmStore[kind][id] ?? 0) + n;
  if (cur <= 0) delete S.farmStore[kind][id];
  else S.farmStore[kind][id] = cur;
  bus.emit(EV.INVENTORY);
  save();
}

export function takeFrom(kind: StoreKind, id: string, n = 1): boolean {
  if (countOf(kind, id) < n) return false;
  addTo(kind, id, -n);
  return true;
}

export function listOf(kind: StoreKind): [string, number][] {
  ensureStore();
  return Object.entries(S.farmStore[kind]).filter(([, n]) => n > 0);
}

export function totalOf(kind: StoreKind): number {
  return listOf(kind).reduce((a, [, n]) => a + n, 0);
}

// Save cũ để hạt giống/nông sản/phân bón trong túi -> dọn sang kho, giữ nguyên số lượng.
export function migrateBagToStore() {
  ensureStore();
  for (const [itemId, qty] of Object.entries(S.inventory)) {
    if (qty <= 0) continue;
    if (itemId.startsWith('seed_')) {
      addTo('seeds', itemId.slice(5), qty);
      delete S.inventory[itemId];
    } else if (itemId.startsWith('crop_')) {
      addTo('produce', itemId.slice(5), qty);
      delete S.inventory[itemId];
    } else if (itemId === 'fertilizer') {
      addTo('fert', 'fertilizer', qty);
      delete S.inventory[itemId];
    } else if (item(itemId).kind === 'fish') {
      // cá câu được cũng thuộc kho nông trại, save cũ để trong túi thì dọn sang
      addTo('fish', itemId, qty);
      delete S.inventory[itemId];
    }
  }
}
