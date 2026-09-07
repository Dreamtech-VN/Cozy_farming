/**
 * Tileset 16×16. Quy tắc quan trọng nhất: tile phải ghép LIỀN nhau ở mọi tổ
 * hợp, nên hoa văn không được chạm mép trái/phải, và mép trên của tile đất phải
 * khớp với mép dưới của tile cỏ.
 */
import { P } from './palette.mjs';

export const TILE = 16;
export const TILE_NAMES = [
  'grass_top_a', 'grass_top_b', 'grass_top_c',
  'dirt_a', 'dirt_b',
  'stone_a', 'stone_b',
  'water_a', 'water_b',
];

/** Nhiễu cố định theo toạ độ — cùng một tile luôn ra cùng một hoa văn. */
const noise = (x, y, seed) => {
  const n = Math.sin(x * 12.9898 + y * 78.233 + seed * 37.719) * 43758.5453;
  return n - Math.floor(n);
};

function grassTop(px, ox, variant) {
  // 4 dòng cỏ ở trên, phần còn lại là đất: đây là tile "mặt đất" chuẩn.
  px.rect(ox, 0, TILE, 4, P.grass);
  px.rect(ox, 0, TILE, 1, P.grassLight);
  px.rect(ox, 4, TILE, TILE - 4, P.dirt);
  // Răng cưa giữa cỏ và đất, lệch theo variant nên xếp cạnh nhau không bị lặp.
  for (let x = 0; x < TILE; x++) {
    const d = noise(x, variant, 3) > 0.55 ? 1 : 0;
    px.set(ox + x, 4 + d, P.grassDark);
    if (d === 1) px.set(ox + x, 4, P.grass);
  }
  // Vài hạt sỏi trong đất, tránh xa hai mép để ghép tile không lộ đường nối.
  for (let i = 0; i < 3; i++) {
    const x = 3 + Math.floor(noise(i, variant, 11) * (TILE - 6));
    const y = 8 + Math.floor(noise(i, variant, 23) * 6);
    px.set(ox + x, y, P.dirtDark);
    px.set(ox + x + 1, y, P.dirtDark);
  }
}

function dirt(px, ox, variant) {
  px.rect(ox, 0, TILE, TILE, P.dirt);
  for (let i = 0; i < 5; i++) {
    const x = 2 + Math.floor(noise(i, variant, 5) * (TILE - 4));
    const y = 1 + Math.floor(noise(i, variant, 7) * (TILE - 3));
    px.set(ox + x, y, P.dirtDark);
    px.set(ox + x + 1, y, P.dirtDark);
    px.set(ox + x, y + 1, P.dirtLight);
  }
}

function stone(px, ox, variant) {
  px.rect(ox, 0, TILE, TILE, P.stone);
  // Mạch vữa chạy hết bề ngang để hai tile cạnh nhau nối thành hàng gạch.
  px.rect(ox, 0, TILE, 1, P.stoneLight);
  px.rect(ox, 7, TILE, 1, P.stoneDark);
  px.rect(ox, 15, TILE, 1, P.stoneDark);
  const seam = variant === 0 ? 4 : 11;
  px.rect(ox + seam, 0, 1, 8, P.stoneDark);
  px.rect(ox + (seam + 8) % TILE, 8, 1, 8, P.stoneDark);
}

function water(px, ox, variant) {
  px.rect(ox, 0, TILE, TILE, P.water);
  px.rect(ox, 0, TILE, 2, P.waterLight);
  for (let x = 0; x < TILE; x++) {
    const wave = Math.sin((x + variant * 4) * 0.6) > 0.3 ? 1 : 0;
    px.set(ox + x, 3 + wave, P.waterLight);
    px.set(ox + x, 9 + wave, P.waterDark);
  }
}

export function drawTiles(px) {
  const draw = [
    (o) => grassTop(px, o, 0), (o) => grassTop(px, o, 1), (o) => grassTop(px, o, 2),
    (o) => dirt(px, o, 0), (o) => dirt(px, o, 1),
    (o) => stone(px, o, 0), (o) => stone(px, o, 1),
    (o) => water(px, o, 0), (o) => water(px, o, 1),
  ];
  draw.forEach((fn, i) => fn(i * TILE));
}
