/**
 * Sprite cho vật thể trong cảnh. Mỗi sprite nằm gọn trong một ô của sheet, gốc
 * neo ở ĐÁY GIỮA vì mọi thứ trong game side-view đều đứng trên mặt đất.
 *
 * Ưu tiên bóng dáng đọc được: ở cỡ thật cây phải ra cây ngay cả khi mất hết chi
 * tiết, nên tán lá làm khối lớn rồi mới khoét, không vẽ từng lá.
 */
import { P } from './palette.mjs';

export const CELL = 64;
export const PROP_NAMES = [
  'tree_big', 'tree_small', 'bush', 'rock', 'flowers',
  'fence', 'crate', 'barrel', 'well', 'sign',
  'house', 'stall', 'lamp', 'haystack', 'stump',
  'soil', 'fountain', 'arcade', 'board', 'chest',
  'grass_tall', 'leaf_branch', 'reed', 'log', 'mushroom',
];
export const PROP_COLS = 5;

const shadow = (px, ox, oy, w) => px.ellipse(ox + CELL / 2, oy + CELL - 3, w, 3, P.shadow);

function tree(px, ox, oy, scale) {
  const cx = ox + CELL / 2;
  const base = oy + CELL - 4;
  shadow(px, ox, oy, 13 * scale);
  const trunkH = Math.round(18 * scale);
  const trunkW = Math.round(7 * scale);
  px.rect(cx - Math.floor(trunkW / 2), base - trunkH, trunkW, trunkH, P.wood);
  px.rect(cx - Math.floor(trunkW / 2), base - trunkH, 2, trunkH, P.woodLight);
  px.rect(cx + Math.ceil(trunkW / 2) - 2, base - trunkH, 2, trunkH, P.woodDark);

  // Tán: ba khối chồng nhau tạo bóng dáng gồ ghề, không phải một quả cầu trơn.
  const top = base - trunkH;
  const r = 15 * scale;
  px.ellipse(cx, top - r * 0.7, r, r * 0.85, P.leaf);
  px.ellipse(cx - r * 0.65, top - r * 0.25, r * 0.7, r * 0.6, P.leaf);
  px.ellipse(cx + r * 0.65, top - r * 0.3, r * 0.7, r * 0.6, P.leaf);
  px.ellipse(cx - r * 0.3, top - r * 1.05, r * 0.55, r * 0.5, P.leafLight);
  px.ellipse(cx + r * 0.5, top - r * 0.05, r * 0.45, r * 0.4, P.leafDark);
}

function bush(px, ox, oy) {
  const cx = ox + CELL / 2;
  const base = oy + CELL - 5;
  shadow(px, ox, oy, 11);
  px.ellipse(cx, base - 7, 13, 8, P.leaf);
  px.ellipse(cx - 8, base - 4, 8, 6, P.leafDark);
  px.ellipse(cx + 7, base - 5, 8, 6, P.leaf);
  px.ellipse(cx - 2, base - 11, 7, 5, P.leafLight);
}

function rock(px, ox, oy) {
  const cx = ox + CELL / 2;
  const base = oy + CELL - 5;
  shadow(px, ox, oy, 10);
  px.ellipse(cx, base - 6, 12, 8, P.stone);
  px.ellipse(cx - 3, base - 9, 7, 5, P.stoneLight);
  px.ellipse(cx + 6, base - 3, 6, 4, P.stoneDark);
}

function flowers(px, ox, oy) {
  const base = oy + CELL - 6;
  const colours = [P.flowerA, P.flowerB, P.flowerC];
  for (let i = 0; i < 5; i++) {
    const x = ox + 18 + i * 7;
    const h = 6 + (i % 3) * 2;
    px.rect(x, base - h, 1, h, P.leafDark);
    px.rect(x - 1, base - h - 2, 3, 2, colours[i % 3]);
    px.set(x, base - h - 1, P.flowerB);
  }
}

function fence(px, ox, oy) {
  const base = oy + CELL - 6;
  for (const x of [ox + 14, ox + 32, ox + 50]) {
    px.rect(x, base - 20, 4, 20, P.wood);
    px.rect(x, base - 20, 1, 20, P.woodLight);
  }
  px.rect(ox + 12, base - 17, 42, 3, P.wood);
  px.rect(ox + 12, base - 10, 42, 3, P.wood);
  px.rect(ox + 12, base - 17, 42, 1, P.woodLight);
}

