import type Phaser from 'phaser';
import { bus, EV, toast } from '@/core/events';
import { S, unequipTool, toolLevel, toggleHand, heldTool, selectTool } from '@/core/save';
import { h, root, fmt, charFace, avatarEl, spr, chibiPreview, uiIcon } from './kit';
import { virtualInput, queueAction } from '@/core/input';
import { TITLES } from '@/data/quests';
import { gameHour, currentWeather, WEATHER_ICON, season } from '@/systems/time';
import * as socialMod from '@/systems/social';
import { initSocial, getChatLog } from '@/systems/social';
import { TOOLS, toolIconSize } from '@/data/tools';
import { initDaily } from '@/systems/meta';
import { initQuests } from '@/systems/quests';
import { sfx } from '@/core/audio';
import { registerAllPanels } from './panels';
import { registerMinigames } from './minigames';
import type { ChatMessage } from '@/core/types';

// ===== Quản lý UI DOM phủ trên canvas =====

type PanelFn = (data?: any) => void;
const panels: Record<string, PanelFn> = {};
export function registerPanel(name: string, fn: PanelFn) { panels[name] = fn; }
export function openPanel(name: string, data?: any) { panels[name]?.(data); }

let gameRef: Phaser.Game;
export function getGame(): Phaser.Game { return gameRef; }

let hudBuilt = false;

// Nhớ trạng thái ẩn/hiện: refreshHotbar() có thể chạy lại lúc đang tạo nhân vật
// (EV.APPEARANCE bắn mỗi lần đổi đồ) và tạo mới thẻ #hotbar -> phải ẩn lại cho đúng.
let hudVisible = false;
export function isHudVisible() { return hudVisible; }

export function setHudVisible(show: boolean) {
  hudVisible = show;
  const ids = ['hotbar', 'menu-drawer', 'chat-mini'];
  const cls = ['.hud-top', '.hud-quick'];
  for (const id of ids) {
    const el = document.getElementById(id);
    if (el) el.style.display = show ? '' : 'none';
  }
  for (const sel of cls) {
    const el = document.querySelector(sel) as HTMLElement | null;
    if (el) el.style.display = show ? '' : 'none';
  }
}

export function initUI(game: Phaser.Game) {
  gameRef = game;
  registerAllPanels();
  registerMinigames();
  // hook debug/automation (dùng cho test tự động)
  import('@/core/save').then(saveMod => {
    (window as any).__cozy = { openPanel, bus, save: saveMod, game, social: socialMod };
  });

  // cảnh báo xoay ngang
  const rot = h('div');
  rot.id = 'rotate-hint';
  rot.innerHTML = '<div class="phone"></div><div>Xoay ngang màn hình để chơi nhé!</div>';
  document.body.append(rot);

  // toast container
  const toasts = h('div'); toasts.id = 'toasts'; root().append(toasts);
  bus.on(EV.TOAST, ({ msg, icon }: { msg: string; icon: string }) => {
    const t = h('div', 'toast');
    const ic = h('span');
    // icon dạng tên (vd 'coin', 'act_kiss') -> ảnh thật; còn lại giữ nguyên text
    if (/^[a-z][a-z0-9_]*$/.test(icon)) ic.append(uiIcon(icon, 20));
    else ic.textContent = icon;
    const tx = h('span'); tx.textContent = msg;
    t.append(ic, tx);
    toasts.append(t);
    setTimeout(() => t.remove(), 2800);
    while (toasts.children.length > 4) toasts.firstChild?.remove();
  });

  bus.on(EV.OPEN_PANEL, (p: { panel: string; data?: any }) => openPanel(p.panel, p.data));
  bus.on(EV.ZONE, () => { buildHud(); refreshHotbar(); });
  bus.on('hotbar:changed', () => refreshHotbar());
  bus.on(EV.APPEARANCE, () => refreshHotbar());

  // khởi tạo hệ thống nền sau khi vào world lần đầu
  bus.once(EV.ZONE, () => {
    initQuests();
    initDaily();
    initSocial();
    if (!S.daily.loginClaimed) setTimeout(() => openPanel('daily'), 600);
  });
}

