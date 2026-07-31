// ===== Bảng đơn hàng kiểu Hay Day =====
// Mỗi đơn là một tờ giấy ghim: nơi đặt + danh sách hàng + thưởng xu/EXP.
// Hàng lấy từ KHO nông trại (nông sản + món đã nấu), giao xong nhận thưởng.
// Có thể bỏ đơn để đổi đơn mới (chờ hồi), và thỉnh thoảng có NPC vào tận
// nông trại đặt hàng — đơn đó thưởng cao hơn.

import { S, save, addCoins, addExp, addStat } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { CROPS, CROP_LIST } from '@/data/crops';
import { FOODS, FOOD_LIST } from '@/data/foods';
import { countOf, takeFrom } from './farmstore';
import { sfx } from '@/core/audio';

export interface OrderLine { id: string; qty: number }   // id: cropId hoặc food_<id>
export interface Order {
  id: string;
  place: string;          // nơi đặt hàng
  lines: OrderLine[];
  coins: number;
  exp: number;
  at: number;
  visitor?: boolean;      // NPC vào tận trại đặt -> thưởng cao hơn
}

export const MAX_ORDERS = 9;
const REROLL_MS = 5 * 60_000;      // bỏ đơn xong 5 phút mới có đơn mới

// Nơi đặt hàng (kiểu Church / Kindergarten / Susan's Store của Hay Day)
const PLACES = [
  'Nhà thờ', 'Trường mẫu giáo', 'Tiệm Cô Mai', 'Xưởng Chú Hùng',
  'Trường học', 'Quán Chị Lan', 'Chợ Thị Trấn', 'Quán ăn Bãi Biển'
];
// NPC có thể ghé tận nông trại
const VISITORS = ['Cô Mai', 'Chú Hùng', 'Chị Lan', 'Thầy Giáo', 'Bé Tuấn'];

export function orderName(id: string): string {
  if (id.startsWith('food_')) return FOODS[id.slice(5)]?.name ?? id;
  return CROPS[id]?.name ?? id;
}
function unitPrice(id: string): number {
  if (id.startsWith('food_')) return FOODS[id.slice(5)]?.sell ?? 200;
  return CROPS[id]?.sellPrice ?? 20;
}

function rnd<T>(a: T[]): T { return a[Math.floor(Math.random() * a.length)]; }

// Đơn chỉ gọi thứ người chơi trồng/nấu được — cây theo cấp, món khi đã mở bếp
function cropPool(level: number): string[] {
  const crops = CROP_LIST.filter(c => (c.seedPrice ?? 0) <= 40 + level * 20).map(c => c.id);
  return crops.length ? crops : CROP_LIST.slice(0, 4).map(c => c.id);
}
function foodPool(level: number): string[] {
  return level >= 3 ? FOOD_LIST.map(f => `food_${f.id}`) : [];
}

export function makeOrder(visitor = false): Order {
  const lv = S.player.level;
  const crops = cropPool(lv);
  const foods = foodPool(lv);
  // Kiểu Hay Day: một đơn trộn cả món nấu sẵn lẫn nguyên liệu thô, không phải
  // toàn cùng một loại. Từ cấp 3 (đã mở bếp) đơn luôn cố lấy ít nhất 1 món nấu
  // rồi ghép thêm 1-2 nông sản.
  const nLines = Math.min(3, 1 + Math.floor(Math.random() * (1 + Math.floor(lv / 3))));
  const wanted: string[] = [];
  if (foods.length && (nLines > 1 || Math.random() < 0.4)) wanted.push(rnd(foods));
  while (wanted.length < nLines) {
    const pool = wanted.length && foods.length && Math.random() < 0.25 ? foods : crops;
    const id = rnd(pool);
    if (!wanted.includes(id)) wanted.push(id);
    else if (wanted.length >= crops.length + foods.length) break;
  }
  if (!wanted.length) wanted.push(rnd(crops));

  const picked: OrderLine[] = wanted.map(id => ({
    // món nấu đắt hơn nông sản nhiều -> chỉ gọi 1-2 phần cho đơn khỏi chênh lệch quá
    id, qty: 1 + Math.floor(Math.random() * (id.startsWith('food_') ? 2 : 3))
  }));

  const worth = picked.reduce((a, l) => a + unitPrice(l.id) * l.qty, 0);
  const mul = visitor ? 2.2 : 1.5;      // giao đơn lãi hơn bán lẻ
  return {
    id: `od_${Date.now()}_${Math.floor(Math.random() * 1000)}`,
    place: visitor ? rnd(VISITORS) : rnd(PLACES),
    lines: picked,
    coins: Math.round(worth * mul),
    exp: Math.max(3, Math.round(worth / 40)),
    at: Date.now(),
    visitor
  };
}