function crate(px, ox, oy) {
  const x = ox + 18; const y = oy + CELL - 26;
  shadow(px, ox, oy, 13);
  px.rect(x, y, 28, 22, P.wood);
  px.rect(x, y, 28, 2, P.woodLight);
  px.rect(x, y + 20, 28, 2, P.woodDark);
  px.rect(x, y, 2, 22, P.woodLight);
  px.rect(x + 26, y, 2, 22, P.woodDark);
  // Nẹp chéo cho ra thùng gỗ chứ không phải khối vuông trơn.
  for (let i = 0; i < 22; i++) px.set(x + 3 + i, y + 1 + i, P.woodDark);
}

function barrel(px, ox, oy) {
  const x = ox + 22; const y = oy + CELL - 28;
  shadow(px, ox, oy, 11);
  px.rect(x, y, 20, 24, P.wood);
  px.rect(x + 1, y, 2, 24, P.woodLight);
  px.rect(x + 17, y, 2, 24, P.woodDark);
  px.rect(x - 1, y + 4, 22, 3, P.stoneDark);
  px.rect(x - 1, y + 16, 22, 3, P.stoneDark);
  px.ellipse(x + 10, y + 1, 10, 3, P.woodLight);
}

function well(px, ox, oy) {
  const cx = ox + CELL / 2; const base = oy + CELL - 5;
  shadow(px, ox, oy, 16);
  px.rect(cx - 14, base - 16, 28, 16, P.stone);
  px.rect(cx - 14, base - 16, 28, 2, P.stoneLight);
  px.rect(cx - 14, base - 3, 28, 3, P.stoneDark);
  px.ellipse(cx, base - 16, 13, 4, P.stoneDark);
  px.rect(cx - 12, base - 34, 3, 18, P.wood);
  px.rect(cx + 9, base - 34, 3, 18, P.wood);
  // Mái dốc hai bên, xếp từng bậc pixel thay vì một tam giác trơn.
  for (let i = 0; i < 9; i++) px.rect(cx - 16 + i, base - 34 - i, 32 - i * 2, 2, i < 3 ? P.roofLight : P.roof);
}

function sign(px, ox, oy) {
  const cx = ox + CELL / 2; const base = oy + CELL - 6;
  shadow(px, ox, oy, 8);
  px.rect(cx - 2, base - 18, 4, 18, P.woodDark);
  px.rect(cx - 14, base - 30, 28, 14, P.wood);
  px.rect(cx - 14, base - 30, 28, 2, P.woodLight);
  px.rect(cx - 14, base - 18, 28, 2, P.woodDark);
  px.rect(cx - 10, base - 26, 20, 2, P.woodDark);
  px.rect(cx - 10, base - 22, 13, 2, P.woodDark);
}

function house(px, ox, oy) {
  const cx = ox + CELL / 2; const base = oy + CELL - 3;
  shadow(px, ox, oy, 22);
  px.rect(cx - 20, base - 26, 40, 26, P.wall);
  px.rect(cx - 20, base - 26, 40, 2, P.wallLight);
  px.rect(cx - 20, base - 3, 40, 3, P.wallDark);
  for (let i = 0; i < 14; i++) px.rect(cx - 24 + i * 2, base - 28 - i * 2, 48 - i * 4, 2, i < 4 ? P.roofLight : P.roof);
  px.rect(cx - 24, base - 28, 48, 2, P.roofDark);
  px.rect(cx - 6, base - 16, 12, 16, P.woodDark);   // cửa
  px.rect(cx - 6, base - 16, 12, 2, P.wood);
  px.rect(cx + 9, base - 22, 9, 9, P.waterLight);   // cửa sổ
  px.rect(cx + 9, base - 22, 9, 1, P.wallLight);
}

