/**
 * Lưới nút chức năng trên HUD (doc 12 — world là trung tâm, UI là overlay).
 * Mỗi nút là icon + nhãn, dựng từ một bảng khai báo nên thêm tính năng mới chỉ
 * cần thêm một dòng.
 */
import { el, closePanel, currentPanelKey } from './ui.js';

/**
 * Icon là ảnh thật trong bộ Cozy UI Pack (xem client/assets/ATTRIBUTION.md).
 * Trước đây vẽ bằng SVG nét nên nhìn khô so với mẫu; có bộ art thật rồi thì
 * dùng thẳng, khỏi mô phỏng bằng nét vẽ.
 */
export const icon = (name) =>
  `<img src="/assets/icons/${name}.png" alt="" width="128" height="128" draggable="false">`;

function button(item, game) {
  return el('button', {
    class: 'icon-btn', type: 'button', 'data-key': item.key, title: item.title ?? item.label,
    onClick: () => {
      // Phải so với panel ĐANG mở, không phải trạng thái sáng của nút: panel con
      // mở từ bảng Menu cũng làm nút Menu sáng, khi đó bấm Menu phải mở lại bảng
      // chứ không phải đóng suông.
      const alreadyOpen = currentPanelKey() === item.key;
      closePanel();
      if (!alreadyOpen) item.run(game);
    },
  }, [
    el('span', { class: 'icon-btn-face', html: icon(item.icon) }),
    el('span', { class: 'icon-btn-label', text: item.label }),
    el('i', { class: 'icon-btn-dot hidden' }),
  ]);
}

/**
 * @param handlers các hàm mở panel, truyền từ main.js để module này không phải
 *        biết gì về từng panel cụ thể.
 */
export function buildHudMenus(game, handlers) {
  // Hàng trên phải giữ đúng những thứ bấm liên tục; phần còn lại nằm sau nút
  // Menu để góc màn hình không thành một dãy icon dài.
  const top = [
    { key: 'map', icon: 'map', label: 'Bản đồ', run: handlers.map },
    { key: 'shop', icon: 'shop', label: 'Cửa hàng', run: handlers.shop },
    { key: 'event', icon: 'event', label: 'Sự kiện', run: handlers.event },
    { key: 'menu', icon: 'menu', label: 'Menu', run: handlers.menu },
  ];
  document.getElementById('menu-top').replaceChildren(...top.map((item) => button(item, game)));
}

/** Các mục nằm trong bảng Menu. Dựng ở đây để dùng chung kiểu nút với HUD. */
export function buildMenuPanel(game, body, handlers) {
  const items = [
    { key: 'quests', icon: 'quest', label: 'Nhiệm vụ', run: handlers.quests },
    { key: 'inventory', icon: 'bag', label: 'Túi đồ', run: handlers.inventory },
    { key: 'farm', icon: 'home', label: 'Nông trại', run: handlers.farm },
    { key: 'channel', icon: 'channel', label: 'Đổi khu', run: handlers.channel },
  ];
  body.append(el('div', { class: 'menu-grid' }, items.map((item) => el('button', {
    class: 'menu-item', type: 'button', onClick: () => item.run(game),
  }, [
    el('span', { class: 'icon-btn-face', html: icon(item.icon) }),
    el('span', { class: 'menu-item-label', text: item.label }),
  ]))));
}

/** Bật/tắt chấm đỏ báo việc trên một nút, như các icon có chấm trong mẫu. */
export function markMenuBadge(key, show) {
  const dot = document.querySelector(`.icon-btn[data-key="${key}"] .icon-btn-dot`);
  dot?.classList.toggle('hidden', !show);
}

/** Đánh dấu nút tương ứng khi panel của nó đang mở. */
export function markActiveMenu(key) {
  for (const btn of document.querySelectorAll('.icon-btn')) {
    btn.setAttribute('aria-pressed', btn.dataset.key === key ? 'true' : 'false');
  }
}
