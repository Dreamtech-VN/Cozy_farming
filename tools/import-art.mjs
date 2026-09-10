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
import { makeTile, wrapSeam, patchArea } from './art/tileset.mjs';
import { chinRow, collarSlot, headCap, pocketPiece, skinTone, dropHairlines, chainLimb, cuffSlot } from './art/head.mjs';


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
  // Vá tranh nền TRƯỚC khi cắt: mấy khung nét đứt trắng là ghi chú chừa chỗ
  // đặt công trình, không phải hình.
  for (const [rect, from] of maps.patch ?? []) patchArea(sheet, rect, from);

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
      // `scale` thu nhỏ CÙNG MỘT tỉ lệ cho mọi mảnh của bộ art, khác `maxHeight`
      // là quy mỗi mảnh về một chiều cao. Bộ nhân vật phải dùng `scale`: các
      // mảnh ghép vào nhau nên chúng phải giữ nguyên tương quan cỡ với nhau,
      // quy về cùng chiều cao là cái đầu to bằng cả bộ quần áo.
      const factor = area.split?.scale ?? 0;
      // Tranh nền lát ngang suốt bề rộng map nên hai mép phải nối liền được:
      // khâu như khâu tile, hoà mấy cột cuối vào mấy cột đầu rồi cắt bỏ chúng.
      if (area.split?.mode === 'whole' && maps.seam) {
        const sewn = wrapSeam({ w: raw.w, h: raw.h, data: raw.data }, 'x', maps.seam);
        raw.w = sewn.w; raw.data = sewn.data;
      }
      const piece = factor > 1 ? { ...raw, ...downscale(raw, factor) }
        : maxHeight && raw.h > maxHeight ? { ...raw, ...downscale(raw, raw.h / maxHeight) } : raw;
      // Mảnh đầu nam có sẵn khúc cổ nối xuống, nên đáy mảnh là hết cổ chứ không
      // phải cằm: ghi lại dòng cằm để chỗ ghép biết đặt đôi mắt ở đâu.
      const chin = area.measure === 'cap' ? chinRow(piece) : null;
      // Mốc của bộ nhân vật mới. Đo từ chính hình chứ không chép tay, để thêm
      // kiểu tóc hay bộ đồ mới là ghép đúng ngay, không phải dò lại số.
      // Nét mồ côi phải xoá TRƯỚC khi đo mốc: một sợi thả xuống tận gấu váy
      // kéo khung bao rộng ra, mà khung bao là mốc căn đầu với thân.
      if (area.measure === 'collar') dropHairlines(piece);
      const extra = {};
      // `cuff: false` trong <tấm>.names.json: khai thẳng là bộ này KHÔNG có ống
      // tay dài tới cổ tay, đừng dò. Dò tự động đúng 9/10 bộ, bộ còn lại có cái
      // túi đeo chéo mà đáy túi tụt vào đúng ngang hông y như cổ tay — chuyện
      // riêng của một bức tranh thì khai ở cạnh bức tranh, đừng nống thuật toán
      // ra cho vừa nó rồi làm hỏng chín bộ kia.
      if (area.measure === 'collar') {
        Object.assign(extra, collarSlot(piece));
        if (area.cuff !== false) Object.assign(extra, cuffSlot(piece));
      }
      if (area.measure === 'cap') Object.assign(extra, headCap(piece));
      if (area.measure === 'cap' && name.startsWith('head_')) Object.assign(extra, skinTone(piece));
      if (seen.has(name)) throw new Error(`tên sprite "${name}" có ở cả ${seen.get(name)} và ${maps.source}`);
      seen.set(name, maps.source);
      if (!pages.has(page)) pages.set(page, []);
      pages.get(page).push({ ...piece, name, chin, ...extra });
      count++;
      // Tay chân trần trên mảnh trang phục chỉ có nét viền, ruột là nền. Tách
      // ruột ấy ra một mảnh TRẮNG cùng cỡ, vẽ lót bên dưới rồi nhân với tông da
      // người chơi chọn — nhờ vậy một bộ đồ hợp với cả năm tông, khỏi phải nhập
      // năm bản.
      if (area.measure === 'collar') {
        const raw_limbs = raw.pocket ? pocketPiece(raw.pocket, raw.w, raw.h) : null;
        const limbs = raw_limbs && factor > 1 ? { ...raw_limbs, ...downscale(raw_limbs, factor) } : raw_limbs;
        if (limbs) {
          const limbName = `${name}_limbs`;
          if (seen.has(limbName)) throw new Error(`tên sprite "${limbName}" trùng`);
          seen.set(limbName, maps.source);
          pages.get(page).push({ ...limbs, name: limbName, chin: null });
          count++;
        }
      }
    });
  }
  // NỐI CHI: tấm sườn cơ thể bày từng khúc rời, nhưng game chỉ cần cả cánh tay.
  // Nối ngay ở khâu nhập chứ không nối lúc vẽ: chỗ nối đo trên hình, đo một lần
  // rồi thôi, mà atlas cũng đỡ ba mảnh vụn cho mỗi cánh tay.
  for (const job of maps.compose ?? []) {
    const bucket = pages.get(page) ?? [];
    const parts = job.chain.map((n) => bucket.find((piece) => piece.name === n));
    if (parts.some((piece) => !piece)) throw new Error(`nối "${job.name}": thiếu khúc ${job.chain.join(', ')}`);
    const limb = chainLimb(parts, { overlap: job.overlap ?? 4 });
    if (seen.has(job.name)) throw new Error(`tên sprite "${job.name}" trùng`);
    seen.set(job.name, maps.source);
    // Khúc rời chỉ là nguyên liệu, không vào atlas.
    for (const part of parts) {
      bucket.splice(bucket.indexOf(part), 1);
      seen.delete(part.name);
      count--;
    }
    bucket.push({ ...limb, name: job.name, chin: null, ...skinTone(limb) });
    count++;
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
    if (piece.chin != null) index[piece.name].chin = piece.chin;
    if (piece.collar) index[piece.name].collar = piece.collar;
    if (piece.cap) index[piece.name].cap = piece.cap;
    if (piece.tone) index[piece.name].tone = piece.tone;
    if (piece.socket) index[piece.name].socket = piece.socket;
    if (piece.cuff) index[piece.name].cuff = piece.cuff;
  }
  console.log(`${file.padEnd(22)} ${ATLAS_W}×${atlasH}  ${(buf.length / 1024 / 1024).toFixed(1)} MB · ${items.length} vật`);
}