function stall(px, ox, oy) {
  const cx = ox + CELL / 2; const base = oy + CELL - 3;
  shadow(px, ox, oy, 22);
  px.rect(cx - 20, base - 18, 40, 18, P.wood);
  px.rect(cx - 20, base - 18, 40, 2, P.woodLight);
  px.rect(cx - 22, base - 34, 44, 4, P.woodDark);
  // Mái sọc đỏ trắng — dấu hiệu đọc ra "cửa hàng" ngay từ xa.
  for (let i = 0; i < 22; i++) {
    px.rect(cx - 22 + i * 2, base - 32, 2, 12, (i % 2 === 0) ? P.roof : P.wallLight);
  }
  px.rect(cx - 18, base - 34, 3, 34, P.wood);
  px.rect(cx + 15, base - 34, 3, 34, P.wood);
}

function lamp(px, ox, oy) {
  const cx = ox + CELL / 2; const base = oy + CELL - 5;
  shadow(px, ox, oy, 7);
  px.rect(cx - 2, base - 34, 4, 34, P.stoneDark);
  px.rect(cx - 2, base - 34, 1, 34, P.stone);
  px.rect(cx - 6, base - 44, 12, 10, P.cropLight);
  px.rect(cx - 6, base - 44, 12, 2, P.wallLight);
  px.rect(cx - 7, base - 46, 14, 3, P.stoneDark);
}

function haystack(px, ox, oy) {
  const cx = ox + CELL / 2; const base = oy + CELL - 4;
  shadow(px, ox, oy, 15);
  px.ellipse(cx, base - 10, 17, 11, P.crop);
  px.ellipse(cx - 4, base - 14, 11, 7, P.cropLight);
  px.ellipse(cx + 8, base - 6, 8, 5, P.cropDark);
}

function stump(px, ox, oy) {
  const cx = ox + CELL / 2; const base = oy + CELL - 4;
  shadow(px, ox, oy, 10);
  px.rect(cx - 9, base - 12, 18, 12, P.woodDark);
  px.ellipse(cx, base - 12, 9, 4, P.wood);
  px.ellipse(cx, base - 12, 4, 2, P.woodLight);
}

/** Luống đất trống, dùng cho ô nông trại chưa gieo. */
function soil(px, ox, oy) {
  const cx = ox + CELL / 2; const base = oy + CELL - 6;
  px.ellipse(cx, base + 2, 20, 6, P.dirtDark);
  px.ellipse(cx, base, 19, 5, P.dirt);
  for (let i = 0; i < 6; i++) px.set(cx - 12 + i * 5, base - 1, P.dirtDark);
}

function fountain(px, ox, oy) {
  const cx = ox + CELL / 2; const base = oy + CELL - 4;
  shadow(px, ox, oy, 20);
  px.ellipse(cx, base - 4, 22, 7, P.stoneDark);
  px.ellipse(cx, base - 6, 20, 6, P.stone);
  px.ellipse(cx, base - 7, 15, 4, P.water);
  px.rect(cx - 3, base - 22, 6, 16, P.stoneLight);
  px.ellipse(cx, base - 24, 8, 4, P.stone);
  // Tia nước bắn lên hai bên, cho ra đài phun chứ không phải bệ đá.
  for (let i = 0; i < 7; i++) {
    px.set(cx - 5 - i, base - 24 + Math.round(i * i * 0.18), P.waterLight);
    px.set(cx + 5 + i, base - 24 + Math.round(i * i * 0.18), P.waterLight);
  }
}

function arcade(px, ox, oy) {
  const cx = ox + CELL / 2; const base = oy + CELL - 4;
  shadow(px, ox, oy, 14);
  px.rect(cx - 13, base - 34, 26, 34, P.roofDark);
  px.rect(cx - 13, base - 34, 26, 2, P.roof);
  px.rect(cx - 10, base - 30, 20, 14, P.waterDark);
  px.rect(cx - 9, base - 29, 18, 12, P.waterLight);
  px.rect(cx - 8, base - 13, 16, 4, P.stoneDark);
  px.ellipse(cx - 4, base - 11, 2, 2, P.cropLight);
  px.ellipse(cx + 3, base - 11, 2, 2, P.flowerA);
}