export function ensureOrders() {
  if (!S.orders) S.orders = [];
  while (S.orders.length < MAX_ORDERS) S.orders.push(makeOrder());
}

export function orderList(): Order[] {
  ensureOrders();
  return S.orders;
}

export function canDeliver(o: Order): boolean {
  return o.lines.every(l => countOf('produce', l.id) >= l.qty);
}

export function haveOf(l: OrderLine): number {
  return countOf('produce', l.id);
}

export function deliver(orderId: string): boolean {
  ensureOrders();
  const i = S.orders.findIndex(o => o.id === orderId);
  if (i < 0) return false;
  const o = S.orders[i];
  if (!canDeliver(o)) { toast('Kho chưa đủ hàng cho đơn này.', 'alert'); return false; }
  for (const l of o.lines) takeFrom('produce', l.id, l.qty);
  addCoins(o.coins);
  addExp(o.exp);
  addStat('orders_done');
  S.orders.splice(i, 1, makeOrder());
  save(true); sfx.coin();
  bus.emit(EV.STATE_CHANGED);
  toast(`Giao hàng cho ${o.place}: +${o.coins} xu, +${o.exp} EXP`, 'coin');
  return true;
}

// Bỏ đơn -> đơn mới, nhưng phải chờ (như Hay Day)
export function dropOrder(orderId: string): boolean {
  ensureOrders();
  const i = S.orders.findIndex(o => o.id === orderId);
  if (i < 0) return false;
  const last = S.stats['order_drop_at'] ?? 0;
  const left = REROLL_MS - (Date.now() - last);
  if (left > 0) {
    toast(`Chờ ${Math.ceil(left / 60000)} phút nữa mới bỏ được đơn khác.`, 'alert');
    return false;
  }
  S.stats['order_drop_at'] = Date.now();
  S.orders.splice(i, 1, makeOrder());
  save(true);
  bus.emit(EV.STATE_CHANGED);
  toast('Đã bỏ đơn, có đơn mới rồi!', 'check');
  return true;
}

// ===== NPC ghé tận nông trại đặt hàng =====
// Cứ ~4 phút có cơ hội xuất hiện một khách, đứng chờ 3 phút rồi về.
export const VISIT_MS = 3 * 60_000;

export function visitorOrder(): Order | undefined {
  const v = S.orders?.find(o => o.visitor);
  if (!v) return undefined;
  if (Date.now() - v.at > VISIT_MS) {           // khách chờ lâu quá thì về
    const i = S.orders.indexOf(v);
    S.orders.splice(i, 1, makeOrder());
    save();
    return undefined;
  }
  return v;
}

export function maybeSpawnVisitor(): Order | undefined {
  ensureOrders();
  if (S.orders.some(o => o.visitor)) return visitorOrder();
  if (Math.random() > 0.25) return undefined;
  const i = Math.floor(Math.random() * S.orders.length);
  const o = makeOrder(true);
  S.orders.splice(i, 1, o);
  save();
  toast(`${o.place} vừa ghé nông trại đặt hàng!`, 'chat');
  bus.emit(EV.STATE_CHANGED);
  return o;
}
