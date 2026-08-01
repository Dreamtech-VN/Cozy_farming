// ===== Trang bị — đúng 8 ô của GunPow =====
// Bảng 7800-7807 của server GunPow ghi rõ 8 ô trang bị (Hán-Việt gốc là
// Vũ Khí · Thủ Trạc · Hạng Liên · Bảo Vật · Giới Chỉ · Huân Chương · Nhĩ Trụy ·
// Phó Thủ) — bên mình dịch sang tiếng Việt dễ đọc cho người chơi.
// Danh sách món lấy nguyên từ bảng vật phẩm của server rồi dịch tên:
//   7000 vũ khí (99) · 7100 Chi Giới · 7200 Chi Liên · 7300 Hộ Oản
//   7400 Huy Chương · 7500 Chi Bảo · 7600 Chi Trụy · 7700 Phó Thủ
// Icon giải từ .pkm của client (image/shopitems) bằng scripts/pkm_to_png.py.
// Vũ khí là ô mạnh nhất — chỉ số x1.6.

import RAW from './equip-items.json';
import GEMS_RAW from './gems.json';
import type { StatKey } from '@/core/types';

export type EquipSlot =
  'weapon' | 'hand' | 'necklace' | 'treasure' | 'ring' | 'medal' | 'earring' | 'offhand';

export interface EquipSlotDef {
  id: EquipSlot;
  name: string;
  main: StatKey;      // chỉ số chính
  sub: StatKey;       // chỉ số phụ
}

// thứ tự đúng theo bảng 7800-7807
export const EQUIP_SLOTS: EquipSlotDef[] = [
  { id: 'weapon', name: 'Vũ khí', main: 'strength', sub: 'agility' },
  { id: 'hand', name: 'Vòng tay', main: 'strength', sub: 'agility' },
  { id: 'necklace', name: 'Dây chuyền', main: 'intellect', sub: 'health' },
  { id: 'treasure', name: 'Bảo vật', main: 'agility', sub: 'charm' },
  { id: 'ring', name: 'Nhẫn', main: 'charm', sub: 'intellect' },
  { id: 'medal', name: 'Huy chương', main: 'health', sub: 'strength' },
  { id: 'earring', name: 'Bông tai', main: 'charm', sub: 'agility' },
  { id: 'offhand', name: 'Tay phụ', main: 'intellect', sub: 'strength' }
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
  sockets: number;     // số lỗ gắn đá
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
      // vũ khí là món mạnh nhất nên chỉ số nhân 1.6
      main: Math.round(tier * 3 * (s.id === 'weapon' ? 1.6 : 1)),
      sub: Math.max(1, Math.round(tier * 1.5 * (s.id === 'weapon' ? 1.6 : 1))),
      sockets: Math.min(3, 1 + Math.floor(tier / 8))
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
/** Bậc món -> hạng phẩm chất, dùng để tô viền ô như GunPow. */
export type EquipGrade = 'thuong' | 'tot' | 'hiem' | 'quy' | 'thanh';
export function equipGrade(tier: number): EquipGrade {
  if (tier >= 19) return 'thanh';
  if (tier >= 15) return 'quy';
  if (tier >= 10) return 'hiem';
  if (tier >= 5) return 'tot';
  return 'thuong';
}

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


// ===== Nâng sao (thăng tinh kiểu GunPow) =====
// Mỗi món lên tối đa 5 sao. Mỗi sao nhân thêm 15% chỉ số gốc, và cần
// "Thăng Tinh Thạch" — cấp sao càng cao thì đòi loại đá càng xịn.
export const MAX_STAR = 5;
export const STAR_STONES = ['star_stone_1', 'star_stone_2', 'star_stone_3'] as const;

export function starMul(star: number): number {
  return 1 + 0.15 * Math.max(0, Math.min(MAX_STAR, star));
}
/** Sao thứ `star+1` cần loại đá nào + bao nhiêu viên + bao nhiêu xu. */
export function starCost(def: EquipDef, star: number) {
  const kind = STAR_STONES[Math.min(2, Math.floor(star / 2))];
  return { kind, n: 2 + star * 2, coins: Math.round((def.price * 0.3 + 500) * (1 + star)) };
}
export function starRate(star: number): number {
  return [1, 0.85, 0.65, 0.45, 0.3][Math.min(4, star)];
}

// ===== Tẩy luyện (rửa lại dòng phụ kiểu GunPow) =====
// Ngoài chỉ số gốc, mỗi món còn 5 DÒNG TẨY LUYỆN — mỗi dòng là một loại chỉ số
// với một cấp từ 0 đến trần của món. Tẩy luyện gieo lại toàn bộ dòng chưa khoá;
// muốn giữ dòng đẹp thì khoá nó lại, mỗi ổ khoá tốn thêm một "Khoá Tẩy Luyện".
export const REFORGE_STONE = 'ref_stone';
export const REFORGE_LOCK = 'ref_lock';
export const REFORGE_LINES: StatKey[] = ['strength', 'health', 'agility', 'intellect', 'charm'];

/** Cấp cao nhất một dòng tẩy luyện của món này có thể gieo ra. */
export function reforgeMax(def: EquipDef): number {
  return Math.max(2, Math.min(10, 1 + Math.floor(def.tier / 2)));
}
/** Một dòng cấp `lv` cộng bao nhiêu điểm chỉ số. */
export function reforgePower(def: EquipDef, lv: number): number {
  return lv <= 0 ? 0 : Math.round(lv * (1 + def.tier * 0.25));
}
/** Xu phải trả cho một lần tẩy, tính cả tiền khoá. */
export function reforgeCost(def: EquipDef, locks: number) {
  return {
    coins: Math.round((def.price * 0.12 + 300) * (1 + locks * 0.5) / 10) * 10,
    stones: 1,
    locks
  };
}
/** Gieo một dòng: cấp thấp dễ ra, cấp trần hiếm. */
export function rollReforgeLine(max: number): number {
  const r = Math.random();
  return Math.max(0, Math.min(max, Math.floor(max * (1 - Math.pow(r, 0.55))) + (r < 0.04 ? 1 : 0)));
}

// ===== Đá quý (gắn đá) =====
export interface GemDef {
  id: string; lv: number; stat: StatKey; name: string; icon: string; w: number; h: number;
}
export const GEMS: Record<string, GemDef> = {};
for (const g of GEMS_RAW as unknown as GemDef[]) GEMS[g.id] = g;
export const GEM_LIST = Object.values(GEMS);
export function gemDef(id?: string): GemDef | undefined { return id ? GEMS[id] : undefined; }
/** Điểm chỉ số một viên đá cộng vào. */
export function gemPower(g: GemDef): number { return g.lv * 6; }
/** Ghép 3 viên cùng loại cùng cấp -> 1 viên cấp trên. */
export function gemMergeTo(g: GemDef): GemDef | undefined {
  return g.lv >= 10 ? undefined : GEM_LIST.find(x => x.stat === g.stat && x.lv === g.lv + 1);
}
export const GEM_MERGE_N = 3;