function board(px, ox, oy) {
  const cx = ox + CELL / 2; const base = oy + CELL - 5;
  shadow(px, ox, oy, 12);
  px.rect(cx - 12, base - 16, 4, 16, P.woodDark);
  px.rect(cx + 8, base - 16, 4, 16, P.woodDark);
  px.rect(cx - 17, base - 36, 34, 22, P.wood);
  px.rect(cx - 17, base - 36, 34, 2, P.woodLight);
  px.rect(cx - 14, base - 32, 28, 14, P.wallLight);
  for (let i = 0; i < 3; i++) px.rect(cx - 11, base - 29 + i * 4, 22 - i * 5, 2, P.dirtDark);
}

function chest(px, ox, oy) {
  const cx = ox + CELL / 2; const base = oy + CELL - 5;
  shadow(px, ox, oy, 14);
  px.rect(cx - 15, base - 16, 30, 16, P.wood);
  px.rect(cx - 15, base - 4, 30, 4, P.woodDark);
  for (let i = 0; i < 8; i++) px.rect(cx - 15 + i, base - 24 + Math.abs(i - 7), 2, 8, P.woodLight);
  px.rect(cx - 15, base - 22, 30, 8, P.woodLight);
  px.rect(cx - 15, base - 15, 30, 2, P.woodDark);
  px.rect(cx - 3, base - 20, 6, 9, P.cropLight);
}

/* --- Lớp tiền cảnh: vật lướt qua sát camera, chỉ là bóng dáng nên vẽ đậm và
   đơn giản, chi tiết sẽ bị làm mờ hết khi vẽ. --- */
function grassTall(px, ox, oy) {
  const base = oy + CELL;
  for (let i = 0; i < 9; i++) {
    const x = ox + 6 + i * 6;
    const h = 26 + ((i * 7) % 18);
    const lean = ((i % 3) - 1) * 4;
    for (let y = 0; y < h; y++) {
      px.set(x + Math.round((lean * y) / h), base - y, i % 2 ? P.leafDark : P.leaf);
      px.set(x + 1 + Math.round((lean * y) / h), base - y, P.leafDark);
    }
  }
}

function leafBranch(px, ox, oy) {
  const y = oy + 8;
  px.rect(ox, y, CELL - 6, 4, P.woodDark);
  for (let i = 0; i < 6; i++) {
    const x = ox + 6 + i * 9;
    px.ellipse(x, y + 10, 7, 5, i % 2 ? P.leaf : P.leafDark);
    px.ellipse(x + 4, y + 2, 6, 4, P.leafDark);
  }
}

function reed(px, ox, oy) {
  const base = oy + CELL;
  for (let i = 0; i < 5; i++) {
    const x = ox + 12 + i * 9;
    const h = 34 + ((i * 11) % 14);
    px.rect(x, base - h, 2, h, P.leafDark);
    px.ellipse(x + 1, base - h - 3, 3, 6, P.woodDark);
  }
}

function log(px, ox, oy) {
  const base = oy + CELL - 6;
  px.rect(ox + 4, base - 14, CELL - 8, 14, P.wood);
  px.rect(ox + 4, base - 14, CELL - 8, 3, P.woodLight);
  px.rect(ox + 4, base - 3, CELL - 8, 3, P.woodDark);
  px.ellipse(ox + 6, base - 7, 4, 7, P.woodDark);
  px.ellipse(ox + 6, base - 7, 2, 3, P.woodLight);
}

function mushroom(px, ox, oy) {
  const base = oy + CELL - 6;
  for (const [dx, scale] of [[-8, 1], [8, 0.75]]) {
    const cx = ox + CELL / 2 + dx;
    px.rect(cx - 2, base - 8 * scale, 4, 8 * scale, P.wallLight);
    px.ellipse(cx, base - 9 * scale, 8 * scale, 5 * scale, P.roof);
    px.ellipse(cx - 2, base - 10 * scale, 2, 1.5, P.wallLight);
  }
}

export function drawProps(px) {
  const draw = [tree, (p, x, y) => tree(p, x, y, 0.7), bush, rock, flowers,
    fence, crate, barrel, well, sign,
    house, stall, lamp, haystack, stump,
    soil, fountain, arcade, board, chest,
    grassTall, leafBranch, reed, log, mushroom];
  draw.forEach((fn, i) => {
    const ox = (i % 5) * CELL;
    const oy = Math.floor(i / 5) * CELL;
    if (fn === tree) tree(px, ox, oy, 1);
    else fn(px, ox, oy);
  });
}
