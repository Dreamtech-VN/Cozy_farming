import { S, save, addItem, removeItem, itemCount, addExp, addStat } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { ANIMALS, BARN_CAPACITY, BARN_UPGRADE_COST } from '@/data/animals';
import { sfx } from '@/core/audio';
import type { Animal } from '@/core/types';

export function barnCapacity(): number {
  return BARN_CAPACITY[S.livestock.barnLevel] ?? 0;
}

export function upgradeBarn(): boolean {
  const lv = S.livestock.barnLevel;
  if (lv >= 3) { toast('Chuồng đã cấp tối đa.'); return false; }
  const cost = BARN_UPGRADE_COST[lv];
  if (S.wallet.coins < cost) { toast(`Cần ${cost} xu.`, 'coin'); sfx.error(); return false; }
  S.wallet.coins -= cost;
  S.livestock.barnLevel++;
  bus.emit(EV.WALLET); bus.emit(EV.STATE_CHANGED); save();
  toast(lv === 0 ? 'Đã xây chuồng!' : `Chuồng lên cấp ${S.livestock.barnLevel}!`, 'barn');
  sfx.coin();
  return true;
}

export function buyAnimal(type: string): boolean {
  const def = ANIMALS[type];
  if (!def) return false;
  if (S.livestock.barnLevel === 0) { toast('Xây chuồng trước đã (bấm vào chuồng ở Nông trại).', 'barn'); return false; }
  if (S.livestock.animals.length >= barnCapacity()) { toast('Chuồng đầy rồi — nâng cấp chuồng nhé.', 'barn'); return false; }
  if (S.wallet.coins < def.price) { toast(`Cần ${def.price} xu.`, 'coin'); sfx.error(); return false; }
  S.wallet.coins -= def.price;
  const a: Animal = {
    id: `a${Date.now()}${Math.floor(Math.random() * 999)}`,
    type, name: def.name, boughtAt: Date.now(), fedAt: 0, collectedAt: Date.now()
  };
  S.livestock.animals.push(a);
  addStat('animals_bought');
  bus.emit(EV.WALLET); bus.emit(EV.STATE_CHANGED); save();
  toast(`Đã mua ${def.name}!`, def.icon); sfx.coin();
  return true;
}

export function isHungry(a: Animal): boolean {
  // đói sau 4 giờ kể từ lần cho ăn
  return Date.now() - a.fedAt > 4 * 3600_000;
}

export function hasProduct(a: Animal): boolean {
  const def = ANIMALS[a.type];
  if (isHungry(a)) return false;
  return Date.now() - Math.max(a.fedAt, a.collectedAt) > def.produceMin * 60_000
    && a.collectedAt < a.fedAt + 24 * 3600_000;
}

export function feed(a: Animal): boolean {
  if (!isHungry(a)) { toast('Bé này no rồi!'); return false; }
  if (itemCount('feed') <= 0) { toast('Hết thức ăn — mua ở Bách hóa.', '🌾'); return false; }
  removeItem('feed');
  a.fedAt = Date.now(); a.collectedAt = Date.now();
  addStat('fed'); addStat('daily_fed');
  sfx.plant(); save(); bus.emit(EV.STATE_CHANGED);
  toast(`${ANIMALS[a.type].name} măm măm ngon lành~`, ANIMALS[a.type].icon);
  return true;
}

export function collect(a: Animal): boolean {
  const def = ANIMALS[a.type];
  if (!hasProduct(a)) return false;
  const qty = def.productQty[0] + Math.floor(Math.random() * (def.productQty[1] - def.productQty[0] + 1));
  addItem(def.product, qty);
  addExp(def.exp);
  a.collectedAt = Date.now();
  addStat('collected_products', qty);
  sfx.harvest(); save(); bus.emit(EV.STATE_CHANGED);
  return true;
}

export function sellAnimal(id: string): boolean {
  const idx = S.livestock.animals.findIndex(a => a.id === id);
  if (idx < 0) return false;
  const a = S.livestock.animals[idx];
  const refund = Math.floor(ANIMALS[a.type].price * 0.5);
  S.livestock.animals.splice(idx, 1);
  S.wallet.coins += refund;
  bus.emit(EV.WALLET); bus.emit(EV.STATE_CHANGED); save();
  toast(`Đã bán ${a.name} được ${refund} xu.`, 'coin'); sfx.coin();
  return true;
}
