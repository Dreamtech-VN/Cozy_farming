// Bộ công cụ dựng UI DOM nhỏ gọn
import { S } from '@/core/save';
import { bus } from '@/core/events';
import { lookLayers } from '@/data/chibi';
import { TITLES } from '@/data/quests';
import { skinArt } from '@/data/skins';
import { picSrc } from '@/data/avatars';
import { EMOJI_BY_ID, EMOJI_RE, emojiUrl } from '@/data/emoji';
import { BUBBLE_BY_ID, bubbleUrl } from '@/data/bubbles';
import BBOX from '@/data/chibi-bbox.json';
export function h<K extends keyof HTMLElementTagNameMap>(
  tag: K, cls = '', text = ''
): HTMLElementTagNameMap[K] {
  const el = document.createElement(tag);
  if (cls) el.className = cls;
  if (text) el.textContent = text;
  return el;
}

export function root(): HTMLElement {
  return document.getElementById('ui-root')!;
}

export function fmt(n: number): string {
  if (n >= 1_000_000) return (n / 1_000_000).toFixed(1) + 'M';
  if (n >= 10_000) return (n / 1_000).toFixed(1) + 'k';
  return String(n);
}

export interface WinOpts {
  size?: 'small' | 'normal' | 'large';
  /** true = mở HẲN MỘT TRANG chiếm trọn màn (kiểu GunPow) thay vì popup nhỏ. */
  page?: boolean;
  onClose?: () => void;
}

const openWindows: HTMLElement[] = [];

// Phaser nghe pointerdown trên window ở pha CAPTURE, nên stopPropagation của
// backdrop (pha bubble) không chặn được -> chạm vào popup vẫn lọt xuống thế giới
// (ví dụ bấm ô trong popup mà trúng chỗ nhân vật thì mở luôn menu bản thân).
// Vì vậy báo cho scene tắt input khi còn popup đang mở.
export function anyWindowOpen(): boolean { return openWindows.length > 0; }
function syncModal() { bus.emit('ui:modal', openWindows.length > 0); }

export function openWindow(title: string, opts: WinOpts = {}): { body: HTMLElement; win: HTMLElement; close: () => void; tabs: (names: string[], onPick: (i: number) => void, icons?: string[]) => void } {
  const backdrop = h('div', `win-backdrop ${opts.page ? 'page-backdrop' : ''}`);
  const win = h('div', `win ${opts.page ? 'win-page' : opts.size === 'small' ? 'small' : opts.size === 'large' ? 'large' : ''}`);
  const head = h('div', 'win-head');
  const titleEl = h('div', '', title);
  // Trang đầy đủ: tên đặt trên tấm bảng kính bo tròn, không thêm hoa văn hai bên
  if (opts.page) {
    titleEl.className = 'win-title';
    titleEl.textContent = '';
    titleEl.append(h('span', 'win-title-t', title));
  }
  // trang đầy đủ dùng nút quay lại ở góc trái, popup dùng dấu X góc phải
  const closeBtn = h('button', opts.page ? 'win-back' : 'win-close', opts.page ? '‹ Quay lại' : '✕');
  head.append(titleEl);
  const body = h('div', 'win-body');
  // trang đầy đủ: nút quay lại nằm TRONG thanh tiêu đề (không thì nó bị canh
  // theo cả trang rồi rơi xuống giữa màn, đè lên nội dung)
  if (opts.page) { head.append(closeBtn); win.append(head, body); }
  else win.append(head, body, closeBtn);
  backdrop.append(win);
  root().append(backdrop);
  openWindows.push(backdrop);
  syncModal();

  root().style.pointerEvents = 'auto';

  const close = () => {
    backdrop.remove();
    const i = openWindows.indexOf(backdrop);
    if (i >= 0) openWindows.splice(i, 1);
    if (!openWindows.length) root().style.pointerEvents = '';
    syncModal();
    opts.onClose?.();
  };
  closeBtn.onclick = close;
  if (!opts.page) backdrop.onclick = e => { if (e.target === backdrop) close(); };
  backdrop.addEventListener('pointerdown', e => e.stopPropagation());
  backdrop.addEventListener('touchstart', e => e.stopPropagation(), { passive: false });

  const tabs = (names: string[], onPick: (i: number) => void, icons?: string[]) => {
    const bar = h('div', 'win-tabs');
    names.forEach((n, i) => {
      const t = h('div', `tab ${i === 0 ? 'active' : ''}`);
      if (icons?.[i]) t.append(uiIcon(icons[i], 18));
      t.append(h('span', '', n));
      t.onclick = () => {
        bar.querySelectorAll('.tab').forEach(x => x.classList.remove('active'));
        t.classList.add('active');
        onPick(i);
      };
      bar.append(t);
    });
    win.insertBefore(bar, body);
  };

  return { body, win, close, tabs };
}

