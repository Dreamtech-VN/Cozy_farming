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

/**
 * Vùng cần XOÁ khỏi tranh, theo tỉ lệ bề ngang/cao.
 *
 * Bản mẫu vẽ sẵn chữ và thanh tiến độ vào tranh. Phủ mờ lúc chạy không ăn thua:
 * đó là chữ trắng viền dày, làm mờ chỉ biến nó thành vệt sáng vẫn đọc được và
 * chồng lên chữ thật. Xoá hẳn ở khâu đóng gói thì giao diện thật nằm trên nền
 * sạch, khỏi cần phủ gì.
 */
const ERASE = {
  'loading.png': [{ x: 0.19, y: 0.735, w: 0.68, h: 0.25 }],
};

/**
 * Làm NHOÈ một vùng, mép vùng tan dần ra ngoài.
 *
 * Không dùng cách nội suy dọc giữa hai mép: chỗ này có hàng rào, bụi cây và lối
 * đi, nội suy ra một khối vệt kéo dọc thấy ngay là vá. Làm nhoè mạnh thì chữ vẽ
 * chết tan thành mảng mờ, và vì mép vùng tan dần nên không lộ khung chữ nhật —
 * mắt đọc ra là hiệu ứng xoá phông chứ không phải chỗ bị bôi.
 */
function softBlur(img, rect, radius = 16) {
  const { w: W, h: H, data } = img;
  const x0 = Math.max(0, Math.round(rect.x * W));
  const x1 = Math.min(W - 1, Math.round((rect.x + rect.w) * W));
  const y0 = Math.max(0, Math.round(rect.y * H));
  const y1 = Math.min(H - 1, Math.round((rect.y + rect.h) * H));

  // Lấy dư ra ngoài đúng bằng bán kính, không thì mép vùng lấy mẫu thiếu và
  // sẫm lại thành viền.
  const bx0 = Math.max(0, x0 - radius * 2), bx1 = Math.min(W - 1, x1 + radius * 2);
  const by0 = Math.max(0, y0 - radius * 2), by1 = Math.min(H - 1, y1 + radius * 2);
  const bw = bx1 - bx0 + 1, bh = by1 - by0 + 1;

  const src = new Float32Array(bw * bh * 4);
  for (let y = 0; y < bh; y++) {
    for (let x = 0; x < bw; x++) {
      const s = ((by0 + y) * W + (bx0 + x)) * 4;
      const d = (y * bw + x) * 4;
      for (let c = 0; c < 4; c++) src[d + c] = data[s + c];
    }
  }

  // Box blur tách trục, chạy hai lượt cho gần giống Gauss.
  const tmp = new Float32Array(src.length);
  const pass = (from, to, horizontal) => {
    for (let y = 0; y < bh; y++) {
      for (let x = 0; x < bw; x++) {
        let n = 0; const acc = [0, 0, 0, 0];
        for (let k = -radius; k <= radius; k++) {
          const nx = horizontal ? x + k : x;
          const ny = horizontal ? y : y + k;
          if (nx < 0 || ny < 0 || nx >= bw || ny >= bh) continue;
          const i = (ny * bw + nx) * 4;
          for (let c = 0; c < 4; c++) acc[c] += from[i + c];
          n++;
        }
        const d = (y * bw + x) * 4;
        for (let c = 0; c < 4; c++) to[d + c] = acc[c] / n;
      }
    }
  };
  pass(src, tmp, true); pass(tmp, src, false);
  pass(src, tmp, true); pass(tmp, src, false);

  // Trộn lại theo mặt nạ mềm: 1 ở giữa, tắt dần về 0 ở mép vùng.
  const feather = 0.12;
  const falloff = (t) => (t <= 0 || t >= 1 ? 0 : t < feather ? t / feather : t > 1 - feather ? (1 - t) / feather : 1);
  for (let y = y0; y <= y1; y++) {
    const my = falloff((y - y0) / Math.max(1, y1 - y0));
    for (let x = x0; x <= x1; x++) {
      const m = my * falloff((x - x0) / Math.max(1, x1 - x0));
      if (m <= 0) continue;
      const d = ((y) * W + x) * 4;
      const b = ((y - by0) * bw + (x - bx0)) * 4;
      for (let c = 0; c < 4; c++) data[d + c] = Math.round(data[d + c] + (src[b + c] - data[d + c]) * m);
    }
  }
}
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
  for (const rect of ERASE[file] ?? []) softBlur(img, rect);
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
