#!/usr/bin/env node
/**
 * Sinh trang tra cứu art: mọi sprite kèm tên, nhóm theo trang.
 *
 * Tên sprite nội thất đặt theo nhóm + số thứ tự (`hm_seat_03`) vì đặt tay 547
 * cái tên riêng vừa lâu vừa sai. Tên như vậy chỉ dùng được khi NHÌN được vật
 * nào là vật nào — nên trang này là một phần của bộ art, không phải tài liệu
 * cho vui.
 *
 *   npm run art-index   →   docs/art-index.html
 */
import { readFileSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

const OUT = join(process.cwd(), 'client', 'assets', 'world');
const atlas = JSON.parse(readFileSync(join(OUT, 'atlas.json'), 'utf8'));
const { pages, index } = atlas.sprites;

const byPage = new Map();
for (const [name, r] of Object.entries(index)) {
  if (!byPage.has(r.page)) byPage.set(r.page, []);
  byPage.get(r.page).push({ name, ...r });
}

const CELL = 96;
const section = ([page, items]) => {
  const groups = new Map();
  for (const it of items) {
    // Nhóm = phần tên trước số thứ tự cuối.
    const key = it.name.replace(/_\d+$/, '');
    if (!groups.has(key)) groups.set(key, []);
    groups.get(key).push(it);
  }
  const blocks = [...groups].sort(([a], [b]) => a.localeCompare(b)).map(([key, list]) => {
    const cells = list.sort((a, b) => a.name.localeCompare(b.name)).map((it) => {
      // Ảnh nền cắt đúng ô sprite, co cho vừa ô xem mà giữ tỉ lệ.
      const k = Math.min(CELL / it.w, CELL / it.h);
      return `<figure>
  <div><i style="--w:${it.w * k}px;--h:${it.h * k}px;--bx:${-it.x * k}px;--by:${-it.y * k}px;--bw:${2048 * k}px;background-image:url('../client/assets/world/${pages[page]}')"></i></div>
  <figcaption>${it.name}</figcaption>
</figure>`;
    }).join('\n');
    return `<h3>${key} <small>${list.length}</small></h3>\n<div class="grid">\n${cells}\n</div>`;
  }).join('\n');
  return `<section><h2>${page} <small>${items.length} vật · ${pages[page]}</small></h2>\n${blocks}</section>`;
};

const html = `<!doctype html>
<html lang="vi"><meta charset="utf-8">
<title>Bản tra cứu art — Cozy Farming</title>
<style>
  body { font: 14px/1.5 system-ui, sans-serif; margin: 0; padding: 24px; background: #f4efe4; color: #3a2a1e; }
  h1 { margin: 0 0 4px; } h2 { margin: 32px 0 8px; border-bottom: 2px solid #d8c9ae; padding-bottom: 4px; }
  h3 { margin: 20px 0 6px; font-size: 15px; color: #6b543c; }
  small { font-weight: 400; color: #8a7659; }
  .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(112px, 1fr)); gap: 10px; }
  figure { margin: 0; background: #fffdf7; border: 1px solid #ddd0b6; border-radius: 8px; padding: 6px; text-align: center; }
  /* Ô cao cố định, sprite canh ĐÁY: vật cao thấp khác nhau nên canh giữa thì
     hàng chữ nhấp nhô, mà canh đáy còn khớp với cách game neo sprite. */
  figure div { height: ${CELL}px; display: flex; align-items: flex-end; justify-content: center; }
  figure i { display: block; width: var(--w); height: var(--h);
    background-position: var(--bx) var(--by); background-size: var(--bw) auto; background-repeat: no-repeat; }
  figcaption { font: 11px monospace; margin-top: 4px; word-break: break-all; color: #6b543c; }
</style>
<h1>Bản tra cứu art</h1>
<p>Sinh bằng <code>npm run art-index</code> từ <code>client/assets/world/atlas.json</code>. Tên dưới mỗi hình là tên dùng trong <code>scenery</code> của <code>data/content/maps.json</code>.</p>
${[...byPage].sort().map(section).join('\n')}
</html>
`;
writeFileSync(join(process.cwd(), 'docs', 'art-index.html'), html);
console.log(`docs/art-index.html · ${Object.keys(index).length} sprite`);
