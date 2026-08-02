import type Phaser from 'phaser';
import { bus, EV, toast } from '@/core/events';
import { S, unequipTool, toolLevel, toggleHand, heldTool, selectTool, ROD_SLOT } from '@/core/save';
import { h, root, fmt, charFace, avatarEl, spr, chibiPreview, uiIcon } from './kit';
import { virtualInput, queueAction } from '@/core/input';
import { TITLES } from '@/data/quests';
import { gameHour, currentWeather, WEATHER_ICON, WEATHER_NAME } from '@/systems/time';
import * as socialMod from '@/systems/social';
import * as storeMod from '@/systems/farmstore';
import { initSocial } from '@/systems/social';
import { TOOLS, toolIconSize } from '@/data/tools';
import { rodIconRect } from '@/data/fish';
import { initDaily } from '@/systems/meta';
import { initQuests, activeQuestList } from '@/systems/quests';
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
  const ids = ['hotbar', 'menu-drawer', 'chat-fab', 'quest-bar'];
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
    (window as any).__cozy = { openPanel, bus, save: saveMod, game, social: socialMod, store: storeMod };
  });

  // cảnh báo xoay ngang
  const rot = h('div');
  rot.id = 'rotate-hint';
  rot.innerHTML = '<div class="phone"></div><div>Xoay ngang màn hình để chơi nhé!</div>';
  document.body.append(rot);

  // cỡ chữ chat người chơi tự chỉnh (Cài đặt chat > Khác)
  if (S.settings.chatFont) {
    document.documentElement.style.setProperty('--chat-font', `${S.settings.chatFont}px`);
  }

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
  // thanh tiền: viên xu/ngọc (ảnh Cozy UI Pack) đè lên mép trái viên thuốc,
  // nút + nằm ngay trên viên ngọc — bấm cả viên là mở nạp
  right.innerHTML = `
    <button class="hud-cur" id="coin-plus">
      <img class="hud-cur-ic" src="assets/ui/inv/cur_coin.png">
      <span class="hud-cur-n" id="hud-coins">0</span>
    </button>
    <button class="hud-cur" id="ruby-plus">
      <img class="hud-cur-ic" src="assets/ui/inv/cur_gem.png">
      <img class="hud-cur-plus" src="assets/ui/inv/cur_plus.png">
      <span class="hud-cur-n" id="hud-rubies">0</span>
    </button>
    <div class="hud-clock" id="hud-clock"></div>`;
  // thanh khu nằm HẲN dưới thanh thời tiết -> bọc thêm một cột bên phải
  const rightCol = h('div', 'hud-right');
  const roomBtn = h('button', 'hud-room'); roomBtn.id = 'hud-room';
  rightCol.append(right, roomBtn);
  top.append(prof, rightCol);
  root().append(top);
  (right.querySelector('#coin-plus') as HTMLElement).onclick = () => openPanel('topup');
  (right.querySelector('#ruby-plus') as HTMLElement).onclick = () => openPanel('topup');
  roomBtn.onclick = () => { sfx.click(); openPanel('changeroom'); };

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
    ['inventory', 'Túi đồ', 'inventory'],
    ['mail', 'Thư', 'mail'],
    ['map', 'Bản đồ', 'map'],
    ['social', 'Bạn bè', 'social'],
    ['daily', 'Điểm danh', 'daily'],
    ['wheel', 'Vòng quay', 'wheel'],
    ['collection', 'Sưu tập', 'collections'],
    ['trophy', 'Xếp hạng', 'ranking'],
    ['wardrobe', 'Nhân vật', 'wardrobe'],
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
  // Túi đồ và Thư dời hẳn vào ngăn kéo cho gọn; ngoài chỉ còn menu + biểu cảm
  quick.append(menuBtn, mkBtn('emote', 'Biểu cảm', () => openPanel('emotes')));
  root().append(quick);
  buildQuestBar();
  // chạm ra ngoài thì đóng ngăn kéo
  document.addEventListener('pointerdown', e => {
    if (drawer.classList.contains('open') && !drawer.contains(e.target as Node) && e.target !== menuBtn && !menuBtn.contains(e.target as Node)) {
      drawer.classList.remove('open');
    }
  });

  // Điều khiển hoàn toàn bằng cảm ứng: chạm nền để đi, tới nơi tự mở hành động.
  // (không còn joystick và cụm nút hành động)

  // Chat gọn lại thành một icon nổi, kéo đi đâu cũng được, bấm mới mở khung chat
  buildChatBubble();

  // cập nhật số liệu
  bus.on(EV.WALLET, refreshHud);
  bus.on(EV.STATE_CHANGED, refreshHud);
  bus.on(EV.APPEARANCE, refreshHud);
  bus.on(EV.QUEST, refreshHud);
  bus.on(EV.TIME_TICK, refreshClock);
  bus.on(EV.ZONE, refreshRoomBar);
  setInterval(refreshClock, 10_000);
  refreshHud();
  refreshClock();
  refreshRoomBar();
}

