import { S, save, addItem, removeItem, itemCount, addExp, addStat } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { ANIMALS, BARN_CAPACITY, BARN_UPGRADE_COST } from '@/data/animals';
import { addTo } from './farmstore';
import { sfx } from '@/core/audio';
import type { Animal } from '@/core/types';

export function barnCapacity(): number {
  return BARN_CAPACITY[S.livestock.barnLevel] ?? 0;
}

export function upgradeBarn(): boolean {
  const lv = S.livestock.barnLevel;
  if (lv === 0) { toast('Mua vật nuôi đầu tiên là có chuồng luôn.', 'barn'); return false; }
  if (lv >= 3) { toast('Chuồng đã cấp tối đa.'); return false; }
  const cost = BARN_UPGRADE_COST[lv];
  if (S.wallet.coins < cost) { toast(`Cần ${cost} xu.`, 'coin'); sfx.error(); return false; }
  S.wallet.coins -= cost;
  S.livestock.barnLevel++;
  bus.emit(EV.WALLET); bus.emit(EV.STATE_CHANGED); save();
  toast(`Chuồng lên cấp ${S.livestock.barnLevel}!`, 'barn');
  sfx.coin();
  return true;
}

export function buyAnimal(type: string): boolean {
  const def = ANIMALS[type];
  if (!def) return false;
  // mua con đầu tiên là dựng luôn chuồng, không bắt xây riêng nữa
  const firstBuy = S.livestock.barnLevel === 0;
  if (!firstBuy && S.livestock.animals.length >= barnCapacity()) { toast('Chuồng đầy rồi — nâng cấp chuồng nhé.', 'barn'); return false; }
  if (S.wallet.coins < def.price) { toast(`Cần ${def.price} xu.`, 'coin'); sfx.error(); return false; }
  S.wallet.coins -= def.price;
  if (firstBuy) S.livestock.barnLevel = 1;
  const a: Animal = {
    id: `a${Date.now()}${Math.floor(Math.random() * 999)}`,
    type, name: def.name, boughtAt: Date.now(), fedAt: 0, collectedAt: Date.now()
  };
  S.livestock.animals.push(a);
  addStat('animals_bought');
  bus.emit(EV.WALLET); bus.emit(EV.STATE_CHANGED); save();
  toast(firstBuy ? `Đã mua ${def.name} — chuồng thú đã dựng ở Nông trại!` : `Đã mua ${def.name}!`, 'barn');
  sfx.coin();
  return true;
}

export function isHungry(a: Animal): boolean {
  // đói sau 4 giờ kể từ lần cho ăn
  return Date.now() - a.fedAt > 4 * 3600_000;
}

// ===== Giai đoạn lớn (period 0/1/2, theo Lttt gốc — FarmScr.cs:3639-3646) =====
// period = tuổi(phút) / (maturityMin/2), tối đa 2 (2 = đã lớn, mới cho sản phẩm được).
// Tính thuần theo boughtAt (không lưu state riêng) nên save cũ tự nhiên ra period=2
// vì boughtAt đã xa — không cần migrate field này.
export function growthPeriod(a: Animal): number {
  const def = ANIMALS[a.type];
  if (!def) return 2;
  const ageMin = (Date.now() - a.boughtAt) / 60_000;
  const step = def.maturityMin / 2;
  if (step <= 0) return 2;
  return Math.min(2, Math.floor(ageMin / step));
}
export function isMature(a: Animal): boolean {
  return growthPeriod(a) >= 2;
}

// ===== Sức khoẻ / bệnh (Lttt gốc: server tính, ta mô phỏng lại vì không trích
// được công thức suy giảm/xác suất thật — FarmMsgHandler.cs chỉ đọc byte health
// và 2 cờ disease từ mạng, không thấy logic tính ở phía client) =====
const HEALTH_DECAY_PER_HOUR = 2;   // ước lượng — giảm nhẹ khi đói
const HEALTH_REGEN_PER_HOUR = 3;   // hồi khi no
const SICK_CHANCE_PER_HOUR = 0.02; // ước lượng — chỉ roll khi đói hoặc sức khoẻ thấp

function tickAnimal(a: Animal): void {
  if (a.health === undefined) a.health = 100;
  if (a.sick === undefined) a.sick = false;
  const last = a.healthAt ?? a.boughtAt;
  const hrs = (Date.now() - last) / 3600_000;
  if (hrs < 0.05) return; // đỡ tính lại liên tục mỗi lần mở dialog
  if (isHungry(a) || a.health < 50) {
    a.health = Math.max(0, a.health - HEALTH_DECAY_PER_HOUR * hrs);
    if (!a.sick && Math.random() < SICK_CHANCE_PER_HOUR * hrs) a.sick = true;
  } else if (a.health < 100) {
    a.health = Math.min(100, a.health + HEALTH_REGEN_PER_HOUR * hrs);
  }
  a.healthAt = Date.now();
}

export function getHealth(a: Animal): number {
  tickAnimal(a);
  return Math.round(a.health ?? 100);
}
export function isSick(a: Animal): boolean {
  tickAnimal(a);
  return !!a.sick;
}

export function cureAnimal(a: Animal): boolean {
  if (!isSick(a)) { toast('Bé này khoẻ mạnh, không cần chữa.'); return false; }
  if (itemCount('animal_med') <= 0) { toast('Hết thuốc thú y — mua ở Bách hóa.', 'feed'); return false; }
  removeItem('animal_med');
  a.sick = false;
  a.health = Math.min(100, (a.health ?? 100) + 20);
  a.healthAt = Date.now();
  save(); bus.emit(EV.STATE_CHANGED);
  toast(`${ANIMALS[a.type].name} đã khỏi bệnh!`, ANIMALS[a.type].icon);
  return true;
}

export function hasProduct(a: Animal): boolean {
  const def = ANIMALS[a.type];
  if (isHungry(a)) return false;
  if (growthPeriod(a) < 2) return false; // còn nhỏ, chưa cho sản phẩm (Lttt: period phải =2)
  return Date.now() - Math.max(a.fedAt, a.collectedAt) > def.produceMin * 60_000
    && a.collectedAt < a.fedAt + 24 * 3600_000;
}

export function feed(a: Animal): boolean {
  if (!isHungry(a)) { toast('Bé này no rồi!'); return false; }
  if (itemCount('feed') <= 0) { toast('Hết thức ăn — mua ở Bách hóa.', 'feed'); return false; }
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
  addTo('produce', def.product, qty);   // trứng/sữa/thịt/len -> kho nông trại
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