export function closeAllWindows() {
  for (const w of [...openWindows]) w.remove();
  openWindows.length = 0;
  syncModal();
}

// nút giá tiền có icon xu/ruby thật (thay cho "🪙123")
export function priceBtn(xu: number, cls = 'gold', onClick?: () => void, ruby = 0): HTMLButtonElement {
  const b = h('button', `btn ${cls}`);
  b.innerHTML = priceHtml(xu, ruby);
  if (onClick) b.onclick = onClick;
  return b;
}

export function btn(label: string, cls = '', onClick?: () => void): HTMLButtonElement {
  const b = h('button', `btn ${cls}`, label);
  if (onClick) b.onclick = onClick;
  return b;
}

/** Ô chạy dải sprite skin — trượt ảnh trong khung cắt, mỗi bước một khung.
 *
 * Không dùng background-position vì đơn vị % của nó tính theo phần ẢNH THỪA
 * chứ không phải bề rộng ô, nên bước nhảy sai. transform: translateX(%) thì
 * tính theo chính bề rộng ảnh -> chia đều đúng số khung.
 */
export function skinFrames(art: { url: string; w: number; h: number; frames: number }): HTMLElement {
  const box = h('div', 'skin-anim');
  box.style.aspectRatio = `${art.w} / ${art.h}`;
  const img = document.createElement('img');
  img.src = art.url;
  img.draggable = false;
  img.style.animationDuration = `${(art.frames / 6).toFixed(2)}s`;
  img.style.animationTimingFunction = `steps(${art.frames})`;
  box.append(img);
  return box;
}

// ===== Sprite từ asset pack trong UI DOM =====
// Cắt 1 vùng (sx,sy,sw,sh) từ sheet và phóng to size px (pixelated).
export function spr(url: string, sx: number, sy: number, sw: number, sh: number, size = 32): HTMLElement {
  const k = size / sw;
  const wrap = h('div', 'spr');
  wrap.style.cssText = `width:${Math.round(sw * k)}px;height:${Math.round(sh * k)}px;overflow:hidden;position:relative;image-rendering:pixelated;`;
  const img = document.createElement('img');
  img.src = url;
  img.draggable = false;
  img.style.cssText = `position:absolute;left:${-sx * k}px;top:${-sy * k}px;transform:scale(${k});transform-origin:0 0;image-rendering:pixelated;max-width:none;`;
  // sheet ít biến thể màu hơn dự kiến -> lùi về biến thể 0
  img.onload = () => {
    if (sx + sw > img.naturalWidth) img.style.left = '0px';
    if (sy + sh > img.naturalHeight) img.style.top = '0px';
  };
  wrap.append(img);
  return wrap;
}

export interface SpriteRef { url: string; sx: number; sy: number; sw: number; sh: number }

