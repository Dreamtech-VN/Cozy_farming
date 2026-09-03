/** Helper dựng panel/toast (doc 12 — overlay, đủ trạng thái, confirm khi mất tài nguyên). */
const panels = document.getElementById('panels');
const toastStack = document.getElementById('toast-stack');

export const el = (tag, props = {}, children = []) => {
  const node = document.createElement(tag);
  for (const [key, value] of Object.entries(props)) {
    if (key === 'class') node.className = value;
    else if (key === 'text') node.textContent = value;
    else if (key === 'html') node.innerHTML = value;
    else if (key.startsWith('on')) node.addEventListener(key.slice(2).toLowerCase(), value);
    else if (value !== null && value !== undefined && value !== false) node.setAttribute(key, value);
  }
  for (const child of [].concat(children)) if (child) node.append(child);
  return node;
};

let openPanel = null;

export function closePanel() {
  openPanel?.remove();
  openPanel = null;
  for (const button of document.querySelectorAll('.icon-btn')) button.setAttribute('aria-pressed', 'false');
}

export function showPanel(title, buildBody, { footer = null, key = null } = {}) {
  closePanel();
  const body = el('div', { class: 'body' });
  const panel = el('div', { class: 'panel' }, [
    el('header', {}, [
      el('h2', { text: title }),
      el('button', { class: 'close', type: 'button', 'aria-label': 'Đóng', text: '×', onClick: closePanel }),
    ]),
    body,
    footer,
  ]);
  panels.append(panel);
  openPanel = panel;

  const render = () => { body.replaceChildren(); buildBody(body, render); };
  render();
  return { panel, body, rerender: render };
}

export function toast(message, kind = '') {
  const node = el('div', { class: `toast ${kind}`.trim(), text: message });
  toastStack.append(node);
  setTimeout(() => node.remove(), 2600);
}

export const emptyState = (message) => el('div', { class: 'empty', text: message });

/** Confirm cho hành động tiêu tài nguyên (doc 12 — interaction rules). */
export function confirmAction(message) {
  return new Promise((resolve) => {
    const overlay = el('div', { class: 'panel', style: 'z-index:20' }, [
      el('header', {}, [el('h2', { text: 'Xác nhận' })]),
      el('div', { class: 'body' }, [el('p', { text: message })]),
      el('div', { class: 'chat-input' }, [
        el('button', { class: 'ghost', type: 'button', text: 'Huỷ', onClick: () => { overlay.remove(); resolve(false); } }),
        el('button', { class: 'primary', type: 'button', text: 'Đồng ý', onClick: () => { overlay.remove(); resolve(true); } }),
      ]),
    ]);
    panels.append(overlay);
  });
}

export const overlay = document.getElementById('overlay');

export function showOverlay(node) {
  overlay.replaceChildren(node);
  overlay.classList.remove('hidden');
}

export function hideOverlay() {
  overlay.classList.add('hidden');
  overlay.replaceChildren();
}
