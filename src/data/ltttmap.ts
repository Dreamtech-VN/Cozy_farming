// ===== Lưới ô gốc của map Lttt =====
// Data giải từ `a.clazz` của client Avatar bằng scripts/decode_lttt_maps.py:
// mỗi map là lưới ô 48px (w=24 * hd=2), có sẵn ô nào đi được, mặt tiền công
// trình (cửa vào), trạm xe buýt và chỗ đứng chờ xe — đúng y như client.
//
// Ảnh nền ghép xong thì ĐÁY ảnh trùng đáy lưới, nên hàng r của lưới nằm ở
// khoảng y = gridTopPx + r*48 trên ảnh (gridTopPx có thể âm khi ảnh thấp hơn lưới).

import RAW from './lttt-maps.json';

export interface LtttMap {
  w: number;               // số ô ngang
  h: number;               // số ô dọc
  tile: number;            // 48
  img: [number, number];   // cỡ ảnh nền đã ghép (px)
  gridTopPx: number;       // y trên ảnh của hàng ô đầu tiên
  walk: string[];          // '.' đi được, '#' chặn
  doors: [number, number][];
  busStop: [number, number, number][];  // [x, y, dài] theo ô
  wait: [number, number, number][];
  fronts: [number, number, number, number][];  // [x, y, dài, mã ô]
}

const MAPS = RAW as unknown as Record<string, LtttMap>;

export function ltttMap(id?: string): LtttMap | undefined {
  return id ? MAPS[id] : undefined;
}

/** Ô lưới ở toạ độ px trên ảnh nền có đi được không. */
export function ltttWalkable(m: LtttMap, px: number, py: number): boolean {
  const c = Math.floor(px / m.tile);
  const r = Math.floor((py - m.gridTopPx) / m.tile);
  if (r < 0 || r >= m.h || c < 0 || c >= m.w) return false;
  return m.walk[r][c] === '.';
}

/** Đổi một dải ô [x, y, dài] thành khung px trên ảnh nền. */
export function ltttRect(m: LtttMap, run: number[]): { x: number; y: number; w: number; h: number } {
  return {
    x: run[0] * m.tile,
    y: m.gridTopPx + run[1] * m.tile,
    w: (run[2] ?? 1) * m.tile,
    h: m.tile
  };
}

/** Tâm mép dưới của một dải ô — chỗ nhân vật đứng khi tới nơi. */
export function ltttFoot(m: LtttMap, run: number[]): { x: number; y: number } {
  const r = ltttRect(m, run);
  return { x: r.x + r.w / 2, y: r.y + r.h };
}