// ================= HUD =================
function buildHud() {
  if (hudBuilt) { refreshHud(); return; }
  hudBuilt = true;
  // dựng xong thì áp lại trạng thái ẩn/hiện hiện hành (xem setHudVisible)
  queueMicrotask(() => setHudVisible(hudVisible));

  const top = h('div', 'hud-top');
  // hồ sơ
  const prof = h('div', 'hud-profile');
  prof.innerHTML = `
    <div class="hud-avatar"></div>
    <div>
      <div class="hud-name"></div>
      <div class="hud-title"></div>
      <div class="hud-lv"></div>
    </div>`;
  prof.onclick = () => { sfx.click(); openPanel('profile'); };
  // tiền tệ + đồng hồ
  const right = h('div', 'hud-currency');
  right.innerHTML = `
    <div class="pill"><img src="assets/ui/pack/icon_coin.png"> <span id="hud-coins">0</span> <span class="plus" id="coin-plus">＋</span></div>
    <div class="pill"><img src="assets/ui/pack/icon_ruby.png"> <span id="hud-rubies">0</span> <span class="plus" id="ruby-plus">＋</span></div>
    <div class="hud-clock" id="hud-clock"></div>`;
  top.append(prof, right);
  root().append(top);
  (right.querySelector('#coin-plus') as HTMLElement).onclick = () => openPanel('topup');
  (right.querySelector('#ruby-plus') as HTMLElement).onclick = () => openPanel('topup');

  // ---- HUD gọn: 3 nút nhanh + ngăn kéo menu (kiểu Avatar) ----
  const ICON = (n: string) => `assets/ui/pack/icon_${n}.png`;
  const quick = h('div', 'hud-quick');
  const mkBtn = (icon: string, title: string, onClick: () => void, panel?: string) => {
    const b = h('button', 'hud-btn');
    b.title = title;
    if (panel) b.dataset.panel = panel;
    b.innerHTML = `<img class="hicon" src="${ICON(icon)}"><span class="dot"></span>`;
    b.onclick = () => { sfx.click(); onClick(); };
    return b;
  };

  // ngăn kéo menu — mọi tính năng nằm trong này
  const drawer = h('div'); drawer.id = 'menu-drawer';
  const MENU: [string, string, string][] = [
    ['inventory', 'Kho đồ', 'inventory'],
    ['map', 'Bản đồ', 'map'],
    ['social', 'Bạn bè', 'social'],
    ['daily', 'Điểm danh', 'daily'],
    ['wheel', 'Vòng quay', 'wheel'],
    ['collection', 'Sưu tập', 'collections'],
    ['trophy', 'Xếp hạng', 'ranking'],
    ['wardrobe', 'Tủ đồ', 'wardrobe'],
    ['ruby', 'Nạp', 'topup'],
    ['settings', 'Cài đặt', 'settings']
  ];
  for (const [icon, label, panel] of MENU) {
    const it = h('button', 'menu-item');
    it.dataset.panel = panel;
    it.innerHTML = `<img src="${ICON(icon)}"><span>${label}</span><span class="dot"></span>`;
    it.onclick = () => { sfx.click(); drawer.classList.remove('open'); openPanel(panel); };
    drawer.append(it);
  }
  root().append(drawer);

  const menuBtn = mkBtn('menu', 'Menu', () => drawer.classList.toggle('open'));
  menuBtn.id = 'menu-btn';
  quick.append(
    menuBtn,
    mkBtn('inventory', 'Túi đồ', () => openPanel('inventory'), 'inventory'),
    mkBtn('quest', 'Nhiệm vụ', () => openPanel('quests'), 'quests'),
    mkBtn('mail', 'Thư', () => openPanel('mail'), 'mail'),
    mkBtn('emote', 'Biểu cảm', () => openPanel('emotes'))
  );
  root().append(quick);
  // chạm ra ngoài thì đóng ngăn kéo
  document.addEventListener('pointerdown', e => {
    if (drawer.classList.contains('open') && !drawer.contains(e.target as Node) && e.target !== menuBtn && !menuBtn.contains(e.target as Node)) {
      drawer.classList.remove('open');
    }
  });

  // Điều khiển hoàn toàn bằng cảm ứng: chạm nền để đi, tới nơi tự mở hành động.
  // (không còn joystick và cụm nút hành động)

  // khung chat trên màn hình — bấm vào là mở chat (không có nút riêng)
  const cm = h('div'); cm.id = 'chat-mini'; root().append(cm);
  cm.onclick = () => { sfx.click(); openPanel('chat'); };
  const cmLog = h('div'); cmLog.id = 'chat-mini-log';
  const cmHint = h('div'); cmHint.id = 'chat-mini-hint';
  cmHint.textContent = 'Nhắn gì đó...';
  cm.append(cmLog, cmHint);
  const renderChat = (m: ChatMessage) => {
    const el = h('div', `cm ch-${m.channel}`);
    const tag = m.channel === 'private' ? '[Riêng] ' : m.channel === 'area' ? '[Gần] ' : m.channel === 'public' ? '[Tổng] ' : '';
    el.textContent = `${tag}${m.from}: ${m.text}`;
    cmLog.append(el);
    while (cmLog.children.length > 4) cmLog.firstChild?.remove();
  };
  getChatLog().slice(-4).forEach(renderChat);
  bus.on(EV.CHAT, renderChat);

  // cập nhật số liệu
  bus.on(EV.WALLET, refreshHud);
  bus.on(EV.STATE_CHANGED, refreshHud);
  bus.on(EV.APPEARANCE, refreshHud);
  bus.on(EV.QUEST, refreshHud);
  bus.on(EV.TIME_TICK, refreshClock);
  setInterval(refreshClock, 10_000);
  refreshHud();
  refreshClock();
}

