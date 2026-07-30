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
