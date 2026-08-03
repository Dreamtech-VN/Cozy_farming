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

// Data Avatar gốc có vài id ảnh rỗng trắng xoá (đồ sự kiện cũ, hết hạn khi lấy về) —
// bỏ hẳn để không hiện món đồ vô hình trong tủ đồ/shop. Riêng z=65 (kính) chỉ có
// đúng 2 id trong data gốc và cả hai đều rỗng nên bỏ luôn slot "Kính".
const BROKEN_PARTS = new Set([
  313, 318, 319, 320, 321, 433, 435, 436, 437, 438, 439, 471, 479, 481, 483, 484,
  527, 554, 555, 561, 562, 566, 568, 588, 589, 594, 601, 602, 607, 637, 642
]);

export const CHIBI_PARTS: Record<number, ChibiPartDef> = {};
for (const [id, p] of Object.entries(RAW as Record<string, Omit<ChibiPartDef, 'id'>>)) {
  if (BROKEN_PARTS.has(Number(id)) || p.z === 65) continue;
  CHIBI_PARTS[Number(id)] = { id: Number(id), ...p };
}

export const BODY_ID = 0;   // thân "tròn"
export const EYES_ID = 4;   // mắt đen mặc định

export const Z_NAME: Record<number, string> = {
  10: 'Quần', 20: 'Áo', 40: 'Mắt', 50: 'Tóc', 60: 'Mũ', 70: 'Đồ cầm tay'
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

// Bộ đồ màn tạo nhân vật, ĐÚNG như RegisterScr.cs gốc: chỉ lấy part
// `level == 0` (không yêu cầu cấp) của đúng giới tính, loại đồ sự kiện có hạn
// dùng "(N ngày)" (không đủ điều kiện lúc mới tạo), rồi sắp theo id tăng dần
// — id nhỏ nhất trong bảng `items` là bộ đồ gốc đời đầu (sơ mi/short, siêu
// nhân, thợ săn, quý tộc...). Ngoài đời thật màn tạo nhân vật cho đúng 5 kiểu
// tóc, 9 áo, 9 quần mỗi giới — không phải cứ item nào rẻ nhất là được, mà
// đúng N item ĐẦU TIÊN theo thứ tự này.
export function registerList(z: number, gender: number, n: number): ChibiPartDef[] {
  return chibiList(z, gender)
    .filter(p => p.level === 0 && !/\(\s*\d+\s*ngày\s*\)/i.test(p.name))
    .sort((a, b) => a.id - b.id)
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
