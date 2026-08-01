import { chromium } from 'playwright';
const OUT='/tmp/claude-0/-home-user-Cozy-farming/b40e10a2-4a20-5fd7-b845-31972e4262c8/scratchpad';
const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium-1194/chrome-linux/chrome' });
const page = await browser.newPage({ viewport: { width: 932, height: 430 }, deviceScaleFactor: 3 });
page.on('pageerror', e => console.log('[pageerror]', e.message));
page.on('console', m => { if (m.type()==='error') console.log('[err]', m.text()); });
await page.goto('http://127.0.0.1:5173/Cozy_farming/', { waitUntil: 'networkidle' });
await page.waitForSelector('.login-box', { timeout: 60000 });
await page.locator('button.lg-acc').first().click();
await page.waitForTimeout(400);
await page.locator('.lg-form input').nth(0).fill('nongdan');
await page.locator('.lg-form input').nth(1).fill('123456');
await page.locator('.lg-form button.lg-acc').click();
await page.waitForSelector('.lg-start', { timeout: 30000 });
await page.locator('.lg-start').click();
await page.waitForSelector('.cc-panel', { timeout: 30000 });
await page.locator('.cc-panel input').fill('Tí Nông Dân');
await page.locator('.cc-start').click();
await page.waitForTimeout(6000);
const closeAll=async()=>{for(let i=0;i<8;i++){if(!(await page.locator('.win-backdrop').count()))break;
  await page.evaluate(()=>document.querySelectorAll('.win-backdrop').forEach(b=>b.remove()));await page.waitForTimeout(250);}};
await closeAll();
const open=async(p,d)=>{await page.evaluate(async ([p,d])=>{const ev=await import('/Cozy_farming/src/core/events.ts');
  ev.bus.emit(ev.EV.OPEN_PANEL,{panel:p,data:d});},[p,d]); await page.waitForTimeout(900);};

await open('wardrobe');
console.log('Nhân vật — tab:', (await page.locator('.wr-tab').allInnerTexts()).join(' / ') || (await page.locator('.wr-tabs button').allInnerTexts()).join(' / '));
console.log('có lực chiến?', await page.locator('.ch-cp').count(), '| ô trang bị:', await page.locator('.ch-slot').count());
await page.screenshot({ path: `${OUT}/R1-char.png` });
await closeAll();

await open('profile');
console.log('hồ sơ — có bảng chỉ số?', await page.locator('.pf-stat-row').count());
await page.screenshot({ path: `${OUT}/R2-profile.png` });
await closeAll();

await open('achievement');
console.log('thành tựu — tab dọc:', await page.locator('.av-rt').count(), '| nhóm:', (await page.locator('.av-cat-n').allInnerTexts()).join(', '));
await page.screenshot({ path: `${OUT}/R3-ach.png` });
await closeAll();

await open('quests');
await page.screenshot({ path: `${OUT}/R4-quest.png` });
await closeAll();
await open('inventory');
console.log('túi:', (await page.locator('.bag-slot').count()), 'ô');
await page.screenshot({ path: `${OUT}/R5-bag.png` });
await browser.close();
