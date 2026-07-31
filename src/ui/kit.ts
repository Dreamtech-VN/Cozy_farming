// Bộ công cụ dựng UI DOM nhỏ gọn
import { lookLayers } from '@/data/chibi';
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
  if (n >= 10_000) return (n / 1_000).toFixed(1) + 'K';
  return String(n);
}

export interface WinOpts { size?: 'small' | 'normal' | 'large'; onClose?: () => void }

const openWindows: HTMLElement[] = [];

export function openWindow(title: string, opts: WinOpts = {}): { body: HTMLElement; win: HTMLElement; close: () => void; tabs: (names: string[], onPick: (i: number) => void, icons?: string[]) => void } {
  const backdrop = h('div', 'win-backdrop');
  const win = h('div', `win ${opts.size === 'small' ? 'small' : opts.size === 'large' ? 'large' : ''}`);
  const head = h('div', 'win-head');
  const titleEl = h('div', '', title);
  const closeBtn = h('button', 'win-close', '✕');
  head.append(titleEl, closeBtn);
  const body = h('div', 'win-body');
  win.append(head, body);
  backdrop.append(win);
  root().append(backdrop);
  openWindows.push(backdrop);

  root().style.pointerEvents = 'auto';

  const close = () => {
    backdrop.remove();
    const i = openWindows.indexOf(backdrop);
    if (i >= 0) openWindows.splice(i, 1);
    if (!openWindows.length) root().style.pointerEvents = '';
    opts.onClose?.();
  };
  closeBtn.onclick = close;
  backdrop.onclick = e => { if (e.target === backdrop) close(); };
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
  shovel: 'assets/ui/act/tool_shovel.png',
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
export function titlePlaque(name: string, color: string, scale = 1): HTMLElement {
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
export function charFace(look: import('@/data/chibi').ChibiLook | undefined, size = 40): HTMLElement {
  const wrap = h('div');
  const w = Math.round(size * 64 / 96);
  wrap.style.cssText = `width:${w}px;height:${size}px;position:relative;`;
  if (!look) return wrap;
  for (const pid of lookLayers(look)) {
    const el = spr(`assets/chibi/${pid}.png`, 0, 0, 64, 96, w);
    el.style.position = 'absolute';
    el.style.left = '0'; el.style.top = '0';
    wrap.append(el);
  }
  return wrap;
}
