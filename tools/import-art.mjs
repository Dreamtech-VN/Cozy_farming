#!/usr/bin/env node
/**
 * Nhập art vẽ sẵn: cắt các tấm ảnh gộp trong art-src/sheets/ thành từng vật rồi
 * đóng lại thành một trang atlas cho client.
 *
 * Khác `gen-art.mjs` (sinh art bằng code), lệnh này KHÔNG sinh gì cả — nó chỉ
 * đóng gói ảnh có sẵn. Hai đường tồn tại song song: vật nào đã có art vẽ sẵn
 * thì dùng art đó, chưa có thì vẫn dùng art sinh bằng code.
 *
 *   npm run import-art
 */
import { readFileSync, writeFileSync, mkdirSync, existsSync, readdirSync } from 'node:fs';
import { join } from 'node:path';
import { readPng, Pixels } from './art/png.mjs';
import { splitSheet } from './art/split.mjs';

const ROOT = process.cwd();
const SHEETS = join(ROOT, 'art-src', 'sheets');
const OUT = join(ROOT, 'client', 'assets', 'world');
const PAD = 2; // đệm quanh mỗi ô, tránh lem pixel của ô bên cạnh khi phóng to

if (!existsSync(SHEETS)) {
  console.log('chưa có art-src/sheets/ — bỏ qua bước nhập art');
  process.exit(0);
}

// Gom mọi tấm trong art-src/sheets/ vào CÙNG một trang atlas: tên sprite là một
// không gian tên chung, nên trùng tên giữa hai tấm phải chết ngay ở đây chứ
// không để một cái đè lên cái kia lúc chạy.
const sheets = readdirSync(SHEETS).filter((f) => f.endsWith('.names.json')).sort();
if (!sheets.length) {
  console.log('không có tấm nào trong art-src/sheets/ — bỏ qua');
  process.exit(0);
}

const named = [];
const seen = new Map();
for (const file of sheets) {
  const maps = JSON.parse(readFileSync(join(SHEETS, file), 'utf8'));
  const sheet = readPng(readFileSync(join(SHEETS, maps.source)));
  const pieces = splitSheet(sheet, { tol: 22, minArea: 400, gap: 10 });
  let count = 0;
  pieces.forEach((piece, i) => {
    const name = maps.names[String(i)];
    if (!name) return;
    if (seen.has(name)) {
      throw new Error(`tên sprite "${name}" có ở cả ${seen.get(name)} và ${maps.source}`);
    }
    seen.set(name, maps.source);
    named.push({ ...piece, name });
    count++;
  });
  console.log(`${maps.source.padEnd(14)} ${String(pieces.length).padStart(3)} vật cắt được → ${count} đặt tên`);
}

// Xếp theo kệ: sắp cao xuống thấp rồi rải thành từng hàng. Đơn giản mà lãng phí
// ít, và quan trọng hơn là kết quả ỔN ĐỊNH — cùng đầu vào ra cùng bố cục, nên
// diff của file atlas đọc được.
const sorted = [...named].sort((a, b) => b.h - a.h || a.name.localeCompare(b.name));
const ATLAS_W = 2048;
let penX = PAD; let penY = PAD; let rowH = 0; let atlasH = 0;
for (const piece of sorted) {
  if (penX + piece.w + PAD > ATLAS_W) { penX = PAD; penY += rowH + PAD; rowH = 0; }
  piece.ax = penX; piece.ay = penY;
  penX += piece.w + PAD;
  if (piece.h > rowH) rowH = piece.h;
  atlasH = Math.max(atlasH, penY + piece.h + PAD);
}

const page = new Pixels(ATLAS_W, atlasH);
for (const piece of sorted) {
  for (let y = 0; y < piece.h; y++) {
    const src = y * piece.w * 4;
    const dst = ((piece.ay + y) * ATLAS_W + piece.ax) * 4;
    page.data.set(piece.data.subarray(src, src + piece.w * 4), dst);
  }
}

mkdirSync(OUT, { recursive: true });
const png = page.toPng();
writeFileSync(join(OUT, 'sprites.png'), png);

const atlasPath = join(OUT, 'atlas.json');
const atlas = JSON.parse(readFileSync(atlasPath, 'utf8'));
atlas.sprites = {
  file: 'sprites.png',
  comment: 'Art vẽ sẵn, đóng gói bằng tools/import-art.mjs từ art-src/sheets/. Mỗi vật một khung riêng, neo ĐÁY GIỮA.',
  sprites: Object.fromEntries(
    [...sorted].sort((a, b) => a.name.localeCompare(b.name))
      .map((p) => [p.name, { x: p.ax, y: p.ay, w: p.w, h: p.h }]),
  ),
};
writeFileSync(atlasPath, JSON.stringify(atlas, null, 2) + '\n');

console.log(`sprites.png  ${ATLAS_W}×${atlasH}  ${(png.length / 1024).toFixed(0)} KB · ${named.length} vật`);
