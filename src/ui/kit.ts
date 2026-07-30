// Bộ công cụ dựng UI DOM nhỏ gọn
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

export function openWindow(title: string, opts: WinOpts = {}): { body: HTMLElement; win: HTMLElement; close: () => void; tabs: (names: string[], onPick: (i: number) => void) => void } {
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

  const tabs = (names: string[], onPick: (i: number) => void) => {
    const bar = h('div', 'win-tabs');
    names.forEach((n, i) => {
      const t = h('div', `tab ${i === 0 ? 'active' : ''}`, n);
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

// Xem trước 1 món thời trang (frame walk-down đầu tiên của biến thể màu)
export function wearPreview(kind: 'hair' | 'clothes' | 'acc' | 'base' | 'eyes', id: string, variant = 0, size = 40): HTMLElement {
  const url = kind === 'base' ? `assets/char/base/${id}.png` : `assets/char/${kind}/${id}.png`;
  return spr(url, variant * 256, 0, 32, 32, size);
}

// Chân dung nhân vật ghép lớp (dùng cho avatar HUD, hồ sơ)
export function charFace(a: { charIndex: number; hairStyle: string; hairColor: number; eyesColor: number; clothes: string; clothesColor: number; acc: string[] }, size = 40): HTMLElement {
  const wrap = h('div');
  wrap.style.cssText = `width:${size}px;height:${size}px;position:relative;image-rendering:pixelated;`;
  const layer = (kind: 'hair' | 'clothes' | 'acc' | 'base' | 'eyes', id: string, variant: number) => {
    const el = wearPreview(kind, id, variant, size);
    el.style.position = 'absolute';
    el.style.left = '0'; el.style.top = '0';
    wrap.append(el);
  };
  layer('base', `char${a.charIndex + 1}`, 0);
  layer('eyes', 'eyes', a.eyesColor);
  layer('clothes', a.clothes, a.clothesColor);
  layer('hair', a.hairStyle, a.hairColor);
  for (const acc of a.acc) layer('acc', acc, 0);
  return wrap;
}
