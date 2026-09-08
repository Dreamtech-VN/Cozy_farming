#!/usr/bin/env node
/**
 * Cắt một tấm ảnh gộp nhiều vật thành từng file rời để SOI bằng mắt.
 *
 * Đây là công cụ kiểm tra: xem bộ cắt có tách đúng không, có vật nào bị dính
 * vào nhau hay bị xé làm đôi không, trước khi đặt tên trong <sheet>.names.json.
 * Khâu đóng gói thật nằm ở tools/import-art.mjs.
 *
 *   node tools/split-sheet.mjs <ảnh.png> <thư mục ra> [--tol 22] [--min 400] [--gap 10]
 */
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';
import { readPng, Pixels } from './art/png.mjs';
import { splitSheet } from './art/split.mjs';

const [src, outDir] = process.argv.slice(2);
if (!src || !outDir) {
  console.error('dùng: node tools/split-sheet.mjs <ảnh.png> <thư mục ra> [--tol N] [--min N] [--gap N]');
  process.exit(1);
}
const arg = (name, fallback) => {
  const i = process.argv.indexOf(`--${name}`);
  return i === -1 ? fallback : Number(process.argv[i + 1]);
};

const img = readPng(readFileSync(src));
const alphaArg = process.argv.indexOf('--alpha');
const pieces = splitSheet(img, {
  tol: arg('tol', 22),
  minArea: arg('min', 400),
  gap: arg('gap', 10),
  alpha: alphaArg === -1 ? null : Number(process.argv[alphaArg + 1]),
  mode: process.argv.includes('--gaps') ? 'gaps' : undefined,
  minRun: arg('run', 4),
  minSize: arg('size', 24),
  trim: arg('trim', 0),
});

mkdirSync(outDir, { recursive: true });
const manifest = pieces.map((piece, n) => {
  const px = new Pixels(piece.w, piece.h);
  px.data.set(piece.data);
  const file = `${String(n).padStart(3, '0')}.png`;
  writeFileSync(join(outDir, file), px.toPng());
  return { index: n, file, w: piece.w, h: piece.h, x: piece.x, y: piece.y };
});
writeFileSync(join(outDir, 'manifest.json'), JSON.stringify(manifest, null, 2) + '\n');
console.log(`${pieces.length} vật → ${outDir}`);
