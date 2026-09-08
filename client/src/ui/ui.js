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
let openPanelKey = null;
let openPanelRender = null;

/** Vẽ lại panel đang mở tại chỗ — dùng khi một thiết lập đổi ngoài luồng bấm nút. */
export function rerenderPanel() { openPanelRender?.(); }

/** Panel nào đang mở — nút HUD dựa vào đây để biết bấm lần nữa là đóng hay mở. */
export function currentPanelKey() { return openPanelKey; }

// Esc đóng panel đang mở. Trước đây chỉ có nút × nên panel che mất cụm nút cạnh
// chat mà không có cách nào đóng nhanh bằng bàn phím.
addEventListener('keydown', (event) => {
  if (event.key === 'Escape' && openPanel) { closePanel(); event.stopPropagation(); }
});

export function closePanel() {
  openPanel?.remove();
  openPanel = null;
  openPanelKey = null;
  openPanelRender = null;
  for (const button of document.querySelectorAll('.icon-btn')) button.setAttribute('aria-pressed', 'false');
}

export function showPanel(title, buildBody, { footer = null, key = null, compact = false, fullscreen = false, anchor = null } = {}) {
  closePanel();
  const body = el('div', { class: 'body' });
  // Panel ít nội dung dùng bản hẹp; panel nhiều nhóm cài đặt trải hết màn hình.
  const variant = [compact ? 'compact' : '', fullscreen ? 'fullscreen' : '', anchor ? 'anchored' : ''].filter(Boolean).join(' ');
  const panel = el('div', { class: `panel ${variant}`.trim() }, [
    el('header', {}, [
      el('h2', { text: title }),
      el('button', { class: 'close', type: 'button', 'aria-label': 'Đóng', text: '×', onClick: closePanel }),
    ]),
    body,
    footer,
  ]);
  panels.append(panel);
  openPanel = panel;
  openPanelKey = key;

  // Panel neo dưới một nút: thả ngay dưới nút và canh phải theo nút đó, thay vì
  // nhảy ra giữa màn hình.
  if (anchor) {
    const rect = anchor.getBoundingClientRect();
    panel.style.right = `${Math.max(8, innerWidth - rect.right)}px`;
    panel.style.top = `${rect.bottom + 8}px`;
  }

  const render = () => { body.replaceChildren(); buildBody(body, render); };
  openPanelRender = render;
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

/**
 * @param backdrop 'entry' | 'server' | 'character' | 'loading' | null — tranh nền cho các màn ngoài game.
 *   Match-3 cũng dùng lớp phủ này nhưng nó nằm TRONG game, không được dán tranh
 *   màn đăng nhập lên, nên tranh nền là thứ phải xin chứ không mặc định.
 */
export function showOverlay(node, { backdrop = null, logo = true } = {}) {
  overlay.classList.remove('backdrop-entry', 'backdrop-server', 'backdrop-character', 'backdrop-loading');
  if (backdrop) overlay.classList.add(`backdrop-${backdrop}`);
  // Logo là ảnh rời, gắn ở đây một chỗ cho mọi màn ngoài game — nhét vào từng
  // màn thì bốn nơi phải nhớ cùng một việc.
  // Màn tạo nhân vật tự có biển gỗ tiêu đề của nó và cần hết chiều cao cho
  // nhân vật, nên tắt logo — chứ không phải màn nào có tranh nền cũng đội logo.
  overlay.replaceChildren(...(backdrop && logo
    ? [el('img', { class: 'entry-logo', src: '/assets/ui/logo.png', alt: 'Sunny Town' }), node]
    : [node]));
  overlay.classList.remove('hidden');
}

export function hideOverlay() {
  overlay.classList.add('hidden');
  overlay.classList.remove('backdrop-entry', 'backdrop-server', 'backdrop-character', 'backdrop-loading');
  overlay.replaceChildren();
}

/**
 * Bọc một nút gửi request: khoá nút trong lúc chờ rồi mở lại.
 *
 * Không khoá thì bấm nhanh hai lần là gửi hai request — với những thao tác đổi
 * tài nguyên thì đó là hai giao dịch.
 */
export function bindSubmit(button, run) {
  button.addEventListener('click', async () => {
    if (button.disabled) return;
    const label = button.textContent;
    button.disabled = true;
    button.textContent = 'Đang xử lý…';
    try {
      await run();
    } finally {
      button.disabled = false;
      button.textContent = label;
    }
  });
  return button;
}

/**
 * Ô nhập kèm nhãn hiện rõ và chỗ để báo lỗi ngay dưới ô.
 * Placeholder không thay được nhãn: gõ vào là placeholder biến mất.
 */
export function labelledInput(labelText, attrs) {
  const id = `f_${Math.random().toString(36).slice(2, 9)}`;
  const input = el('input', { id, ...attrs });
  const error = el('p', { class: 'field-error hidden', id: `${id}_err`, role: 'alert' });
  input.setAttribute('aria-describedby', error.id);
  const wrap = el('div', {}, [el('label', { for: id, text: labelText }), input, error]);
  return {
    wrap,
    input,
    get value() { return input.value; },
    clear() { input.value = ''; },
    setError(message) {
      error.textContent = message ?? '';
      error.classList.toggle('hidden', !message);
      input.setAttribute('aria-invalid', message ? 'true' : 'false');
      if (message) input.focus();
    },
  };
}