const atlasPath = join(OUT, 'atlas.json');
const atlas = JSON.parse(readFileSync(atlasPath, 'utf8'));

// TILESET vẽ sẵn, đè lên bộ sinh bằng code.
//
// Cùng một nguyên tắc với sprite: có art vẽ sẵn thì dùng art, chưa có thì vẫn
// chạy bằng art sinh bằng code. Giữ NGUYÊN tên và thứ tự ô của bộ cũ — world.js
// gọi tile theo CHỈ SỐ, đổi thứ tự là mặt đất hoá ra mặt nước.
const TILES = join(ROOT, 'art-src', 'tiles');
if (existsSync(join(TILES, 'tiles.json'))) {
  const cfg = JSON.parse(readFileSync(join(TILES, 'tiles.json'), 'utf8'));
  const names = Object.keys(cfg.tiles);
  const old = atlas.tiles?.names ?? [];
  // Bộ mới phải bắt đầu bằng ĐÚNG danh sách cũ, ô mới chỉ được nối thêm vào
  // cuối: atlas đã phát ra ngoài ghi tile theo chỉ số, chèn vào giữa là mặt đất
  // của người chơi cũ hoá ra mặt nước.
  if (old.some((n, i) => n !== names[i])) {
    throw new Error(`tileset vẽ sẵn chỉ được NỐI THÊM vào cuối, không được đổi thứ tự:\n  cũ: ${old.join(', ')}\n  mới: ${names.join(', ')}`);
  }
  const sheets = new Map();
  const size = cfg.size;
  const strip = new Pixels(names.length * size, size);
  names.forEach((name, i) => {
    const spec = { blend: cfg.blend, ...cfg.tiles[name] };
    if (!sheets.has(spec.source)) sheets.set(spec.source, readPng(readFileSync(join(TILES, spec.source))));
    const tile = makeTile(sheets.get(spec.source), spec, size);
    for (let y = 0; y < size; y++) {
      const src = y * size * 4;
      strip.data.set(tile.data.subarray(src, src + size * 4), (y * strip.width + i * size) * 4);
    }
  });
  const buf = strip.toPng();
  writeFileSync(join(OUT, 'tiles.png'), buf);
  atlas.tiles = { file: 'tiles.png', size, names };
  console.log(`tiles.png            ${strip.width}×${size}  ${(buf.length / 1024).toFixed(0)} KB · ${names.length} ô`);
}
atlas.sprites = {
  comment: 'Art vẽ sẵn, đóng gói bằng tools/import-art.mjs từ art-src/sheets/. Neo ĐÁY GIỮA. Mỗi sprite ghi rõ nằm ở trang nào để client nạp đúng trang cần.',
  pages: pageFiles,
  index: Object.fromEntries(Object.entries(index).sort(([a], [b]) => a.localeCompare(b))),
};
writeFileSync(atlasPath, JSON.stringify(atlas, null, 2) + '\n');

console.log(`tổng ${Object.keys(index).length} sprite trong ${Object.keys(pageFiles).length} trang`);
