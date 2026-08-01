import { chromium } from 'playwright';
const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium-1194/chrome-linux/chrome' });
const page = await browser.newPage({ viewport: { width: 932, height: 430 }, deviceScaleFactor: 2 });
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
await page.locator('.cc-panel input').fill('Tí');
await page.locator('.cc-start').click();
await page.waitForTimeout(6000);

const r = await page.evaluate(async () => {
  const f = await import('/Cozy_farming/src/systems/fishing.ts');
  const s = await import('/Cozy_farming/src/core/save.ts');
  const out = {};
  out.hasBait_empty = f.hasBait();
  s.S.wallet.coins = 50000; s.S.wallet.rubies = 300;
  out.buyRod1 = f.buyRod(1); out.coinsAfter = s.S.wallet.coins;
  out.buyRod3 = f.buyRod(3); out.rubiesAfter = s.S.wallet.rubies; out.tier = s.S.tools.rod;
  s.addItem('bait_rice', 2); s.addItem('bait_ant_egg', 1);
  out.hasBait_now = f.hasBait();
  out.use1 = f.useBait();                       // phải lấy trứng kiến trước
  out.left_ant = s.itemCount('bait_ant_egg');
  out.use2 = f.useBait(); out.use3 = f.useBait();
  out.hasBait_after = f.hasBait();
  out.use4 = f.useBait();
  return out;
});
console.log(JSON.stringify(r, null, 1));
await browser.close();