// ===== Icon chat nổi: kéo thả tự do, bấm là mở khung trò chuyện =====
// Vị trí nhớ trong localStorage để lần sau mở game vẫn nằm đúng chỗ đã kéo.
const CHAT_POS_KEY = 'cozy_chat_btn_pos';

// Nút chat là MỐC NEO của khung trò chuyện: kéo nút tới đâu thì lần sau mở
// khung ra ngay đó, và kéo khung cũng dời nút theo cho hai cái luôn đi cùng nhau.
export function chatFabPos(): { x: number; y: number; w: number; h: number } {
  const b = document.getElementById('chat-fab');
  if (!b) return { x: 12, y: root().clientHeight - 130, w: 56, h: 56 };
  return { x: b.offsetLeft, y: b.offsetTop, w: b.offsetWidth, h: b.offsetHeight };
}

export function setChatFabPos(x: number, y: number) {
  const b = document.getElementById('chat-fab');
  if (!b) return;
  const r = root().getBoundingClientRect();
  const nx = Math.max(6, Math.min(r.width - b.offsetWidth - 6, x));
  const ny = Math.max(6, Math.min(r.height - b.offsetHeight - 6, y));
  b.style.left = `${nx}px`;
  b.style.top = `${ny}px`;
  localStorage.setItem(CHAT_POS_KEY, JSON.stringify({ x: nx, y: ny }));
}

function buildChatBubble() {
  const b = h('button', 'chat-fab');
  b.id = 'chat-fab';
  b.innerHTML = `<img src="assets/ui/pack/icon_chat.png"><span class="dot"></span>`;
  b.title = 'Trò chuyện';
  root().append(b);

  const clamp = (x: number, y: number) => {
    const r = root().getBoundingClientRect();
    return {
      x: Math.max(6, Math.min(r.width - b.offsetWidth - 6, x)),
      y: Math.max(6, Math.min(r.height - b.offsetHeight - 6, y))
    };
  };
  const place = (x: number, y: number) => {
    const p = clamp(x, y);
    b.style.left = `${p.x}px`;
    b.style.top = `${p.y}px`;
  };
  try {
    const saved = JSON.parse(localStorage.getItem(CHAT_POS_KEY) || 'null');
    if (saved) place(saved.x, saved.y); else place(12, root().clientHeight - 130);
  } catch { place(12, root().clientHeight - 130); }

  // Listener move/up gắn sẵn trên window ngay từ đầu (gắn thêm ngay trong lúc
  // đang xử lý pointerdown thì Chromium không giao pointermove cho nó nữa).
  let dragging = false, moved = false, dx = 0, dy = 0, sx = 0, sy = 0;
  window.addEventListener('pointermove', e => {
    if (!dragging) return;
    if (Math.abs(e.clientX - sx) > 3 || Math.abs(e.clientY - sy) > 3) moved = true;
    if (moved) { place(e.clientX - dx, e.clientY - dy); e.preventDefault(); }
  }, { passive: false });
  const endDrag = () => {
    if (!dragging) return;
    dragging = false;
    if (moved) localStorage.setItem(CHAT_POS_KEY, JSON.stringify({ x: b.offsetLeft, y: b.offsetTop }));
    else { sfx.click(); openPanel('chat'); }
    b.classList.remove('unread');
  };
  window.addEventListener('pointerup', endDrag);
  window.addEventListener('pointercancel', endDrag);
  b.addEventListener('pointerdown', e => {
    dragging = true; moved = false;
    sx = e.clientX; sy = e.clientY;
    dx = e.clientX - b.offsetLeft; dy = e.clientY - b.offsetTop;
    e.stopPropagation();
  });
  window.addEventListener('resize', () => place(b.offsetLeft, b.offsetTop));

  // có tin mới mà chưa mở chat -> chấm đỏ + nảy nhẹ
  bus.on(EV.CHAT, (m: ChatMessage) => {
    if (m.from === S.player.name) return;
    if (document.querySelector('.win-chat')) return;
    b.classList.add('unread');
  });
}

// ===== Thanh nhiệm vụ dưới cụm nút: mỗi lần 1 nhiệm vụ, bấm mũi tên xem thêm =====
let questIdx = 0;

function buildQuestBar() {
  const bar = h('div'); bar.id = 'quest-bar';
  bar.innerHTML = `
    <div class="qb-tab"><img src="assets/ui/pack/icon_quest.png"><span>Nhiệm vụ</span><span class="dot"></span></div>
    <div class="qb-body"><div class="qb-text"></div><button class="qb-more">›</button></div>`;
  root().append(bar);
  (bar.querySelector('.qb-tab') as HTMLElement).onclick = () => { sfx.click(); openPanel('quests'); };
  (bar.querySelector('.qb-text') as HTMLElement).onclick = () => { sfx.click(); openPanel('quests'); };
  (bar.querySelector('.qb-more') as HTMLElement).onclick = e => {
    e.stopPropagation();
    sfx.click();
    questIdx++;
    refreshQuestBar();
  };
  bus.on(EV.QUEST, refreshQuestBar);
  bus.on(EV.STATE_CHANGED, refreshQuestBar);
  refreshQuestBar();
}

