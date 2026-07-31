// ===== Nhân vật chibi kiểu Avatar =====
// Part export từ resource Avatar (xem docs/ASSETS.md — chỉ dùng dev/test).
// Mỗi part: strip 15 frame 64x96 tại assets/chibi/<id>.png, neo chân (32,88).
// zOrder: 10 quần | 20 áo | 30 thân | 40 mắt | 50 tóc | 60 mũ | 65 kính | 70 phụ kiện cầm

import RAW from './chibi-parts.json';
import { SKINS } from './skins';

export interface ChibiPartDef {
  id: number;
  name: string;
  z: number;
  gender: number;          // 0 unisex, 1 nam, 2 nữ (theo data Avatar)
  level: number;           // 0 = đồ khởi đầu
  coin: number;            // giá gốc Avatar (xu Avatar)
  gold: number;            // giá lượng (ruby)
}

export const CHIBI_PARTS: Record<number, ChibiPartDef> = {};
for (const [id, p] of Object.entries(RAW as Record<string, Omit<ChibiPartDef, 'id'>>)) {
  CHIBI_PARTS[Number(id)] = { id: Number(id), ...p };
}

export const BODY_ID = 0;   // thân "tròn"
export const EYES_ID = 4;   // mắt đen mặc định

export const Z_NAME: Record<number, string> = {
  10: 'Quần', 20: 'Áo', 40: 'Mắt', 50: 'Tóc', 60: 'Mũ', 65: 'Kính', 70: 'Đồ cầm tay'
};

export function chibiList(z: number, gender?: number): ChibiPartDef[] {
  return Object.values(CHIBI_PARTS)
    .filter(p => p.z === z && (gender === undefined || p.gender === gender || p.gender === 0))
    .sort((a, b) => a.level - b.level || a.id - b.id);
}

export function starterList(z: number, gender: number): ChibiPartDef[] {
  return chibiList(z, gender).filter(p => p.level === 0);
}

// LƯU Ý: data Avatar quy ước gender 0 = unisex (thân, mắt), 1 = NAM, 2 = NỮ
// (kiểm chứng bằng tên đồ: "sơ mi/siêu nhân/thợ săn" = 1, "búp bê/bạch tuyết/thun nữ" = 2)
export const G_MALE = 1;
export const G_FEMALE = 2;

// n món "đơn giản nhất" cho màn tạo nhân vật: đồ cơ bản đời đầu (id nhỏ, level 0),
// loại đồ ruby và đồ sự kiện có hạn dùng "(30/45 ngày)"
export function simplestList(z: number, gender: number, n = 3): ChibiPartDef[] {
  return chibiList(z, gender)
    .filter(p => p.gold <= 0 && !/\(\s*\d+\s*ngày\s*\)/i.test(p.name))
    .sort((a, b) => a.level - b.level || a.id - b.id)
    .slice(0, n);
}

// Quy đổi giá gốc Avatar về kinh tế game (xu Avatar lớn hơn nhiều).
// MỌI món trong shop đều bán bằng XU — ruby (tiền nạp) để dành cho thứ khác.
// Đồ vốn tính bằng "lượng" quy sang xu theo bậc cao hơn đồ thường cho vẫn hiếm:
// đồ thường 100..6.000 xu, đồ lượng 500..48.000 xu.
export function chibiPriceXu(p: ChibiPartDef): number {
  if (p.gold > 0) return Math.max(500, p.gold * 100);
  return Math.max(100, Math.round(p.coin / 100));
}

export interface ChibiLook {
  gender: number;          // 1 nam, 2 nữ
  pant: number;
  shirt: number;
  hair: number;
  eyes: number;
  hat: number;             // 0 = không đội
  glasses: number;         // 0 = không đeo
  hand?: number;           // 0/undefined = tay không (đồ cầm tay z=70)
  skin?: string;           // id skin trọn bộ — mặc vào thay toàn bộ trang phục
}

export function defaultLook(gender: number): ChibiLook {
  const pick = (z: number) => starterList(z, gender)[0]?.id ?? 0;
  return {
    gender,
    pant: pick(10),
    shirt: pick(20),
    hair: pick(50),
    eyes: EYES_ID,
    hat: 0, glasses: 0, hand: 0
  };
}

