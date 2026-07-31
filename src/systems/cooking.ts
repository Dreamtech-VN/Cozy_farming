// ===== Nhà bếp (theo Lttt) =====
// Lttt: FarmScr.doOpenCooking() — mỗi lúc nấu 1 món, có đếm giờ (remainTime),
// nấu xong bấm lấy. Nguyên liệu lấy từ kho nông trại, món xong cất lại vào kho.

import { S, save, addExp, addStat } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { FOODS, type FoodDef } from '@/data/foods';
import { countOf, takeFrom, addTo } from './farmstore';
import { sfx } from '@/core/audio';

export function cookingFood(): FoodDef | undefined {
  return S.cooking ? FOODS[S.cooking.foodId] : undefined;
}

// Giây còn lại; 0 = xong
export function cookRemain(): number {
  const f = cookingFood();
  if (!f || !S.cooking) return 0;
  const done = S.cooking.startedAt + f.cookMin * 60_000;
  return Math.max(0, Math.ceil((done - Date.now()) / 1000));
}

export function canCook(f: FoodDef): boolean {
  return f.material.every(([id, n]) => countOf('produce', id) >= n);
}

export function startCook(foodId: string): boolean {
  if (S.cooking) { toast('Bếp đang bận — chờ món hiện tại xong đã.', 'alert'); return false; }
  const f = FOODS[foodId];
  if (!f) return false;
  if (!canCook(f)) { toast('Kho không đủ nguyên liệu.', 'alert'); return false; }
  for (const [id, n] of f.material) takeFrom('produce', id, n);
  S.cooking = { foodId, startedAt: Date.now() };
  save(true); sfx.plant();
  bus.emit(EV.STATE_CHANGED);
  toast(`Đang nấu ${f.name}...`, 'plant');
  return true;
}

export function collectCook(): boolean {
  const f = cookingFood();
  if (!f || cookRemain() > 0) return false;
  addTo('produce', `food_${f.id}`, 1);
  addExp(f.exp);
  addStat('cooked'); addStat('daily_cook');
  S.cooking = undefined;
  save(true); sfx.harvest();
  bus.emit(EV.STATE_CHANGED);
  toast(`Nấu xong ${f.name}!`, 'plant');
  return true;
}

export function cancelCook(): boolean {
  const f = cookingFood();
  if (!f) return false;
  // trả lại nguyên liệu
  for (const [id, n] of f.material) addTo('produce', id, n);
  S.cooking = undefined;
  save(true);
  bus.emit(EV.STATE_CHANGED);
  toast(`Đã hủy nấu ${f.name}, trả lại nguyên liệu.`, 'alert');
  return true;
}