function refreshQuestBar() {
  const bar = document.getElementById('quest-bar');
  if (!bar) return;
  const list = activeQuestList().filter(q => !q.claimed);
  if (!list.length) { bar.style.display = 'none'; return; }
  bar.style.display = '';
  questIdx = ((questIdx % list.length) + list.length) % list.length;
  const q = list[questIdx];
  const txt = bar.querySelector('.qb-text') as HTMLElement;
  txt.classList.toggle('done', q.done);
  txt.textContent = q.done
    ? `${q.def.name} — có thưởng chờ nhận`
    : `${q.def.name} (${Math.min(q.progress, q.def.target)}/${q.def.target})`;
  bar.querySelector('.qb-more')!.classList.toggle('hide', list.length < 2);
  bar.querySelector('.qb-tab')!.classList.toggle('notify', list.some(x => x.done));
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

// Thanh khu dưới thanh thời tiết — chỉ hiện ở map đông người (nông trại riêng
// và nhà riêng là map cá nhân, không có khu).
function personalZone(id: string) { return id === 'farm' || id === 'house'; }

export function refreshRoomBar() {
  const el = document.getElementById('hud-room');
  if (!el) return;
  if (personalZone(S.zone)) { el.style.display = 'none'; return; }
  el.style.display = '';
  const n = socialMod.roomPlayers(S.zone, S.zoneRoom);
  el.innerHTML = `<span class="hr-no">Khu ${S.zoneRoom}</span>`
    + `<span class="hr-n">${n}/${socialMod.ROOM_CAP}</span><span class="hr-more">›</span>`;
  el.title = 'Đổi khu';
}

function refreshClock() {
  const el = document.getElementById('hud-clock');
  if (!el) return;
  const hg = gameHour();
  const hh = Math.floor(hg);
  const mm = Math.floor((hg - hh) * 60);
  const night = hg >= 18 || hg < 6;
  // Ban ngày mặt trời mọc 6h ở mép trái, đỉnh lúc 12h, lặn 18h ở mép phải;
  // ban đêm mặt trăng cũng chạy đúng vòng cung đó (mọc 18h, lặn 6h) cho thấy rõ.
  const t = night ? ((hg - 18 + 24) % 24) / 12 : (hg - 6) / 12;
  const ang = t * Math.PI - Math.PI;
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
        <span>${WEATHER_NAME[currentWeather()]}</span>
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

// ================= Thanh công cụ (cạnh joystick) =================
export function refreshHotbar() {
  let bar = document.getElementById('hotbar');
  if (!bar) { bar = h('div'); bar.id = 'hotbar'; root().append(bar); }
  bar.style.display = hudVisible ? '' : 'none';
  bar.innerHTML = '';
  S.hotbar.forEach((tid, i) => {
    const slot = h('button', 'hb-slot');
    const t = TOOLS[tid];
    if (t) {
      // cần câu hiện đúng bậc đang dùng (tre / sắt / VIP)
      if (tid === 'rod') {
        const ri = rodIconRect(S.tools.rod);
        slot.append(spr(ri.url, ri.sx, ri.sy, ri.sw, ri.sh, 30));
      } else {
        slot.append(spr(t.url, 0, 0, t.w, t.h, toolIconSize(t, 32)));
      }
      const lv = toolLevel(tid);
      if (lv >= 2) slot.append(h('span', 'hb-lv', `Lv${lv}`));
      if (heldTool() === tid) slot.classList.add('hb-on');
      const held = heldTool() === tid;
      slot.title = `${t.name}${lv >= 2 ? ` Lv.${lv}` : ''} — bấm để ${held ? 'cất đi' : 'cầm'}`;
      // bấm = cầm công cụ này (và dùng luôn nếu đang đứng cạnh chỗ dùng được);
      // bấm lại đúng món đang cầm = cất xuống, không cầm trên tay nữa
      slot.onclick = () => {
        sfx.click();
        const wasHeld = heldTool() === tid;
        selectTool(tid);
        if (!wasHeld) bus.emit('hotbar:use', tid);
      };
      // 4 công cụ cơ bản là đồ cố định — chỉ ô cần câu mới gỡ được
      if (i === ROD_SLOT) {
        const off = () => { unequipTool(i); toast(`Đã cất ${t.name}.`, 'rod'); };
        let hold = 0;
        slot.onpointerdown = () => { hold = window.setTimeout(off, 550); };
        slot.onpointerup = slot.onpointerleave = () => clearTimeout(hold);
        slot.oncontextmenu = e => { e.preventDefault(); off(); };
      }
    } else if (i === ROD_SLOT) {
      // ô cuối để dành cho cần câu — chưa mua thì vẫn hiện dấu + như các ô khác
      slot.classList.add('empty');
      slot.textContent = '+';
      slot.title = 'Ô cần câu — mua cần ở tiệm câu Ông Biển';
      slot.onclick = () => { sfx.click(); toast('Ô này dành cho cần câu — mua cần ở tiệm câu Ông Biển nhé.', 'rod'); };
    } else {
      // 4 ô đầu luôn có công cụ nên nhánh này gần như không xảy ra
      slot.classList.add('empty');
      slot.textContent = '+';
    }
    bar!.append(slot);
  });
}
