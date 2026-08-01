import { chromium } from 'playwright';
const OUT='/tmp/claude-0/-home-user-Cozy-farming/b40e10a2-4a20-5fd7-b845-31972e4262c8/scratchpad';
const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium-1194/chrome-linux/chrome' });
const page = await browser.newPage({ viewport: { width: 932, height: 430 }, deviceScaleFactor: 3 });
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
  c.store.addTo('produce','carrot',9); c.store.addTo('produce','egg',12); c.store.addTo('produce','milk',5); });
for (const [p, f] of [['warehouse','G-warehouse'],['wardrobe','G-wardrobe'],['quests','G-quests'],['changeroom','G-room']]) {
  await open(p);
  await page.screenshot({ path: `${OUT}/${f}.png` });
  await closeAll();
}
// menu + chat mở
await page.locator('.hud-menu-btn, .qa-btn').first().click().catch(()=>{});
await page.waitForTimeout(500);
await page.screenshot({ path: `${OUT}/G-menu.png` });
await browser.close();
