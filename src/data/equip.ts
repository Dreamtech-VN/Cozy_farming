// ===== Trang bị (lấy từ GunPow, KHÔNG lấy vũ khí) =====
// 6 ô: nhẫn · dây chuyền · găng tay · huy chương · bảo vật · bông tai.
// Tên + thứ bậc chép từ bảng vật phẩm của server GunPow (7100 Chi Giới,
// 7200 Chi Liên, 7300 Hộ Oản, 7400 Huy Chương, 7500 Chi Bảo, 7600 Chi Trụy);
// icon giải từ ảnh .pkm của client bằng scripts/pkm_to_png.py.
//
// Vũ khí thì bỏ hẳn — game này là game nông trại, không có đánh nhau.

import RAW from './equip-items.json';
import type { StatKey } from '@/core/types';

export type EquipSlot = 'ring' | 'necklace' | 'hand' | 'medal' | 'treasure' | 'earring';

export interface EquipSlotDef {
  id: EquipSlot;
  name: string;
  main: StatKey;      // chỉ số chính
  sub: StatKey;       // chỉ số phụ
}

export const EQUIP_SLOTS: EquipSlotDef[] = [
  { id: 'ring', name: 'Nhẫn', main: 'charm', sub: 'intellect' },
  { id: 'necklace', name: 'Dây chuyền', main: 'intellect', sub: 'health' },
  { id: 'hand', name: 'Găng tay', main: 'strength', sub: 'agility' },
  { id: 'medal', name: 'Huy chương', main: 'health', sub: 'strength' },
  { id: 'treasure', name: 'Bảo vật', main: 'agility', sub: 'charm' },
  { id: 'earring', name: 'Bông tai', main: 'charm', sub: 'agility' }
];

export const SLOT_OF: Record<EquipSlot, EquipSlotDef> =
  Object.fromEntries(EQUIP_SLOTS.map(s => [s.id, s])) as Record<EquipSlot, EquipSlotDef>;

export interface EquipDef {
  id: string;          // 'ring_003'
  slot: EquipSlot;
  tier: number;        // 1..21 — càng cao càng xịn
  name: string;
  url: string;
  w: number; h: number;
  price: number;
  main: number;        // điểm chỉ số chính khi chưa đập
  sub: number;
}

type Row = { i: number; name: string; w: number; h: number };
const rows = RAW as unknown as Record<EquipSlot, Row[]>;

export const EQUIPS: Record<string, EquipDef> = {};
for (const s of EQUIP_SLOTS) {
  (rows[s.id] ?? []).forEach((r, k) => {
    const tier = k + 1;
    const id = `${s.id}_${String(r.i).padStart(3, '0')}`;
    EQUIPS[id] = {
      id, slot: s.id, tier, name: r.name,
      url: `assets/equip/${id}.png`, w: r.w, h: r.h,
      // giá tăng dần theo bậc; toàn bộ mua bằng XU (lượng là tiền nạp)
      price: Math.round(600 * Math.pow(1.55, tier - 1) / 100) * 100,
      main: tier * 3,
      sub: Math.max(1, Math.round(tier * 1.5))
    };
  });
}

export const EQUIP_LIST = Object.values(EQUIPS);
export function equipsOfSlot(slot: EquipSlot): EquipDef[] {
  return EQUIP_LIST.filter(e => e.slot === slot).sort((a, b) => a.tier - b.tier);
}
export function equipDef(id?: string): EquipDef | undefined {
  return id ? EQUIPS[id] : undefined;
}

// ===== Đập trang bị (cường hoá kiểu GunPow) =====
// Mỗi món đập được tới +15. Mỗi cấp cộng thêm 12% chỉ số gốc của món.
// Càng lên cao tỉ lệ càng thấp và cần nhiều đá cường hoá hơn.
export const MAX_ENHANCE = 15;
export const ENHANCE_STONE = 'enh_stone';

/** Chỉ số cộng thêm theo cấp đập. */
export function enhanceMul(lv: number): number {
  return 1 + 0.12 * Math.max(0, Math.min(MAX_ENHANCE, lv));
}

/** Tỉ lệ thành công khi đập từ `lv` lên `lv+1`. */
export function enhanceRate(lv: number): number {
  if (lv < 3) return 1;                     // +1..+3 chắc chắn ăn
  return Math.max(0.18, 1 - (lv - 2) * 0.07);
}

/** Chi phí đập từ `lv` lên `lv+1`. */
export function enhanceCost(def: EquipDef, lv: number) {
  return {
    coins: Math.round((def.price * 0.12 + 120) * (1 + lv * 0.35) / 10) * 10,
    stones: 1 + Math.floor(lv / 3)
  };
}

/** Đập hỏng ở cấp cao thì TỤT 1 cấp (như GunPow), thấp thì chỉ mất phí. */
export function dropsOnFail(lv: number): boolean {
  return lv >= 7;
}
