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

  const close = () => {
    backdrop.remove();
    const i = openWindows.indexOf(backdrop);
    if (i >= 0) openWindows.splice(i, 1);
    opts.onClose?.();
  };
  closeBtn.onclick = close;
  backdrop.onclick = e => { if (e.target === backdrop) close(); };

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

// ===== Icon UI (Avatar iconmenu/iconshop + Cozy UI pack) =====
export function uiIcon(name: string, size = 22): HTMLElement {
  const img = document.createElement('img');
  img.src = `assets/ui/av/${name}.png`;
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
