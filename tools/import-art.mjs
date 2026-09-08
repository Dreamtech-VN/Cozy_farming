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

// Gom theo TRANG: mỗi tấm khai báo `page` trong <tấm>.names.json. Nhét cả 760
// vật vào một trang là ~25 MB, mà đồ nội thất chỉ cần khi vào trong nhà — tách
// trang để client nạp đúng phần map đang dùng.
const pages = new Map();
const seen = new Map();
for (const file of sheets) {
  const maps = JSON.parse(readFileSync(join(SHEETS, file), 'utf8'));
  const page = maps.page ?? 'outdoor';
  const sheet = readPng(readFileSync(join(SHEETS, maps.source)));
  const pieces = splitSheet(sheet, { tol: 22, minArea: 400, gap: 10 });
  let count = 0;
  pieces.forEach((piece, i) => {
    const name = maps.names[String(i)];
    if (!name) return;
    if (seen.has(name)) throw new Error(`tên sprite "${name}" có ở cả ${seen.get(name)} và ${maps.source}`);
    seen.set(name, maps.source);
    if (!pages.has(page)) pages.set(page, []);
    pages.get(page).push({ ...piece, name });
    count++;
  });
  console.log(`${maps.source.padEnd(14)} → ${page.padEnd(8)} ${String(pieces.length).padStart(3)} vật cắt được, ${count} đặt tên`);
}

mkdirSync(OUT, { recursive: true });
const ATLAS_W = 2048;
const index = {};
const pageFiles = {};

for (const [page, items] of [...pages].sort()) {
  // Xếp theo kệ: sắp cao xuống thấp rồi rải thành hàng. Đơn giản mà lãng phí ít,
  // và quan trọng hơn là kết quả ỔN ĐỊNH — cùng đầu vào ra cùng bố cục, nên diff
  // của file atlas đọc được.
  const sorted = [...items].sort((a, b) => b.h - a.h || a.name.localeCompare(b.name));
  let penX = PAD; let penY = PAD; let rowH = 0; let atlasH = 0;
  for (const piece of sorted) {
    if (penX + piece.w + PAD > ATLAS_W) { penX = PAD; penY += rowH + PAD; rowH = 0; }
    piece.ax = penX; piece.ay = penY;
    penX += piece.w + PAD;
    if (piece.h > rowH) rowH = piece.h;
    atlasH = Math.max(atlasH, penY + piece.h + PAD);
  }

  const canvas = new Pixels(ATLAS_W, atlasH);
  for (const piece of sorted) {
    for (let y = 0; y < piece.h; y++) {
      const src = y * piece.w * 4;
      const dst = ((piece.ay + y) * ATLAS_W + piece.ax) * 4;
      canvas.data.set(piece.data.subarray(src, src + piece.w * 4), dst);
    }
  }

  const file = `sprites-${page}.png`;
  const buf = canvas.toPng();
  writeFileSync(join(OUT, file), buf);
  // Ghi luôn dung lượng: client cần biết TỔNG số byte trước khi bắt đầu tải thì
  // thanh tiến độ mới chạy đều, chứ dựa vào Content-Length thì phải gửi xong
  // request đầu mới biết được tổng, làm thanh nhảy giật.
  pageFiles[page] = { file, bytes: buf.length };
  for (const piece of sorted) index[piece.name] = { page, x: piece.ax, y: piece.ay, w: piece.w, h: piece.h };
  console.log(`${file.padEnd(22)} ${ATLAS_W}×${atlasH}  ${(buf.length / 1024 / 1024).toFixed(1)} MB · ${items.length} vật`);
}

const atlasPath = join(OUT, 'atlas.json');
const atlas = JSON.parse(readFileSync(atlasPath, 'utf8'));
atlas.sprites = {
  comment: 'Art vẽ sẵn, đóng gói bằng tools/import-art.mjs từ art-src/sheets/. Neo ĐÁY GIỮA. Mỗi sprite ghi rõ nằm ở trang nào để client nạp đúng trang cần.',
  pages: pageFiles,
  index: Object.fromEntries(Object.entries(index).sort(([a], [b]) => a.localeCompare(b))),
};
writeFileSync(atlasPath, JSON.stringify(atlas, null, 2) + '\n');

console.log(`tổng ${Object.keys(index).length} sprite trong ${Object.keys(pageFiles).length} trang`);
