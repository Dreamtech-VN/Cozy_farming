/**
 * Cây trồng: mỗi loại một hàng, mỗi giai đoạn một cột.
 *
 * Màu lấy THẲNG từ palette trong data/content/crops.json, nên thêm một cây mới
 * vào content là có sprite ngay, không phải vẽ tay thêm gì.
 */
import { P } from './palette.mjs';

export const CROP_CELL = 32;
export const CROP_STAGES = 4;

const hex = (s) => [parseInt(s.slice(1, 3), 16), parseInt(s.slice(3, 5), 16), parseInt(s.slice(5, 7), 16), 255];
const mix = (c, t, k) => [
  Math.round(c[0] + (t[0] - c[0]) * k),
  Math.round(c[1] + (t[1] - c[1]) * k),
  Math.round(c[2] + (t[2] - c[2]) * k), 255,
];
const WHITE = [255, 255, 255, 255];
const BLACK = [0, 0, 0, 255];

function stage(px, ox, oy, colours, index) {
  const cx = ox + CROP_CELL / 2;
  const base = oy + CROP_CELL - 4;

  // Luống đất có ở mọi giai đoạn để ô đất không bị trống trơn.
  px.ellipse(cx, base, 11, 4, P.dirtDark);
  px.ellipse(cx, base - 1, 10, 3, P.dirt);
  if (index === 0) { px.rect(cx - 1, base - 5, 2, 4, colours.leaf); px.set(cx, base - 6, colours.leafLight); return; }

  const h = 4 + index * 5;
  px.rect(cx - 1, base - h, 2, h, colours.leafDark);
  const spread = 3 + index * 2;
  px.ellipse(cx - spread, base - h + 2, spread, 3, colours.leaf);
  px.ellipse(cx + spread, base - h + 2, spread, 3, colours.leaf);
  px.ellipse(cx, base - h - 1, spread, 3, colours.leafLight);

  // Chỉ giai đoạn cuối mới có quả: nhìn là biết ngay ô nào thu hoạch được.
  if (index === CROP_STAGES - 1) {
    px.ellipse(cx, base - h - 4, 5, 5, colours.fruit);
    px.ellipse(cx + 2, base - h - 2, 3, 3, colours.fruitDark);
    px.set(cx - 2, base - h - 6, colours.fruitLight);
  }
}

/** @param crops mảng { crop_id, palette: [màu quả, màu lá] } đọc từ content. */
export function drawCrops(px, crops) {
  crops.forEach((crop, row) => {
    const fruit = hex(crop.palette[0]);
    const leaf = hex(crop.palette[1]);
    const colours = {
      fruit,
      fruitLight: mix(fruit, WHITE, 0.45),
      fruitDark: mix(fruit, BLACK, 0.3),
      leaf,
      leafLight: mix(leaf, WHITE, 0.3),
      leafDark: mix(leaf, BLACK, 0.3),
    };
    for (let s = 0; s < CROP_STAGES; s++) stage(px, s * CROP_CELL, row * CROP_CELL, colours, s);
  });
}
