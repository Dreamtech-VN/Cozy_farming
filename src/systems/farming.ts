import { S, save, addItem, removeItem, itemCount, addExp, addStat, addCoins, toolLevel } from '@/core/save';
import { toolBonus } from '@/data/tools';
import { addTo, takeFrom, countOf } from './farmstore';
import { petBonus } from '@/data/pets';
import { CROP_LIST } from '@/data/crops';
import { bus, EV, toast } from '@/core/events';
import { CROPS } from '@/data/crops';
import { sfx } from '@/core/audio';
import type { Plot } from '@/core/types';

// Lttt gốc: đất chia 4 khối riêng, mỗi khối 3 cột x 4 hàng = 12 ô, điền
// theo CỘT trong khối (col = j / numH, row = j % numH — không phải theo
// hàng như bản cũ). Tổng 4 khối x 12 = 48 ô, không phải 1 khối liền 52 ô.
export const BLOCK_COLS = 3;
export const BLOCK_ROWS = 4;
export const BLOCKS = 4;
export const BLOCK_GAP_COLS = 1;   // 1 cột trống ngăn cách các khối cho rõ ràng
export const MAX_PLOTS = BLOCK_COLS * BLOCK_ROWS * BLOCKS;
export const PLOT_PRICE_BASE = 200;      // giá mua thêm 1 ô đất, tăng dần

/** Vị trí lưới (cột, hàng) của ô đất thứ i — điền theo cột trong từng khối, khối cách nhau 1 cột trống. */
export function plotColRow(i: number): { col: number; row: number } {
  const perBlock = BLOCK_COLS * BLOCK_ROWS;
  const b = Math.floor(i / perBlock);
  const j = i % perBlock;
  const localCol = Math.floor(j / BLOCK_ROWS);
  const row = j % BLOCK_ROWS;
  return { col: b * (BLOCK_COLS + BLOCK_GAP_COLS) + localCol, row };
}

// Thứ tự mở khóa: lần lượt hết khối này tới khối kia, mỗi khối tự lan theo
// đúng thứ tự điền của nó (đã dễ với tới từ spawn vì khối 0 gần nhất).
export const UNLOCK_ORDER: number[] = Array.from({ length: MAX_PLOTS }, (_, i) => i);

export function ensurePlots() {
  while (S.farm.plots.length < MAX_PLOTS) S.farm.plots.push({ state: 'locked' });
  for (let i = 0; i < S.farm.unlocked; i++) {
    const idx = UNLOCK_ORDER[i];
    if (S.farm.plots[idx].state === 'locked') S.farm.plots[idx] = { state: 'empty' };
  }
}

export function plotPrice(): number {
  return PLOT_PRICE_BASE * Math.max(1, S.farm.unlocked - 5);
}

export function buyPlot(): boolean {
  if (S.farm.unlocked >= MAX_PLOTS) { toast('Đã mở hết đất!'); return false; }
  const price = plotPrice();
  if (S.wallet.coins < price) { toast(`Cần ${price} xu để mua đất.`, 'coin'); sfx.error(); return false; }
  S.wallet.coins -= price;
  S.farm.unlocked++;
  ensurePlots();
  bus.emit(EV.WALLET); bus.emit(EV.STATE_CHANGED); save();
  toast('Đã mua thêm 1 ô đất!', 'seed'); sfx.coin();
  addStat('plots_bought');
  return true;
}

export function till(i: number): boolean {
  const p = S.farm.plots[i];
  if (!p || p.state !== 'empty') return false;
  p.state = 'tilled';
  // cuốc cấp cao: cơ hội nhặt được hạt giống ngẫu nhiên trong đất
  if (Math.random() < toolBonus('hoe', S.tools.hoe)) {
    const c = CROP_LIST[Math.floor(Math.random() * CROP_LIST.length)];
    addTo('seeds', c.id);
    toast(`Cuốc trúng 1 Hạt ${c.name}!`, 'seed');
  }
  addStat('tilled'); sfx.plant(); save();
  bus.emit(EV.STATE_CHANGED);
  return true;
}

export function plant(i: number, cropId: string): boolean {
  const p = S.farm.plots[i];
  const c = CROPS[cropId];
  if (!p || p.state !== 'tilled' || !c) return false;
  // Lttt: hạt giống lấy từ KHO nông trại, không phải túi đồ
  if (!takeFrom('seeds', cropId)) { toast('Kho không còn hạt giống này.', 'seed'); return false; }
  p.state = 'planted'; p.crop = cropId; p.plantedAt = Date.now();
  p.watered = false; p.fertilized = false;
  p.health = 100;                    // Lttt: setSucKhoe(100) lúc gieo
  addStat('planted'); sfx.plant(); save();
  bus.emit(EV.STATE_CHANGED);
  return true;
}