// thứ tự vẽ các lớp (dưới -> trên)
export function lookLayers(l: ChibiLook): number[] {
  // mặc skin -> dùng nguyên bộ của skin (giữ mắt + đồ cầm tay)
  if (l.skin) {
    const sk = SKINS[l.skin];
    if (sk) {
      const o: number[] = [];
      if (sk.parts.pant) o.push(sk.parts.pant);
      if (sk.parts.shirt) o.push(sk.parts.shirt);
      o.push(BODY_ID);
      o.push(l.eyes || EYES_ID);
      if (sk.parts.hair) o.push(sk.parts.hair);
      if (sk.parts.hat) o.push(sk.parts.hat);
      if (sk.parts.glasses) o.push(sk.parts.glasses);
      if (l.hand) o.push(l.hand);
      return o;
    }
  }
  const out: number[] = [];
  if (l.pant) out.push(l.pant);
  if (l.shirt) out.push(l.shirt);
  out.push(BODY_ID);
  out.push(l.eyes || EYES_ID);
  if (l.hair) out.push(l.hair);
  if (l.hat) out.push(l.hat);
  if (l.glasses) out.push(l.glasses);
  if (l.hand) out.push(l.hand);     // đồ cầm tay vẽ trên cùng
  return out;
}

// ===== Chỉ số trang bị (kiểu Avatar/Lttt) =====
// Quần(10), Áo(20), Mắt(40), Tóc(50), Mũ(60), Kính(65) tăng chỉ số.
// Đồ cầm tay(70) và Skin KHÔNG tăng chỉ số.
import type { CharStats, StatKey } from '@/core/types';

const STAT_LAYERS = new Set([10, 20, 40, 50, 60, 65]);
const STAT_KEYS: StatKey[] = ['health', 'intellect', 'strength', 'agility', 'charm'];

// Mỗi z-layer thiên về 1-2 chỉ số chính
const Z_BIAS: Record<number, StatKey[]> = {
  10: ['agility', 'strength'],    // quần → nhanh nhẹn, sức mạnh
  20: ['strength', 'health'],     // áo → sức mạnh, sức khỏe
  40: ['charm', 'intellect'],     // mắt → quyến rũ, trí tuệ
  50: ['charm', 'agility'],       // tóc → quyến rũ, nhanh nhẹn
  60: ['health', 'intellect'],    // mũ → sức khỏe, trí tuệ
  65: ['intellect', 'charm'],     // kính → trí tuệ, quyến rũ
};

export function partStats(p: ChibiPartDef): CharStats | null {
  if (!STAT_LAYERS.has(p.z)) return null;
  const tier = p.level <= 0 ? 1 : Math.min(p.level, 10);
  const price = p.gold > 0 ? p.gold * 50 : p.coin;
  const priceTier = price <= 1000 ? 0 : price <= 5000 ? 1 : price <= 20000 ? 2 : 3;
  const base = tier + priceTier;
  const bias = Z_BIAS[p.z] || ['charm'];
  const stats: CharStats = { health: 0, intellect: 0, strength: 0, agility: 0, charm: 0 };
  // chỉ số chính
  stats[bias[0]] = base + 1;
  if (bias[1]) stats[bias[1]] = base;
  // chỉ số phụ: dùng id part để phân phối đều
  const rest = STAT_KEYS.filter(k => !bias.includes(k));
  for (let i = 0; i < rest.length; i++) {
    stats[rest[i]] = Math.max(0, Math.floor(base * 0.4) + ((p.id + i) % 2));
  }
  return stats;
}

export function equipStats(look: ChibiLook): CharStats {
  const total: CharStats = { health: 0, intellect: 0, strength: 0, agility: 0, charm: 0 };
  if (look.skin) return total; // skin không cộng chỉ số
  const slots = [look.pant, look.shirt, look.eyes, look.hair, look.hat, look.glasses];
  for (const pid of slots) {
    if (!pid) continue;
    const p = CHIBI_PARTS[pid];
    if (!p) continue;
    const s = partStats(p);
    if (!s) continue;
    for (const k of STAT_KEYS) total[k] += s[k];
  }
  return total;
}

export function formatStats(s: CharStats): string[] {
  const names: Record<StatKey, string> = {
    health: 'SK', intellect: 'TT', strength: 'SM', agility: 'NN', charm: 'QR'
  };
  return STAT_KEYS.filter(k => s[k] > 0).map(k => `${names[k]}+${s[k]}`);
}

// ===== Biểu cảm (part mắt Avatar) =====
// Dùng khi diễn hành động: khóc khi bị đá, xấu hổ khi được hôn, vui khi được ôm...
export const FACE = {
  normal: EYES_ID,   // mắt thường
  sad: 5,            // Mắt buồn
  happy: 6,          // Mắt vui
  wink: 7,           // Mắt nháy
  angry: 8,          // Mắt giận
  cry: 9,            // Mắt khóc
  laugh: 10,         // Mắt cười to
  tongue: 11,        // Mắt lè lưỡi
  shy: 12,           // Mắt xấu hổ
  hurt: 20,          // Mắt chảy máu (đau)
  kiss: 107          // Mắt hôn (nhắm mắt)
} as const;
export type FaceKey = keyof typeof FACE;
