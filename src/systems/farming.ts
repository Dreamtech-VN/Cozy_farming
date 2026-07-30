import { S, save, addItem, removeItem, itemCount, addExp, addStat, addCoins } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { CROPS } from '@/data/crops';
import { sfx } from '@/core/audio';
import type { Plot } from '@/core/types';

export const FARM_COLS = 8;
export const FARM_ROWS = 6;
export const MAX_PLOTS = FARM_COLS * FARM_ROWS;
export const PLOT_PRICE_BASE = 200;      // giá mua thêm 1 ô đất, tăng dần

// Thứ tự mở khóa: lan dần từ góc trên-trái thành khối (dễ với tới từ spawn)
export const UNLOCK_ORDER: number[] = Array.from({ length: MAX_PLOTS }, (_, i) => i)
  .sort((a, b) => {
    const ka = (a % FARM_COLS) + Math.floor(a / FARM_COLS) * 1.5;
    const kb = (b % FARM_COLS) + Math.floor(b / FARM_COLS) * 1.5;
    return ka - kb;
  });

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
  if (S.wallet.coins < price) { toast(`Cần ${price} xu để mua đất.`, '💰'); sfx.error(); return false; }
  S.wallet.coins -= price;
  S.farm.unlocked++;
  ensurePlots();
  bus.emit(EV.WALLET); bus.emit(EV.STATE_CHANGED); save();
  toast('Đã mua thêm 1 ô đất!', '🟫'); sfx.coin();
  addStat('plots_bought');
  return true;
}

export function till(i: number): boolean {
  const p = S.farm.plots[i];
  if (!p || p.state !== 'empty') return false;
  p.state = 'tilled';
  addStat('tilled'); sfx.plant(); save();
  bus.emit(EV.STATE_CHANGED);
  return true;
}

export function plant(i: number, cropId: string): boolean {
  const p = S.farm.plots[i];
  const c = CROPS[cropId];
  if (!p || p.state !== 'tilled' || !c) return false;
  if (!removeItem(`seed_${cropId}`)) { toast('Không còn hạt giống này.'); return false; }
  p.state = 'planted'; p.crop = cropId; p.plantedAt = Date.now();
  p.watered = false; p.fertilized = false;
  addStat('planted'); sfx.plant(); save();
  bus.emit(EV.STATE_CHANGED);
  return true;
}

export function water(i: number): boolean {
  const p = S.farm.plots[i];
  if (!p || p.state !== 'planted' || p.watered) return false;
  p.watered = true; p.wateredAt = Date.now();
  addStat('watered'); addStat('daily_watered'); sfx.water(); save();
  bus.emit(EV.STATE_CHANGED);
  return true;
}

export function fertilize(i: number): boolean {
  const p = S.farm.plots[i];
  if (!p || p.state !== 'planted' || p.fertilized) return false;
  if (itemCount('fertilizer') <= 0) { toast('Chưa có phân bón — mua ở shop nhé.', '💩'); return false; }
  removeItem('fertilizer');
  p.fertilized = true;
  addStat('fertilized'); sfx.plant(); save();
  bus.emit(EV.STATE_CHANGED);
  return true;
}

// Tiến độ lớn 0..1. Chưa tưới thì cây chỉ lớn tối đa 30%.
export function growth(p: Plot): number {
  if (p.state !== 'planted' || !p.crop || !p.plantedAt) return 0;
  const c = CROPS[p.crop];
  let total = c.growMin * 60_000;
  if (p.fertilized) total *= 0.7;
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
  const qty = c.yieldQty[0] + Math.floor(Math.random() * (c.yieldQty[1] - c.yieldQty[0] + 1));
  addItem(`crop_${c.id}`, qty);
  addExp(c.exp);
  if (!S.collections.crops.includes(c.id)) {
    S.collections.crops.push(c.id);
    toast(`Bộ sưu tập mới: ${c.name}!`, '📖');
  }
  S.farm.plots[i] = { state: 'tilled' };
  addStat('harvested', qty); addStat('daily_harvested', qty);
  sfx.harvest(); save();
  bus.emit(EV.STATE_CHANGED);
  toast(`+${qty} ${c.name}`, c.icon);
  return true;
}
