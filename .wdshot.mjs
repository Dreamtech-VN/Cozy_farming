import { chromium } from 'playwright';
const OUT='/tmp/claude-0/-home-user-Cozy-farming/b40e10a2-4a20-5fd7-b845-31972e4262c8/scratchpad';
const W = +(process.argv[2] || 932), H = +(process.argv[3] || 430);
const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium-1194/chrome-linux/chrome' });
const page = await browser.newPage({ viewport: { width: W, height: H }, deviceScaleFactor: 3 });
page.on('pageerror', e => console.log('[pageerror]', e.message));
await page.goto('http://127.0.0.1:5173/Cozy_farming/', { waitUntil: 'networkidle' });
await page.waitForSelector('.login-box', { timeout: 60000 });
await page.locator('button.lg-acc').first().click();
await page.waitForTimeout(300);
await page.locator('.lg-form input').nth(0).fill('nongdan');
await page.locator('.lg-form input').nth(1).fill('123456');
await page.locator('.lg-form button.lg-acc').click();
await page.waitForSelector('.lg-start', { timeout: 30000 });
await page.locator('.lg-start').click();
await page.waitForSelector('.cc-panel', { timeout: 30000 });
await page.locator('.cc-panel input').fill('Tí Nông Dân');
await page.locator('.cc-start').click();
await page.waitForTimeout(6000);
const closeAll = async () => { for (let i=0;i<8;i++){ if(!(await page.locator('.win-close').count())) break;
  await page.locator('.win-close').last().click(); await page.waitForTimeout(300);} };
await closeAll();
const open = async (p) => { await page.evaluate(async (p) => { const ev=await import('/Cozy_farming/src/core/events.ts');
  ev.bus.emit(ev.EV.OPEN_PANEL,{panel:p}); }, p); await page.waitForTimeout(1300); };

await page.evaluate(() => { const c=window.__cozy;
  c.save.S.wallet.coins = 90000; c.save.S.wallet.rubies = 300;
  for (const id of ['fish_0','fish_4','wood','stone','gift_teddy']) c.save.addItem(id, 3);
  // vài món quần áo cho tủ đồ có đồ mà xem
  for (const p of [12, 20, 33, 41, 55, 61, 70, 88, 101, 442]) if (!c.save.S.chibiWardrobe.includes(p)) c.save.S.chibiWardrobe.push(p);
});

await open('inventory');
// đo nút cuối trong thẻ chi tiết có bị cắt không
const clip = await page.evaluate(() => {
  const card = document.querySelector('.bag-card');
  const btns = card ? [...card.querySelectorAll('.btn')] : [];
  const last = btns[btns.length - 1];
  if (!card || !last) return null;
  const c = card.getBoundingClientRect(), b = last.getBoundingClientRect();
  return { cardBottom: +c.bottom.toFixed(1), btnBottom: +b.bottom.toFixed(1),
           overflow: +(b.bottom - c.bottom).toFixed(1),
           scrollH: card.scrollHeight, clientH: card.clientHeight };
});
console.log(`[${W}x${H}] bag-card:`, JSON.stringify(clip));
await page.screenshot({ path: `${OUT}/H-bag-${H}.png` });
await closeAll();

await open('wardrobe');
console.log('wd-char:', JSON.stringify(await page.evaluate(() => {
  const m = document.querySelector('.wd-char');
  const lb = document.querySelector('.wd-left-body');
  const c = m?.firstElementChild;
  return { midH: m?.clientHeight, midW: m?.clientWidth, leftBodyH: lb?.clientHeight,
           childH: c?.getBoundingClientRect().height, childW: c?.getBoundingClientRect().width,
           scrollH: m?.scrollHeight };
})));
await page.screenshot({ path: `${OUT}/H-wardrobe-${H}.png` });
await closeAll();
await browser.close();
