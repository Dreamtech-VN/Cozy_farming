// ===== Nhân vật chibi kiểu Avatar =====
// Part export từ resource Avatar (xem docs/ASSETS.md — chỉ dùng dev/test).
// Mỗi part: strip 15 frame 64x96 tại assets/chibi/<id>.png, neo chân (32,88).
// zOrder: 5 cánh | 10 quần | 20 áo | 30 thân | 40 mắt | 50 tóc | 60 mũ | 65 kính | 70 phụ kiện cầm

import RAW from './chibi-parts.json';

export interface ChibiPartDef {
  id: number;
  name: string;
  z: number;
  gender: number;          // 0 nam, 1 nữ, 2 unisex
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
  5: 'Cánh', 10: 'Quần', 20: 'Áo', 40: 'Mắt', 50: 'Tóc', 60: 'Mũ', 65: 'Kính', 70: 'Phụ kiện'
};

export function chibiList(z: number, gender?: number): ChibiPartDef[] {
  return Object.values(CHIBI_PARTS)
    .filter(p => p.z === z && (gender === undefined || p.gender === gender || p.gender === 2))
    .sort((a, b) => a.level - b.level || a.id - b.id);
}

export function starterList(z: number, gender: number): ChibiPartDef[] {
  return chibiList(z, gender).filter(p => p.level === 0);
}

// quy đổi giá gốc Avatar về kinh tế game (xu Avatar lớn hơn nhiều)
export function chibiPriceXu(p: ChibiPartDef): number {
  if (p.gold > 0) return 0;
  return Math.max(100, Math.round(p.coin / 100));
}
export function chibiPriceRuby(p: ChibiPartDef): number {
  return p.gold > 0 ? Math.max(1, Math.round(p.gold / 2)) : 0;
}

export interface ChibiLook {
  gender: number;          // 0 nam, 1 nữ
  pant: number;
  shirt: number;
  hair: number;
  eyes: number;
  hat: number;             // 0 = không đội
  glasses: number;         // 0 = không đeo
  wing: number;            // 0 = không có cánh
}

export function defaultLook(gender: number): ChibiLook {
  const pick = (z: number) => starterList(z, gender)[0]?.id ?? 0;
  return {
    gender,
    pant: pick(10),
    shirt: pick(20),
    hair: pick(50),
    eyes: EYES_ID,
    hat: 0, glasses: 0, wing: 0
  };
}

// thứ tự vẽ các lớp (dưới -> trên)
export function lookLayers(l: ChibiLook): number[] {
  const out: number[] = [];
  if (l.wing) out.push(l.wing);
  if (l.pant) out.push(l.pant);
  if (l.shirt) out.push(l.shirt);
  out.push(BODY_ID);
  out.push(l.eyes || EYES_ID);
  if (l.hair) out.push(l.hair);
  if (l.hat) out.push(l.hat);
  if (l.glasses) out.push(l.glasses);
  return out;
}