// ===== Icon UI (Avatar iconmenu/iconshop + Cozy UI pack + icon cắt từ asset game) =====
// Mỗi tên phải trỏ tới đúng hình nó mô tả — không dùng icon "cho có".
const ICON_SRC: Record<string, string> = {
  // tiền tệ & UI chung (Cozy UI pack)
  coin: 'assets/ui/pack/icon_coin.png',
  ruby: 'assets/ui/pack/icon_ruby.png',
  rank: 'assets/ui/pack/icon_trophy.png',
  shop: 'assets/ui/pack/icon_shop.png',
  inventory: 'assets/ui/pack/icon_inventory.png',
  wardrobe: 'assets/ui/pack/icon_wardrobe.png',
  quest: 'assets/ui/pack/icon_quest.png',
  collection: 'assets/ui/pack/icon_collection.png',
  social: 'assets/ui/pack/icon_social.png',
  // cắt từ asset trong game (xem public/assets/ui/act)
  sit: 'assets/ui/act/sit.png',
  lie: 'assets/ui/act/lie.png',
  runner: 'assets/ui/act/run.png',
  player: 'assets/ui/act/player.png',
  feed: 'assets/farm/chibi/wheat.png',
  barn: 'assets/ui/act/barn.png',
  tree: 'assets/ui/act/tree.png',
  rod: 'assets/ui/act/rod.png',
  pet: 'assets/ui/act/pet.png',
  seed: 'assets/farm/chibi/16_seed_bag.png',
  minigame: 'assets/ui/act/minigame.png',
  gift: 'assets/ui/act/gift.png',
  cake: 'assets/ui/act/cake.png',
  choco: 'assets/ui/act/choco.png',
  teddy: 'assets/ui/act/teddy.png',
  ticket: 'assets/ui/act/ticket.png',
  w_sunny: 'assets/ui/act/w_sunny.png',
  w_rain: 'assets/ui/act/w_rain.png',
  w_cloudy: 'assets/ui/act/w_cloudy.png',
  w_snow: 'assets/ui/act/w_snow.png',
  w_leaf: 'assets/ui/act/w_leaf.png',
  w_flower: 'assets/ui/act/w_flower.png',
  fish: 'assets/ui/act/fish.png',
  bus: 'assets/ui/act/bus.png',
  house: 'assets/ui/act/house.png',
  heart: 'assets/ui/act/heart.png',
  plant: 'assets/pack2/icons/wheat.png',
  fertilizer: 'assets/farm/chibi/fertilizer.png',
  hoe: 'assets/farm/chibi/18_hoe.png',
  can: 'assets/farm/chibi/17_watering_can.png',
  net: 'assets/ui/act/tool_net.png',
  axe: 'assets/farm/chibi/20_axe.png',
  basket: 'assets/farm/chibi/19_sickle.png',
  check: 'assets/ui/pack/icon_check.png',
  alert: 'assets/ui/pack/icon_alert.png',
  mail: 'assets/ui/pack/icon_mail.png',
  level: 'assets/ui/pack/icon_level.png',
  calendar: 'assets/ui/pack/icon_calendar.png',
  wheel: 'assets/ui/pack/icon_wheel.png',
  emote: 'assets/ui/pack/icon_emote.png',
  map: 'assets/ui/pack/icon_map.png',
  settings: 'assets/ui/pack/icon_settings.png',
  act_kiss: 'assets/ui/act/act_kiss.png',
  act_hug: 'assets/ui/act/act_hug.png',
  act_kick: 'assets/ui/act/act_kick.png',
  act_pat: 'assets/ui/act/act_pat.png'
};

