import { chromium } from 'playwright';
const OUT='/tmp/claude-0/-home-user-Cozy-farming/b40e10a2-4a20-5fd7-b845-31972e4262c8/scratchpad';
const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium-1194/chrome-linux/chrome' });
const page = await browser.newPage({ viewport: { width: 932, height: 430 }, deviceScaleFactor: 3 });
page.on('pageerror', e => console.log('[pageerror]', e.message));
await page.goto('http://127.0.0.1:5173/Cozy_farming/', { waitUntil: 'networkidle' });
await page.waitForSelector('.login-box', { timeout: 60000 });
await page.waitForTimeout(400);
await page.locator('button.lg-acc').first().click();
await page.waitForTimeout(400);
await page.locator('.lg-form input').nth(0).fill('nongdan');
await page.locator('.lg-form input').nth(1).fill('123456');
await page.locator('.lg-form button.lg-acc').click();
await page.waitForSelector('.lg-start', { timeout: 30000 });
await page.locator('.lg-start').click();
await page.waitForSelector('.cc-panel', { timeout: 30000 });
await page.locator('.cc-panel input').fill('Tí Nông Dân');
await page.waitForTimeout(300);
await page.locator('.cc-start').click();
await page.waitForTimeout(6000);
const closeAll = async () => {
  for (let i=0;i<8;i++){ const n = await page.locator('.win-close').count(); if(!n) break;
    await page.locator('.win-close').last().click(); await page.waitForTimeout(300); }
};
await closeAll();
const open = async (p) => { await page.evaluate(async (p) => { const ev=await import('/Cozy_farming/src/core/events.ts');
  ev.bus.emit(ev.EV.OPEN_PANEL,{panel:p}); }, p); await page.waitForTimeout(1200); };

await page.evaluate(() => {
  const c = window.__cozy;
  c.save.S.wallet.coins = 30000; c.save.S.wallet.rubies = 200;
  for (const id of ['fish_0','fish_4','fish_29','wood','stone','bait_rice','bait_worm','bait_ant_egg','gift_teddy'])
    c.save.addItem(id, 3);
});

await open('inventory');
console.log('BAG ô =', await page.locator('.bag-slot').count(),
  '| tab =', (await page.locator('.bag-tab').allInnerTexts()).join(' / '));
await page.screenshot({ path: `${OUT}/F-bag.png` });
await closeAll();

await page.evaluate(() => { window.__cozy.game?.scene?.keys; });
await page.evaluate(async () => { const ev=await import('/Cozy_farming/src/core/events.ts');
  window.__DEV_SHOP = 1; });
// tiệm câu cần đứng đúng khu -> gọi thẳng render bằng cách bỏ qua check
await page.evaluate(() => { window.__cozy.save.S.zone = 'beach'; });
await open('fishingshop');
console.log('SHOP rows =', (await page.locator('.win .row .t1').allInnerTexts()).join(' | '));
await page.screenshot({ path: `${OUT}/F-rodshop.png` });
const tabs = page.locator('.win-tabs .tab');
if (await tabs.count() > 1) { await tabs.nth(1).click(); await page.waitForTimeout(600);
  console.log('BAIT rows =', (await page.locator('.win .row .t1').allInnerTexts()).join(' | '));
  await page.screenshot({ path: `${OUT}/F-baitshop.png` }); }
await closeAll();
await browser.close();