export function water(i: number): boolean {
  const p = S.farm.plots[i];
  if (!p || p.state !== 'planted' || p.watered) return false;
  p.watered = true; p.wateredAt = Date.now();
  p.health = Math.min(100, (p.health ?? 100) + 20);   // tưới đúng lúc -> cây khỏe lại
  addStat('watered'); addStat('daily_watered'); sfx.water(); save();
  bus.emit(EV.STATE_CHANGED);
  return true;
}

export function fertilize(i: number): boolean {
  const p = S.farm.plots[i];
  if (!p || p.state !== 'planted' || p.fertilized) return false;
  if (countOf('fert', 'fertilizer') <= 0) { toast('Kho hết phân bón — mua ở shop nhé.', 'fertilizer'); return false; }
  takeFrom('fert', 'fertilizer');
  p.fertilized = true;
  p.health = Math.min(100, (p.health ?? 100) + 15);
  addStat('fertilized'); sfx.plant(); save();
  bus.emit(EV.STATE_CHANGED);
  return true;
}

// Sức khỏe cây (Lttt: sucKhoe 0..100). Trồng xong không tưới thì tụt dần,
// mỗi giờ bỏ khô mất 8 điểm. Sản lượng lúc thu hoạch nhân theo tỉ lệ này.
export function healthOf(p: Plot): number {
  if (p.state !== 'planted' || !p.plantedAt) return 100;
  const base = p.health ?? 100;
  if (p.watered) return Math.round(base);
  const hoursDry = (Date.now() - (p.wateredAt ?? p.plantedAt)) / 3_600_000;
  return Math.max(10, Math.round(base - hoursDry * 8));
}

// Tiến độ lớn 0..1. Chưa tưới thì cây chỉ lớn tối đa 30%.
export function growth(p: Plot): number {
  if (p.state !== 'planted' || !p.crop || !p.plantedAt) return 0;
  const c = CROPS[p.crop];
  let total = c.growMin * 60_000;
  if (p.fertilized) total *= 0.7;
  if (p.watered) total *= 1 - toolBonus('can', S.tools.can);   // bình tưới cấp cao
  const t = (Date.now() - p.plantedAt) / total;
  if (!p.watered) return Math.min(t, 0.3);
  return Math.min(t, 1);
}

export function stageOf(p: Plot): number {
  const c = p.crop ? CROPS[p.crop] : undefined;
  if (!c) return 0;
  return Math.min(c.stages - 1, Math.floor(growth(p) * c.stages));
}

export function isRipe(p: Plot): boolean {
  return p.state === 'planted' && growth(p) >= 1;
}

export function harvest(i: number): boolean {
  const p = S.farm.plots[i];
  if (!p || !isRipe(p) || !p.crop) return false;
  const c = CROPS[p.crop];
  let qty = c.yieldQty[0] + Math.floor(Math.random() * (c.yieldQty[1] - c.yieldQty[0] + 1));
  // Lttt: sanluong = quantity * sucKhoe / 100 -> cây yếu thu ít đi
  const hp = healthOf(p);
  qty = Math.max(1, Math.round(qty * hp / 100));
  // giỏ cấp cao: cơ hội +1 nông sản
  if (Math.random() < toolBonus('basket', toolLevel('basket'))) { qty += 1; toast('Giỏ xịn: +1 nông sản!', 'basket'); }
  // mèo đuổi chuột phá mùa màng
  if (Math.random() < petBonus('harvest')) { qty += 1; toast('Thú cưng lục lọi giúp: +1 nông sản!', 'pet'); }
  addTo('produce', c.id, qty);        // nông sản vào KHO, không vào túi
  // thu hoạch hoa thì có cơ hội hứng được mật ong từ đàn ong quanh vườn
  if (['grape', 'strawberry'].includes(c.id) && Math.random() < 0.25) {
    addItem('honey');   // addItem tự chuyển mật ong vào kho nông trại
    toast('Đàn ong ghé vườn: +1 Mật ong!', 'plant');
  }
  addExp(c.exp);
  if (!S.collections.crops.includes(c.id)) {
    S.collections.crops.push(c.id);
    toast(`Bộ sưu tập mới: ${c.name}!`, 'collection');
  }
  // Lttt: treeHarvest() set lại landItem.type=-1 (đất trống) sau khi thu
  // hoạch, không giữ trạng thái "đã cuốc" — phải cuốc lại từ đầu mới trồng
  // tiếp được, không phải cứ thu xong là trồng ngay.
  S.farm.plots[i] = { state: 'empty' };
  addStat('harvested', qty); addStat('daily_harvested', qty);
  sfx.harvest(); save();
  bus.emit(EV.STATE_CHANGED);
  toast(hp < 100 ? `+${qty} ${c.name} (sức khỏe ${hp}%)` : `+${qty} ${c.name}`, c.icon);
  return true;
}