// ===== Bảng danh hiệu (vẽ thành ảnh, dùng chung cho UI và trên đầu nhân vật) =====
export function titleCanvas(name: string, color: string, scale = 1): HTMLCanvasElement {
  const cv = document.createElement('canvas');
  const ctx = cv.getContext('2d')!;
  const font = `bold ${11 * scale}px "Segoe UI", system-ui, sans-serif`;
  ctx.font = font;
  const tw = ctx.measureText(name).width;
  const padX = 12 * scale, w = Math.ceil(tw + padX * 2), hgt = Math.round(19 * scale);
  cv.width = w; cv.height = hgt;
  const c = cv.getContext('2d')!;
  c.font = font; c.textAlign = 'center'; c.textBaseline = 'middle';
  // nền
  const g = c.createLinearGradient(0, 0, 0, hgt);
  g.addColorStop(0, '#4a3418'); g.addColorStop(1, '#2b1d0c');
  const r = 6 * scale;
  c.beginPath();
  c.moveTo(r, 0); c.lineTo(w - r, 0); c.quadraticCurveTo(w, 0, w, r);
  c.lineTo(w, hgt - r); c.quadraticCurveTo(w, hgt, w - r, hgt);
  c.lineTo(r, hgt); c.quadraticCurveTo(0, hgt, 0, hgt - r);
  c.lineTo(0, r); c.quadraticCurveTo(0, 0, r, 0); c.closePath();
  c.fillStyle = g; c.fill();
  c.lineWidth = Math.max(1, scale); c.strokeStyle = '#d3a13c'; c.stroke();
  // hai viên ngọc hai đầu
  c.fillStyle = '#ffd97a';
  for (const x of [padX * 0.45, w - padX * 0.45]) {
    c.beginPath(); c.arc(x, hgt / 2, 2.2 * scale, 0, Math.PI * 2); c.fill();
  }
  // chữ
  c.fillStyle = 'rgba(0,0,0,.55)';
  c.fillText(name, w / 2, hgt / 2 + Math.max(1, scale));
  c.fillStyle = color;
  c.fillText(name, w / 2, hgt / 2);
  return cv;
}

// bản dùng trong DOM
// Danh hiệu nào đã có ảnh nhãn riêng (assets/title/<id>.png) thì dùng ảnh,
// chưa có thì vẽ tạm bằng canvas như cũ.
export function titlePlaque(name: string, color: string, scale = 1, id?: string): HTMLElement {
  if (id && TITLES[id]?.art) {
    const img = document.createElement('img');
    img.src = `assets/title/${id}.png`;
    img.alt = name;
    img.draggable = false;
    img.style.cssText = `display:block;height:${Math.round(26 * scale)}px;width:auto;`;
    return img;
  }
  const cv = titleCanvas(name, color, scale);
  cv.style.cssText = 'display:block;image-rendering:auto';
  return cv;
}

// tên nhân vật (kèm hội nhóm trong ngoặc) vẽ thành ảnh, đặt dưới bảng danh hiệu
export function nameCanvas(name: string, guild?: string, scale = 1): HTMLCanvasElement {
  const cv = document.createElement('canvas');
  const ctx = cv.getContext('2d')!;
  const gtxt = guild ? `(${guild})` : '';
  const fontG = `bold ${10 * scale}px "Segoe UI", system-ui, sans-serif`;
  const fontN = `bold ${11 * scale}px "Segoe UI", system-ui, sans-serif`;
  ctx.font = fontG; const gw = guild ? ctx.measureText(gtxt).width : 0;
  ctx.font = fontN; const nw = ctx.measureText(name).width;
  const pad = 4 * scale;
  cv.width = Math.ceil(gw + nw + pad * 2 + (guild ? 2 * scale : 0)); cv.height = Math.round(16 * scale);
  const c = cv.getContext('2d')!;
  c.textBaseline = 'middle';
  const y = cv.height / 2;
  let x = pad;
  const stroke = (t: string, col: string, f: string) => {
    c.font = f; c.lineJoin = 'round';
    c.lineWidth = 3 * scale; c.strokeStyle = 'rgba(20,12,4,.85)'; c.strokeText(t, x, y);
    c.fillStyle = col; c.fillText(t, x, y);
    x += c.measureText(t).width;
  };
  if (guild) { stroke(gtxt, '#7ee0a8', fontG); x += 2 * scale; }
  stroke(name, '#fff8e8', fontN);
  return cv;
}

// đường dẫn ảnh của 1 tên icon (dùng khi cần vẽ lên canvas)
export function iconUrl(name: string): string {
  return ICON_SRC[name] ?? `assets/ui/av/${name}.png`;
}

export function uiIcon(name: string, size = 22): HTMLElement {
  const img = document.createElement('img');
  img.src = ICON_SRC[name] ?? `assets/ui/av/${name}.png`;
  img.draggable = false;
  img.style.cssText = `width:${size}px;height:${size}px;object-fit:contain;vertical-align:middle;flex:none`;
  return img;
}