function refreshHud() {
  const q = (sel: string) => document.querySelector(sel) as HTMLElement | null;
  q('#hud-coins') && (q('#hud-coins')!.textContent = fmt(S.wallet.coins));
  q('#hud-rubies') && (q('#hud-rubies')!.textContent = fmt(S.wallet.rubies));
  const av = q('.hud-avatar');
  // 38 = đúng lòng khung .hud-avatar (42 - viền 2px mỗi bên) -> ảnh phủ kín hình tròn
  if (av) { av.innerHTML = ''; av.append(avatarEl(38)); }
  const nm = q('.hud-name'), tt = q('.hud-title'), lv = q('.hud-lv');
  if (nm) nm.textContent = S.player.name || 'Nông dân';
  if (tt) {
    const t = TITLES[S.player.title];
    tt.textContent = `「${t?.name ?? '...'}」`;
    tt.style.color = t?.color ?? '#fff';
  }
  if (lv) lv.textContent = `Lv.${S.player.level} · ${S.player.exp}/${S.player.level * 100} EXP`;
  // chấm đỏ: nhiệm vụ xong chưa nhận / thư chưa đọc / quà chưa nhận
  const dot = (panel: string, on: boolean) => {
    document.querySelector(`.hud-btn[data-panel="${panel}"]`)?.classList.toggle('notify', on);
    document.querySelector(`.menu-item[data-panel="${panel}"]`)?.classList.toggle('notify', on);
  };
  const questsDot = S.quests.completed.some(id => !S.quests.claimed.includes(id));
  const dailyDot = !S.daily.loginClaimed || !S.daily.checkinDays.includes(new Date().getDate());
  dot('quests', questsDot);
  dot('mail', S.mail.some(m => !m.read));
  dot('daily', dailyDot);
  // nút menu sáng chấm nếu bên trong có gì cần chú ý
  document.getElementById('menu-btn')?.classList.toggle('notify', questsDot || dailyDot);
}

// Đồng hồ: mặt tròn có bầu trời đổi màu theo giờ, mặt trời/trăng chạy vòng
// quanh đúng vị trí trong ngày; bên cạnh là giờ, mùa và thời tiết.
const CLOCK_PHASE: [number, string][] = [
  [0, 'night'], [5, 'dawn'], [8, 'day'], [16.5, 'day'], [18, 'dusk'], [20, 'night']
];
function clockPhase(hgame: number): string {
  let ph = 'night';
  for (const [h, p] of CLOCK_PHASE) if (hgame >= h) ph = p;
  return ph;
}

function refreshClock() {
  const el = document.getElementById('hud-clock');
  if (!el) return;
  const hg = gameHour();
  const hh = Math.floor(hg);
  const mm = Math.floor((hg - hh) * 60);
  const sz = season();
  const night = hg >= 19 || hg < 5;
  // 6h ở mép trái, 12h đỉnh, 18h mép phải -> góc = (giờ - 6) / 12 * 180 độ
  const ang = ((hg - 6) / 12) * Math.PI - Math.PI;
  const r = 15;
  const ox = 18 + Math.cos(ang) * r, oy = 19 + Math.sin(ang) * r;

  el.dataset.phase = clockPhase(hg);
  el.innerHTML = `
    <div class="clk-dial">
      <span class="clk-orb ${night ? 'moon' : 'sun'}" style="left:${ox}px;top:${oy}px"></span>
      <span class="clk-horizon"></span>
    </div>
    <div class="clk-txt">
      <div class="clk-h">${String(hh).padStart(2, '0')}<i>:</i>${String(mm).padStart(2, '0')}</div>
      <div class="clk-sub">
        <img src="assets/ui/act/${WEATHER_ICON[currentWeather()]}.png">
        <img src="assets/ui/act/${sz.icon}.png"><span>${sz.name}</span>
      </div>
    </div>`;
}

