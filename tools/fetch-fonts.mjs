#!/usr/bin/env node
/**
 * Tải font Google về TỰ HOST trong client/assets/fonts/.
 *
 * Không nhúng thẳng link fonts.googleapis.com vì hai lý do: game phải chạy được
 * khi không có mạng ngoài, và mỗi lần tải chữ là một request kèm IP người chơi
 * gửi sang bên thứ ba.
 *
 * Chỉ lấy ba subset cần dùng: latin, latin-ext và vietnamese — game viết bằng
 * tiếng Việt nên thiếu subset vietnamese là chữ có dấu rơi về font hệ thống.
 */
import { writeFileSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';

const UA = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36';
const OUT = join(process.cwd(), 'client', 'assets', 'fonts');
mkdirSync(OUT, { recursive: true });

/** Nhận ra subset qua unicode-range đặc trưng của nó. */
const SUBSETS = [
  { name: 'vietnamese', probe: 'U+1EA0-1EF9' },
  { name: 'latin-ext', probe: 'U+0100-02BA' },
  { name: 'latin', probe: 'U+0000-00FF' },
];

const FAMILIES = [
  { family: 'Baloo 2', spec: 'Baloo+2:wght@500;600;700', slug: 'baloo2' },
  { family: 'Nunito', spec: 'Nunito:wght@400;600;700;800', slug: 'nunito' },
];

const css = [];

for (const { family, spec, slug } of FAMILIES) {
  const url = `https://fonts.googleapis.com/css2?family=${spec}&display=swap`;
  const source = await fetch(url, { headers: { 'user-agent': UA } }).then((r) => r.text());

  // Mỗi khối @font-face của Google gồm weight, src và unicode-range. Cả hai
  // font đều là font BIẾN THIÊN nên Google trả về cùng một file cho mọi weight
  // — gộp theo URL, không thì tải trùng ba lần và repo phình vô ích.
  const blocks = source.split('@font-face').slice(1);
  const bySrc = new Map();

  for (const block of blocks) {
    const weight = block.match(/font-weight:\s*([^;]+);/)?.[1].trim();
    const src = block.match(/url\((https:[^)]+\.woff2)\)/)?.[1];
    const range = block.match(/unicode-range:\s*([^;]+);/)?.[1].trim();
    if (!src || !range) continue;

    const subset = SUBSETS.find((s) => range.includes(s.probe));
    if (!subset) continue; // bỏ cyrillic, greek, hebrew… — không dùng tới

    const entry = bySrc.get(src) ?? { subset, range, weights: [] };
    entry.weights.push(weight);
    bySrc.set(src, entry);
  }

  for (const [src, { subset, range, weights }] of bySrc) {
    const file = `${slug}-${subset.name}.woff2`;
    const bytes = Buffer.from(await fetch(src, { headers: { 'user-agent': UA } }).then((r) => r.arrayBuffer()));
    writeFileSync(join(OUT, file), bytes);

    // Khai báo một khoảng weight cho font biến thiên thay vì từng số rời.
    const numbers = weights.map(Number).filter(Number.isFinite);
    const span = numbers.length > 1 ? `${Math.min(...numbers)} ${Math.max(...numbers)}` : weights[0];

    css.push(`@font-face {
  font-family: '${family}';
  font-style: normal;
  font-weight: ${span};
  font-display: swap;
  src: url('/assets/fonts/${file}') format('woff2');
  unicode-range: ${range};
}`);
    console.log(`${file.padEnd(30)} ${(bytes.length / 1024).toFixed(1)} KB  (weight ${span})`);
  }
}

writeFileSync(join(OUT, 'fonts.css'),
  `/* Sinh bằng tools/fetch-fonts.mjs — đừng sửa tay.\n   Baloo 2 và Nunito, giấy phép SIL OFL 1.1, xem OFL.txt cùng thư mục. */\n\n${css.join('\n\n')}\n`);
console.log('fonts.css sinh xong với', css.length, 'khối @font-face');
