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
import { downscale } from './art/resize.mjs';
import { stripHead, chinRow, widthAtRow } from './art/head.mjs';


/** Cắt một khung con khỏi tấm gộp, giữ nguyên pixel. */
function cropRegion(img, [x0, y0, w, h]) {
  const out = new Pixels(w, h);
  for (let y = 0; y < h; y++) {
    const src = ((y0 + y) * img.width + x0) * 4;
    out.data.set(img.data.subarray(src, src + w * 4), y * w * 4);
  }
  return { width: w, height: h, data: out.data };
}

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
  // Nhãn dán trên tấm ("Nam", "Nữ", tên từng ô) nằm lẫn trong khung cần cắt.
  // Bôi trắng trước: trắng trơn thì phép thử nền coi là nền, khỏi phải né bằng
  // cách thu hẹp khung rồi cắt cụt mất hình.
  for (const [bx, by, bw, bh] of maps.blank ?? []) {
    for (let y = by; y < by + bh; y++) {
      for (let x = bx; x < bx + bw; x++) {
        const i = (y * sheet.width + x) * 4;
        sheet.data[i] = 255; sheet.data[i + 1] = 255; sheet.data[i + 2] = 255; sheet.data[i + 3] = 255;
      }
    }
  }
  // Tấm bảng thành phần chia sẵn thành nhiều KHUNG, mỗi khung một kiểu bày và
  // một nhãn vẽ chết ở góc. Cắt cả tấm một lần là nhãn cũng thành sprite, còn
  // tham số hợp với khung tóc thì hỏng ở khung mặt. Nên cắt theo từng khung.
  const areas = maps.regions ?? [{ rect: null, split: maps.split, names: maps.names }];
  let count = 0;
  let cut = 0;
  for (const area of areas) {
    // Mỗi tấm bày một kiểu nên tự khai tham số cắt trong <tấm>.names.json; giữ
    // cạnh nhau với danh sách tên để sửa tham số là thấy ngay ảnh hưởng tới tên nào.
    const img = area.rect ? cropRegion(sheet, area.rect) : sheet;
    const pieces = splitSheet(img, { tol: 22, minArea: 400, gap: 10, ...(area.split ?? {}) });
    cut += pieces.length;
    const maxHeight = area.split?.maxHeight ?? 0;
    pieces.forEach((raw, i) => {
      const name = area.names[String(i)];
      if (!name) return;
      const piece = maxHeight && raw.h > maxHeight ? { ...raw, ...downscale(raw, raw.h / maxHeight) } : raw;
      // Mảnh tóc là cả cái đầu đội tóc; khoét mặt đi mới chồng được lên khuôn
      // mặt tự chọn, và khung lỗ khoét được chính là mốc căn.
      const hole = area.strip === 'head' ? stripHead(piece) : null;
      // Mảnh mặt có sẵn khúc cổ: ghi lại dòng cằm để chỗ ghép biết đặt tóc.
      const chin = area.measure === 'chin' ? chinRow(piece) : null;
      // Bề ngang khúc cổ: mốc quy tỉ lệ giữa mảnh mặt và mảnh thân. Mảnh mặt
      // đo ở giữa khúc cổ (dưới cằm), mảnh thân đo ở dòng thứ tư tính từ mép
      // trên — mép trên chính là đỉnh khúc cổ nhô lên giữa hai vai.
      const neck = area.measure === 'chin' ? widthAtRow(piece, (chin ?? piece.h - 1) + (piece.h - (chin ?? piece.h - 1)) * 0.5)
        : area.measure === 'neck' ? widthAtRow(piece, 4) : null;
      if (seen.has(name)) throw new Error(`tên sprite "${name}" có ở cả ${seen.get(name)} và ${maps.source}`);
      seen.set(name, maps.source);
      if (!pages.has(page)) pages.set(page, []);
      pages.get(page).push({ ...piece, name, hole, chin, neck });
      count++;
    });
  }
  console.log(`${maps.source.padEnd(14)} → ${page.padEnd(8)} ${String(cut).padStart(3)} vật cắt được, ${count} đặt tên`);
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
  for (const piece of sorted) {
    index[piece.name] = { page, x: piece.ax, y: piece.ay, w: piece.w, h: piece.h };
    if (piece.hole) index[piece.name].hole = piece.hole;
    if (piece.chin != null) index[piece.name].chin = piece.chin;
    if (piece.neck != null) index[piece.name].neck = piece.neck;
  }
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