// ================= Joystick cảm ứng =================
function buildJoystick() {
  const js = h('div'); js.id = 'joystick';
  const stick = h('div', 'stick');
  js.append(stick);
  root().append(js);

  let active = false;
  const center = () => {
    const r = js.getBoundingClientRect();
    return { x: r.left + r.width / 2, y: r.top + r.height / 2, rad: r.width / 2 };
  };
  const move = (cx: number, cy: number) => {
    const c = center();
    let dx = cx - c.x, dy = cy - c.y;
    const d = Math.hypot(dx, dy);
    const max = c.rad;
    if (d > max) { dx = dx / d * max; dy = dy / d * max; }
    stick.style.transform = `translate(calc(-50% + ${dx}px), calc(-50% + ${dy}px))`;
    virtualInput.x = dx / max;
    virtualInput.y = dy / max;
  };
  const end = () => {
    active = false;
    stick.style.transform = 'translate(-50%, -50%)';
    virtualInput.x = 0; virtualInput.y = 0;
  };
  js.addEventListener('pointerdown', e => { active = true; js.setPointerCapture(e.pointerId); move(e.clientX, e.clientY); });
  js.addEventListener('pointermove', e => { if (active) move(e.clientX, e.clientY); });
  js.addEventListener('pointerup', end);
  js.addEventListener('pointercancel', end);

  // phím SPACE/E = nút hành động chính
  window.addEventListener('keydown', e => {
    if (e.code === 'Space' || e.code === 'KeyE') queueAction();
    const m = /^Digit([1-5])$/.exec(e.code);
    if (m) { const tid = S.hotbar[+m[1] - 1]; if (tid) bus.emit('hotbar:use', tid); }
  });
}

// ================= Thanh nông cụ (cạnh joystick) =================
export function refreshHotbar() {
  let bar = document.getElementById('hotbar');
  if (!bar) { bar = h('div'); bar.id = 'hotbar'; root().append(bar); }
  bar.style.display = hudVisible ? '' : 'none';
  bar.innerHTML = '';
  S.hotbar.forEach((tid, i) => {
    const slot = h('button', 'hb-slot');
    // ô đồ cầm tay: hand:<partId>
    if (tid.startsWith('hand:')) {
      const pid = Number(tid.slice(5));
      const held = (S.player.chibi?.hand ?? 0) === pid;
      if (held) slot.classList.add('hb-on');
      slot.append(chibiPreview(pid, 30));
      slot.title = 'Đồ cầm tay — bấm để cầm / cất';
      slot.onclick = () => { sfx.click(); toggleHand(pid); refreshHotbar(); };
      let hold2 = 0;
      slot.onpointerdown = () => { hold2 = window.setTimeout(() => { unequipTool(i); refreshHotbar(); }, 550); };
      slot.onpointerup = slot.onpointerleave = () => clearTimeout(hold2);
      slot.oncontextmenu = e => { e.preventDefault(); unequipTool(i); refreshHotbar(); };
      bar!.append(slot);
      return;
    }
    const t = TOOLS[tid];
    if (t) {
      slot.append(spr(t.url, 0, 0, t.w, t.h, toolIconSize(t, 32)));
      const lv = toolLevel(tid);
      if (lv >= 2) slot.append(h('span', 'hb-lv', `Lv${lv}`));
      if (heldTool() === tid) slot.classList.add('hb-on');
      slot.title = `${t.name}${lv >= 2 ? ` Lv.${lv}` : ''} — bấm để cầm`;
      // bấm = cầm nông cụ này (và dùng luôn nếu đang đứng cạnh chỗ dùng được)
      slot.onclick = () => {
        sfx.click();
        if (heldTool() !== tid) selectTool(tid);
        bus.emit('hotbar:use', tid);
      };
      // giữ lâu / chuột phải = gỡ nông cụ khỏi ô
      let hold = 0;
      slot.onpointerdown = () => { hold = window.setTimeout(() => { unequipTool(i); toast(`Đã gỡ ${t.name}.`, 'hoe'); }, 550); };
      slot.onpointerup = slot.onpointerleave = () => clearTimeout(hold);
      slot.oncontextmenu = e => { e.preventDefault(); unequipTool(i); toast(`Đã gỡ ${t.name}.`, 'hoe'); };
    } else {
      // ô trống: mở túi đồ — nông cụ mua về nằm trong túi, bấm món đồ để gắn
      slot.classList.add('empty');
      slot.textContent = '+';
      slot.title = 'Gắn nông cụ từ túi đồ';
      slot.onclick = () => { sfx.click(); openPanel('inventory'); toast('Nông cụ mua về nằm trong túi đồ — bấm vào món để gắn.', 'inventory'); };
    }
    bar!.append(slot);
  });
}
