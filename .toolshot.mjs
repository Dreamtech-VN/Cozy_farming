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
  ev.bus.emit(ev.EV.OPEN_PANEL,{panel:p}); }, p); await page.waitForTimeout(1200); };

console.log('hotbar:', JSON.stringify(await page.evaluate(() => window.__cozy.save.S.hotbar)));
console.log('hotbar ô hiện:', await page.locator('.hb-slot').count());
await page.screenshot({ path: `${OUT}/T-hotbar.png` });

// thử gỡ 4 ô cố định -> phải không đổi
console.log('sau unequip(0..3):', JSON.stringify(await page.evaluate(async () => {
  const s = window.__cozy.save;
  for (let i=0;i<4;i++) s.unequipTool(i);
  return s.S.hotbar;
})));

// nâng cấp: thiếu nguyên liệu -> chặn; đủ -> ăn theo tỉ lệ
console.log('nâng khi thiếu:', JSON.stringify(await page.evaluate(async () => {
  const tc = await import('/Cozy_farming/src/systems/toolcraft.ts');
  const s = window.__cozy.save;
  s.S.wallet.coins = 50000;
  const before = { lv: s.toolLevel('hoe'), coins: s.S.wallet.coins };
  const r = tc.upgradeTool('hoe');
  return { before, r, after: { lv: s.toolLevel('hoe'), coins: s.S.wallet.coins } };
})));
console.log('nâng cấp:', JSON.stringify(await page.evaluate(async () => {
  const tc = await import('/Cozy_farming/src/systems/toolcraft.ts');
  const s = window.__cozy.save;
  const out = {};
  // 1) thiếu nguyên liệu -> chặn, không trừ xu
  s.S.wallet.coins = 50000;
  out.thieu = { r: tc.upgradeTool('hoe'), lv: s.toolLevel('hoe'), coins: s.S.wallet.coins };
  // 2) đủ nguyên liệu -> có ăn có trượt, trượt thì cộng dồn may mắn
  s.addItem('wood', 60); s.addItem('stone', 60);
  const tries = [];
  for (let i = 0; i < 8 && s.toolLevel('hoe') < 2; i++) {
    const r = tc.upgradeTool('hoe');
    tries.push({ done: !!r.done, lv: s.toolLevel('hoe'), wood: s.itemCount('wood'),
                 stone: s.itemCount('stone'), coins: s.S.wallet.coins,
                 fail: tc.failStreak('hoe'),
                 rate: +tc.upgradeRate('hoe', { level: 2, rate: 0.8 }).toFixed(2) });
  }
  out.du = tries;
  return out;
}), null, 1));

await page.evaluate(() => { window.__cozy.save.S.zone = 'mall'; });
await open('toolupgrade');
await page.screenshot({ path: `${OUT}/T-upgrade.png` });
console.log('panel nâng cấp: ô =', await page.locator('.up-cell').count(),
  '| tên =', (await page.locator('.up-cell-nm').allInnerTexts()).join(' / '));
await closeAll();
await browser.close();