// icon tiền tệ (dùng thay 🪙 / 💎)
export function coinIcon(size = 16): HTMLElement {
  const img = document.createElement('img');
  img.src = 'assets/ui/pack/icon_coin.png';
  img.style.cssText = `width:${size}px;height:${size}px;object-fit:contain;vertical-align:-2px;flex:none`;
  return img;
}
export function rubyIcon(size = 16): HTMLElement {
  const img = document.createElement('img');
  img.src = 'assets/ui/pack/icon_ruby.png';
  img.style.cssText = `width:${size}px;height:${size}px;object-fit:contain;vertical-align:-2px;flex:none`;
  return img;
}

// chuỗi HTML giá tiền có icon (dùng trong innerHTML)
export function priceHtml(xu?: number, ruby?: number): string {
  const parts: string[] = [];
  if (xu) parts.push(`<img class="cur" src="assets/ui/pack/icon_coin.png">${fmt(xu)}`);
  if (ruby) parts.push(`<img class="cur" src="assets/ui/pack/icon_ruby.png">${ruby}`);
  return parts.join(' ');
}

// ===== Khung bong bóng chat (xem src/data/bubbles.ts) =====
// Khung động có 2 khung hình -> nhét sẵn một @keyframes đổi border-image-source
// cho từng khung (chỉ tạo 1 lần cho mỗi loại).
const bubbleAnimAdded = new Set<string>();

function ensureBubbleAnim(id: string) {
  if (bubbleAnimAdded.has(id)) return;
  bubbleAnimAdded.add(id);
  let sheet = document.getElementById('bubble-anim') as HTMLStyleElement | null;
  if (!sheet) {
    sheet = document.createElement('style');
    sheet.id = 'bubble-anim';
    document.head.append(sheet);
  }
  sheet.append(document.createTextNode(
    `@keyframes bub-${id}{0%,49.9%{border-image-source:url(${bubbleUrl(id)})}`
    + `50%,100%{border-image-source:url(${bubbleUrl(id, true)})}}`));
}

/** Đắp khung mua ở cửa hàng lên một bong bóng chat.
 *  `k` thu nhỏ viền so với ảnh gốc (khung gốc to hơn bong bóng chat). */
export function applyBubbleSkin(el: HTMLElement, id: string, k = 0.55) {
  const b = BUBBLE_BY_ID[id];
  if (!b || b.id === 'b_default') return;
  const [t, r, bo, l] = b.slice;
  const bw = (v: number) => `${Math.round(v * k)}px`;
  el.classList.add('skin');
  el.style.borderImage = `url(${bubbleUrl(id)}) ${t} ${r} ${bo} ${l} fill stretch`;
  el.style.borderWidth = `${bw(t)} ${bw(r)} ${bw(bo)} ${bw(l)}`;
  el.style.borderStyle = 'solid';
  el.style.background = 'none';
  el.style.boxShadow = 'none';
  el.style.padding = '2px 8px';
  if (b.anim) {
    ensureBubbleAnim(id);
    el.style.animation = `bub-${id} 1s infinite`;
  }
}

// ===== Emoji chat (biểu cảm động, bóc từ GunPow — xem src/data/emoji.ts) =====
// Mỗi emoji là một dải ngang: đặt background-size = số khung x 100% rồi cho
// background-position chạy bằng steps() là ra hoạt hình, không cần canvas.
export function emojiEl(id: string, size = 28): HTMLElement {
  const d = EMOJI_BY_ID[id];
  const e = h('span', 'emo');
  if (!d) return e;
  const k = size / Math.max(d.w, d.h);
  const w = Math.round(d.w * k);
  e.style.width = `${w}px`;
  e.style.height = `${Math.round(d.h * k)}px`;
  e.style.backgroundImage = `url(${emojiUrl(id)})`;
  e.style.backgroundSize = `${w * d.frames}px 100%`;
  e.style.setProperty('--emo-end', `-${w * d.frames}px`);
  e.style.animationDuration = `${d.dur}s`;
  e.style.animationTimingFunction = `steps(${d.frames})`;
  return e;
}

