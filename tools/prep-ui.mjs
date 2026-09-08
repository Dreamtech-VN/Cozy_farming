#!/usr/bin/env node
/**
 * Chuẩn bị ảnh nền cho các màn ngoài game (đăng nhập, đăng ký, chờ tải).
 *
 * Khác sprite: đây là ảnh nền toàn màn hình, và nó phải hiện ra TRƯỚC màn chờ
 * tải tài nguyên — người chơi nhìn nó ngay giây đầu. Nên thu nhỏ mạnh tay: nền
 * bị phủ mờ và bị giao diện che một phần, chi tiết cỡ gốc là phí băng thông ở
 * đúng lúc không được phép chậm.
 *
 *   npm run prep-ui
 */
import { readFileSync, writeFileSync, mkdirSync, readdirSync, existsSync } from 'node:fs';
import { join } from 'node:path';
import { readPng, Pixels, toIndexedPng } from './art/png.mjs';
import { downscale } from './art/resize.mjs';

const SRC = join(process.cwd(), 'art-src', 'ui');
const OUT = join(process.cwd(), 'client', 'assets', 'ui');
const MAX_W = 1440;

if (!existsSync(SRC)) { console.log('chưa có art-src/ui/ — bỏ qua'); process.exit(0); }
mkdirSync(OUT, { recursive: true });

// Tên bắt đầu bằng `_` là tranh giữ lại tham khảo, KHÔNG đóng gói: mỗi tranh nền
// là nửa MB tải về trước cả màn chờ, không dùng thì đừng bắt người chơi tải.
for (const file of readdirSync(SRC).filter((f) => f.endsWith('.png') && !f.startsWith('_')).sort()) {
  const raw = readPng(readFileSync(join(SRC, file)));
  // downscale() dùng {w,h} như sprite, còn readPng() trả {width,height}.
  const img = { w: raw.width, h: raw.height, data: raw.data };
  const small = img.w > MAX_W ? downscale(img, img.w / MAX_W) : img;
  const full = new Pixels(small.w, small.h);
  full.data.set(small.data);
  // So cả hai cách rồi lấy cái nhẹ hơn: ảnh ít màu thì màu thật đã đủ nhỏ, ảnh
  // vẽ tay chuyển màu mềm thì bảng màu thắng cách biệt.
  const truecolour = full.toPng();
  const indexed = toIndexedPng(small.w, small.h, small.data, 256);
  const buf = indexed.length < truecolour.length ? indexed : truecolour;
  const how = buf === indexed ? 'bảng màu' : 'màu thật';
  writeFileSync(join(OUT, file), buf);
  console.log(`${file.padEnd(12)} ${img.w}×${img.h} → ${full.width}×${full.height}  ${how}  ${(buf.length / 1024).toFixed(0)} KB (màu thật ${(truecolour.length / 1024).toFixed(0)} KB)`);
}
