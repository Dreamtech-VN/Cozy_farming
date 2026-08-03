// ===== Ao nuôi cá trong nông trại (theo Lttt) =====
// Hướng dẫn gốc Lttt: "Bạn có thể nuôi cá trong ao này bằng cách mua cá từ
// cửa hàng bên ngoài" — tức là NUÔI, không phải câu. Mua cá giống thả xuống ao,
// đợi lớn rồi vớt, cá thu được cất vào kho nông trại.

import { S, save, spend, addExp, addStat, itemCount, removeItem } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { addTo } from './farmstore';
import { sfx } from '@/core/audio';

// Người dùng yêu cầu: cá trong ao cũng phải cho ăn mới lớn, giống hệt vật nuôi
// trên cạn (livestock.ts) — Lttt gốc thật ra FishFarm kế thừa AnimalDan, dùng
// chung pipeline ăn/lớn với vật nuôi trên cạn (xem FishFarm.cs, AnimalDan.cs).
// Dùng chung item 'feed' như trên cạn, không bịa loại thức ăn cá riêng.
export type PondFish = { id: string; type: string; at: number; fedAt?: number };

export interface FryDef {
  id: string;
  name: string;
  price: number;        // giá cá giống
  growMin: number;      // phút để lớn
  qty: [number, number];
  exp: number;
}

export const FRIES: Record<string, FryDef> = {
  ca_ro: { id: 'ca_ro', name: 'Cá rô', price: 120, growMin: 20, qty: [1, 2], exp: 8 },
  ca_chep: { id: 'ca_chep', name: 'Cá chép', price: 300, growMin: 45, qty: [1, 3], exp: 18 },
  ca_tram: { id: 'ca_tram', name: 'Cá trắm', price: 700, growMin: 90, qty: [2, 4], exp: 34 }
};
export const FRY_LIST = Object.values(FRIES);

export const POND_CAP = 6;                 // số con nuôi cùng lúc

export function pond(): PondFish[] {
  if (!S.fishfarm) S.fishfarm = [];
  return S.fishfarm;
}

export function grownAt(f: { type: string; at: number }): number {
  return f.at + (FRIES[f.type]?.growMin ?? 20) * 60_000;
}
// đói nếu chưa từng cho ăn, hoặc quá 4 giờ kể từ lần ăn gần nhất (ngưỡng giống livestock.ts)
export function isHungryFish(f: PondFish): boolean {
  return f.fedAt === undefined || Date.now() - f.fedAt > 4 * 3600_000;
}
export function isGrown(f: PondFish): boolean {
  return Date.now() >= grownAt(f) && !isHungryFish(f);
}
export function remainMin(f: { type: string; at: number }): number {
  return Math.max(0, Math.ceil((grownAt(f) - Date.now()) / 60_000));
}

export function feedFish(f: PondFish): boolean {
  if (!isHungryFish(f)) { toast('Cá này no rồi!'); return false; }
  if (itemCount('feed') <= 0) { toast('Hết thức ăn — mua ở Bách hóa.', 'feed'); return false; }
  removeItem('feed');
  f.fedAt = Date.now();
  save(true); bus.emit(EV.STATE_CHANGED);
  toast(`${FRIES[f.type]?.name ?? 'Cá'} măm măm~`, 'fish');
  return true;
}

export function stockFry(typeId: string): boolean {
  const def = FRIES[typeId];
  if (!def) return false;
  if (pond().length >= POND_CAP) { toast(`Ao chỉ nuôi được ${POND_CAP} con.`, 'alert'); return false; }
  if (!spend(def.price)) return false;
  pond().push({ id: `fr_${Date.now()}_${Math.floor(Math.random() * 999)}`, type: typeId, at: Date.now() });
  addStat('fry_stocked');
  save(true); sfx.splash();
  bus.emit(EV.STATE_CHANGED);
  toast(`Đã thả ${def.name} xuống ao!`, 'fish');
  return true;
}

export function netFish(fishId: string): boolean {
  const list = pond();
  const i = list.findIndex(f => f.id === fishId);
  if (i < 0) return false;
  const f = list[i];
  if (!isGrown(f)) { toast(`Cá chưa lớn — còn ${remainMin(f)} phút.`, 'fish'); return false; }
  const def = FRIES[f.type];
  const qty = def.qty[0] + Math.floor(Math.random() * (def.qty[1] - def.qty[0] + 1));
  addTo('produce', `fish_${def.id}`, qty);
  addExp(def.exp);
  addStat('fish_farmed', qty);
  list.splice(i, 1);
  save(true); sfx.fish();
  bus.emit(EV.STATE_CHANGED);
  toast(`Vớt được ${qty} ${def.name}!`, 'fish');
  return true;
}

export function readyCount(): number {
  return pond().filter(isGrown).length;
}