/** Chuỗi có mã emoji `[e01]` -> các nút text + emoji để nhét vào bong bóng chat. */
export function richText(text: string, size = 26): DocumentFragment {
  const frag = document.createDocumentFragment();
  let last = 0;
  EMOJI_RE.lastIndex = 0;
  for (let m = EMOJI_RE.exec(text); m; m = EMOJI_RE.exec(text)) {
    if (m.index > last) frag.append(document.createTextNode(text.slice(last, m.index)));
    frag.append(EMOJI_BY_ID[m[1]] ? emojiEl(m[1], size) : document.createTextNode(m[0]));
    last = m.index + m[0].length;
  }
  if (last < text.length) frag.append(document.createTextNode(text.slice(last)));
  return frag;
}

/** Bỏ mã emoji khỏi chuỗi (chỗ nào chỉ hiện được chữ thuần). */
export function stripEmoji(text: string): string {
  return text.replace(EMOJI_RE, '').replace(/\s+/g, ' ').trim();
}

// Icon vật phẩm: ưu tiên sprite thật, thiếu mới dùng emoji
export function iconOf(def: { icon: string; sprite?: SpriteRef }, size = 32): HTMLElement {
  if (def.sprite) {
    const s = def.sprite;
    return spr(s.url, s.sx, s.sy, s.sw, s.sh, size);
  }
  const e = h('div', 'ico', def.icon);
  e.style.fontSize = `${Math.round(size * 0.8)}px`;
  return e;
}

// Xem trước 1 part chibi (frame đứng) — cắt vừa khít phần có hình
export function chibiPreview(partId: number, size = 48): HTMLElement {
  const b = (BBOX as Record<string, number[]>)[String(partId)];
  if (b) {
    const [x, y, w, hh] = b;
    const k = size / Math.max(w, hh);        // vừa khung vuông `size`
    return spr(`assets/chibi/${partId}.png`, x, y, w, hh, Math.round(w * k));
  }
  return spr(`assets/chibi/${partId}.png`, 0, 0, 64, 96, Math.round(size * 64 / 96));
}

// Xem trước cận đầu (tóc/mắt/mũ/kính nhìn rõ hơn full thân); z để chọn vùng cắt
export function chibiHead(partId: number, size = 40, z?: number): HTMLElement {
  // theo bbox thực tế của part: mắt ~y46-56, tóc ~y18-66 -> cắt trúng vùng hiển thị
  if (z === 40 || z === 65) return spr(`assets/chibi/${partId}.png`, 18, 40, 30, 22, size);
  if (z === 50 || z === 60) return spr(`assets/chibi/${partId}.png`, 8, 16, 48, 50, size);
  return spr(`assets/chibi/${partId}.png`, 10, 18, 44, 54, size);
}

// Chân dung chibi ghép lớp (avatar HUD, hồ sơ)
/** Nhân vật chibi CO GIÃN THEO KHUNG (không phải cỡ px cố định).
 *
 * charFace() trả về ảnh cỡ px cứng, nên trong khung flex thấp (màn ngang điện
 * thoại) nó tự quyết chiều cao rồi làm phình khung và bị cắt mất chân. Bản này
 * vẽ mỗi lớp bằng background-image trên div phủ kín khung: mọi strip part đều
 * là 15 frame 64x96 nên chỉ cần background-size 1500% 100% là ra frame 0, và
 * khung to nhỏ bao nhiêu thì nhân vật co giãn theo bấy nhiêu.
 */
export function charFaceFluid(look: import('@/data/chibi').ChibiLook | undefined): HTMLElement {
  const wrap = h('div', 'chibi-fluid');
  if (!look) return wrap;
  // skin nguyên hình (Pack4): một ảnh thay cả nhân vật
  const art = skinArt(look.skin);
  if (art) {
    wrap.classList.add('art');
    wrap.append(skinFrames(art));
    return wrap;
  }
  for (const pid of lookLayers(look)) {
    const l = h('div', 'chibi-fluid-l');
    l.style.backgroundImage = `url(assets/chibi/${pid}.png)`;
    wrap.append(l);
  }
  return wrap;
}

export function charFace(look: import('@/data/chibi').ChibiLook | undefined, size = 40): HTMLElement {
  const wrap = h('div');
  const w = Math.round(size * 64 / 96);
  wrap.style.cssText = `width:${w}px;height:${size}px;position:relative;`;
  if (!look) return wrap;
  const art = skinArt(look.skin);
  if (art) {
    wrap.style.width = `${Math.round(size * art.w / art.h)}px`;
    wrap.append(skinFrames(art));
    return wrap;
  }
  for (const pid of lookLayers(look)) {
    const el = spr(`assets/chibi/${pid}.png`, 0, 0, 64, 96, w);
    el.style.position = 'absolute';
    el.style.left = '0'; el.style.top = '0';
    wrap.append(el);
  }
  return wrap;
}

// Ảnh đại diện: ảnh pack / ảnh tự tải lên, không có thì dùng đầu chibi
export function avatarEl(size = 40): HTMLElement {
  const pic = S.player.avatarPic;
  if (pic) {
    // Ảnh pack là hình vuông bo góc: góc bo trong suốt nên viền tròn bị hở
    // 4 chỗ chéo (chỉ phủ kín khi bán kính bo <= 0.17 * bán kính tròn).
    // Phóng nhẹ 6% rồi cắt tròn -> tròn đều, không còn "ngoài tròn trong vuông".
    const wrap = h('div', 'ava-img');
    wrap.style.cssText =
      `width:${size}px;height:${size}px;border-radius:50%;overflow:hidden;flex:none;`;
    const img = document.createElement('img');
    img.src = picSrc(pic);
    img.draggable = false;
    img.style.cssText = 'width:100%;height:100%;object-fit:cover;display:block;transform:scale(1.06);';
    wrap.append(img);
    return wrap;
  }
  return charHeadOnly(avatarLook(), size);
}

// Cắt vuông ở giữa + thu nhỏ -> data URL, dùng cho ảnh đại diện người chơi tự tải lên.
// JPEG 128px ~8KB nên nhét vào save (localStorage) vẫn thoải mái.
export function squareThumb(img: HTMLImageElement, size = 128): string {
  const s = Math.min(img.naturalWidth, img.naturalHeight);
  const sx = (img.naturalWidth - s) / 2, sy = (img.naturalHeight - s) / 2;
  const cv = document.createElement('canvas');
  cv.width = cv.height = size;
  const ctx = cv.getContext('2d')!;
  ctx.imageSmoothingQuality = 'high';
  ctx.drawImage(img, sx, sy, s, s, 0, 0, size, size);
  return cv.toDataURL('image/jpeg', 0.85);
}

// Look dùng cho ảnh đại diện: giống nhân vật nhưng có thể đổi riêng biểu cảm
export function avatarLook(): import('@/data/chibi').ChibiLook | undefined {
  const c = S.player.chibi;
  if (!c) return undefined;
  const face = S.player.avatarFace;
  return face ? { ...c, eyes: face } : c;
}

// Chỉ phần đầu chibi (tóc, mắt, kính, nón) — dùng cho HUD avatar
export function charHeadOnly(look: import('@/data/chibi').ChibiLook | undefined, size = 40): HTMLElement {
  // ảnh part là strip 15 frame 64x96 -> phải cắt bằng spr() (scale + overflow),
  // không được set width trực tiếp lên <img> (sẽ bóp cả strip lại).
  // bbox thật: tóc (10,18,48,50), mắt (22,46,44,56), thân (8,28,49,64)
  // -> đầu nằm trong x8..49 (tâm 28.5), y18..62. Cắt vuông quanh tâm đó cho khung tròn.
  const SX = 6, SY = 16, SW = 46, SH = 46;
  const w = Math.round(SW * size / SH);
  const wrap = h('div');
  wrap.style.cssText = `width:${w}px;height:${size}px;position:relative;overflow:hidden;`;
  if (!look) return wrap;
  for (const pid of lookLayers(look)) {
    const el = spr(`assets/chibi/${pid}.png`, SX, SY, SW, SH, w);
    el.style.position = 'absolute';
    el.style.left = '0'; el.style.top = '0';
    wrap.append(el);
  }
  return wrap;
}
